import { Server } from 'socket.io';
import { db } from './db';
import { eq, and, like, sql } from 'drizzle-orm';
import jwt from "jsonwebtoken";
import { rooms, players, gameSessions, playerAnswers, users } from './db/schema';
import triviaService from './services/trivia.service';
import { Socket } from './types/user.types';
import { CreateGameType } from './types/game.types';

export function setupSockets(io: Server) {
    io.use(async (socket: Socket, next) => {
        try {
            let token = socket.handshake.headers?.auth || "";
            if (!token) {
                token = (socket.handshake.auth.token as string) ?? "";
            }
            if (!token || typeof token !== "string") {
                return next(new Error("Authentication error"));
            }

            const data = jwt.verify(token, "secretKey") as {
                id: string;
                email: string;
            };
            const user = await db.select().from(users).where(eq(users.id, Number(data.id)));
            if (user.length == 0) {
                return next(new Error("Authentication error"));
            }
            const { password, ...foundUser } = user[0];
            socket.user = foundUser;
            next();
        } catch (err) {
            next(new Error("Authentication error"));
        }
    }).on('connection', (socket: Socket) => {
        console.log("connected client " + socket.id);

        socket.on('create_room', async () => {
            const roomCode = generateRoomCode();
            const [room] = await db.insert(rooms).values({
                roomCode: roomCode,
            }).$returningId();

            const playerData = {
                userId: Number(socket.user!.id),
                roomId: room.id,
                socketId: socket.id,
                isHost: true
            };

            const [player] = await db.insert(players).values(playerData).$returningId();

            const host = await db.select(
                {
                    playerId: players.id,
                    name: users.name,
                    avatar: users.avatar,
                    isHost: players.isHost
                }
            ).from(players).
                innerJoin(users, eq(users.id, players.userId)).
                where(eq(players.id, player.id));

            socket.join(roomCode);
            socket.emit('player_joined', { code: roomCode, players: host });
        });

        // Room Joining
        socket.on('join_room', async (data: {roomCode: string, userId: string}) => {
            const room = await db.query.rooms.findFirst({
                where: eq(rooms.roomCode, data.roomCode),
                with: { players: true }
            });

            if (!room || room.players.length >= 2) {
                return socket.emit('join_error', 'Room full or invalid');
            }

            const playerData = {
                userId: Number(data.userId),
                roomId: room.id,
                socketId: socket.id
            };

            await db.insert(players).values(playerData).$returningId();

            const playerList = await db.select({
                playerId: players.id,
                name: users.name,
                avatar: users.avatar,
                isHost: players.isHost
            }).from(players)
                .innerJoin(users, eq(users.id, players.userId))
                .where(eq(players.roomId, room.id))

            socket.join(room.roomCode);

            io.to(room.roomCode).emit('player_joined', {
                code: room.roomCode,
                players: playerList
            });
        });

        // Answer Submission
        socket.on('submit_answer', async (data: {
            sessionId: number;
            playerId: number;
            question: string;
            answer: string;
            correctAnswer: string;
        }) => {
            await db.insert(playerAnswers).values({
                gameSessionId: data.sessionId,
                playerId: data.playerId,
                questionText: data.question,
                selectedAnswer: data.answer,
                correctAnswer: data.correctAnswer,
            });

            const [session, answers] = await Promise.all([
                db.query.gameSessions.findFirst({
                    where: eq(gameSessions.id, data.sessionId)
                }),
                db.query.playerAnswers.findMany({
                    where: eq(playerAnswers.gameSessionId, data.sessionId)
                })
            ]);

            if (typeof session.questions != 'string') return;
            const totalQuestions = JSON.parse(session.questions).length;
            const playerAnswersCount = answers.filter(a => a.playerId === data.playerId).length;

            if (playerAnswersCount >= totalQuestions) {
                socket.emit('player_complete');


                const roomPlayers = await db.query.players.findMany({
                    where: eq(players.roomId, session.roomId)
                });

                const allFinished = roomPlayers.every(player => {
                    const playerAnswers = answers.filter(a => a.playerId === player.id);
                    return playerAnswers.length >= totalQuestions;
                });

                if (allFinished) {
                    const scores = await calculateScores(session.id);
                    const room = await db.select({ roomCode: rooms.roomCode })
                        .from(rooms).where(eq(rooms.id, session.roomId)).limit(1);
                    io.to(room[0].roomCode).emit('game_completed', scores);
                    await db.update(rooms)
                        .set({ status: 'completed' })
                        .where(eq(rooms.id, session.roomId));
                }
            }
        });

        // Reconnection Handler
        socket.on('restore_session', async (roomCode: string, userId: string) => {
            const room = await db.query.rooms.findFirst({
                where: eq(rooms.roomCode, roomCode),
                with: {
                    players: true,
                    gameSessions: {
                        with: { answers: true }
                    }
                }
            });

            if (!room) return socket.emit('restore_error', 'Room not found');

            const player = room.players.find(p => p.userId === Number(userId));
            if (!player) return socket.emit('restore_error', 'Player not found');

            // Update socket ID
            await db.update(players)
                .set({ socketId: socket.id })
                .where(eq(players.id, player.id));

            socket.join(roomCode);

            const response = {
                roomStatus: room.status,
                players: room.players.map(p => ({
                    id: p.id,
                    userId: p.userId,
                    isHost: p.isHost,
                    connected: !!p.socketId
                })),
                currentAnswers: room.gameSessions?.flatMap(e => e.answers).filter(a => a.playerId === player.id)
            };

            if (room.status === 'active' && room.gameSessions) {
                Object.assign(response, {
                    // questions: JSON.parse(room.gameSessions[0].questions),
                    sessionId: room.gameSessions[0].id
                });
            }

            socket.emit('session_restored', response);
        });

        // Disconnect Handler
        socket.on('disconnect', async () => {
            await db.update(players)
                .set({ socketId: null })
                .where(eq(players.socketId, socket.id));
        });
    });
}

// Helper Functions
async function calculateScores(sessionId: number) {
    const results = await db
        .select({
            playerId: playerAnswers.playerId,
            name: users.name,
            avatar: users.avatar,
            total: sql<number>`COUNT(*)`,
            correct: sql<number>`SUM(CASE WHEN ${playerAnswers.selectedAnswer} = ${playerAnswers.correctAnswer} THEN 1 ELSE 0 END)`,
            skipped: sql<number>`SUM(CASE WHEN ${playerAnswers.selectedAnswer} IS NULL THEN 1 ELSE 0 END)`,
            incorrect: sql<number>`SUM(CASE WHEN ${playerAnswers.selectedAnswer} IS NOT NULL AND ${playerAnswers.selectedAnswer} != ${playerAnswers.correctAnswer} THEN 1 ELSE 0 END)`,
        })
        .from(playerAnswers)
        .innerJoin(players, eq(playerAnswers.playerId, players.id))
        .innerJoin(users, eq(players.userId, users.id))
        .where(eq(playerAnswers.gameSessionId, Number(sessionId)))
        .groupBy(playerAnswers.playerId);


    const scores = results.map((row) => {
        const accuracy =
            row.total > 0 ? parseFloat(((row.correct / row.total) * 100).toFixed(2)) : 0;
        return {
            playerId: row.playerId,
            name: row.name,
            avatar: row.avatar,
            total: row.total,
            correct: row.correct,
            incorrect: row.incorrect,
            skipped: row.skipped,
            accuracy,
        };
    });

    return scores;
}

function generateRoomCode() {
    return Math.random().toString(36).substring(2, 6).toUpperCase();
}