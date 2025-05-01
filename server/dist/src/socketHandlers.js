"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.setupSockets = setupSockets;
const db_1 = require("./db");
const drizzle_orm_1 = require("drizzle-orm");
const schema_1 = require("./db/schema");
const trivia_service_1 = __importDefault(require("./services/trivia.service"));
function setupSockets(io) {
    io.on('connection', (socket) => {
        socket.on('create_room', (userId) => __awaiter(this, void 0, void 0, function* () {
            const roomCode = generateRoomCode();
            const [room] = yield db_1.db.insert(schema_1.rooms).values({
                roomCode: roomCode,
            }).$returningId();
            const playerData = {
                userId,
                roomId: room.id,
                socketId: socket.id,
                isHost: true
            };
            yield db_1.db.insert(schema_1.players).values(playerData);
            socket.join(roomCode);
            socket.emit('room_created', { code: roomCode });
        }));
        // Room Joining
        socket.on('join_room', (roomCode, userId) => __awaiter(this, void 0, void 0, function* () {
            const room = yield db_1.db.query.rooms.findFirst({
                where: (0, drizzle_orm_1.eq)(schema_1.rooms.roomCode, roomCode),
                with: { players: true }
            });
            if (!room || room.players.length >= 2) {
                return socket.emit('join_error', 'Room full or invalid');
            }
            const playerData = {
                userId,
                roomId: room.id,
                socketId: socket.id
            };
            yield db_1.db.insert(schema_1.players).values(playerData).$returningId();
            socket.join(roomCode);
            io.to(roomCode).emit('player_joined', {
                userId,
                isHost: room.players.some(p => p.isHost)
            });
        }));
        // Game Start (Host Only)
        socket.on('start_game', (roomCode) => __awaiter(this, void 0, void 0, function* () {
            const room = yield db_1.db.query.rooms.findFirst({
                where: (0, drizzle_orm_1.eq)(schema_1.rooms.roomCode, roomCode),
                with: { players: true }
            });
            if (!room || !room.players.some(p => p.socketId === socket.id && p.isHost)) {
                return socket.emit('game_error', 'Not authorized');
            }
            const questions = yield trivia_service_1.default.getQuestions();
            const sessionData = {
                roomId: room.id,
                questions: JSON.stringify(questions)
            };
            const [session] = yield db_1.db.insert(schema_1.gameSessions).values(sessionData).$returningId();
            yield db_1.db.update(schema_1.rooms)
                .set({ status: 'active' })
                .where((0, drizzle_orm_1.eq)(schema_1.rooms.id, room.id));
            io.to(roomCode).emit('game_started', {
                questions,
                sessionId: session.id
            });
        }));
        // Answer Submission
        socket.on('submit_answer', (data) => __awaiter(this, void 0, void 0, function* () {
            yield db_1.db.insert(schema_1.playerAnswers).values({
                gameSessionId: data.sessionId,
                playerId: data.playerId,
                questionText: data.questionId,
                selectedAnswer: data.answer,
                correctAnswer: data.isCorrect ? data.answer : null
            });
            // Check completion
            const [session, answers] = yield Promise.all([
                db_1.db.query.gameSessions.findFirst({
                    where: (0, drizzle_orm_1.eq)(schema_1.gameSessions.id, data.sessionId)
                }),
                db_1.db.query.playerAnswers.findMany({
                    where: (0, drizzle_orm_1.eq)(schema_1.playerAnswers.gameSessionId, data.sessionId)
                })
            ]);
            if (typeof session.questions != 'string')
                return;
            const totalQuestions = JSON.parse(session.questions).length;
            const playerAnswersCount = answers.filter(a => a.playerId === data.playerId).length;
            if (playerAnswersCount >= totalQuestions) {
                socket.emit('player_complete');
                // Check if all players finished
                const roomPlayers = yield db_1.db.query.players.findMany({
                    where: (0, drizzle_orm_1.eq)(schema_1.players.roomId, session.roomId)
                });
                const allFinished = roomPlayers.every(player => {
                    const playerAnswers = answers.filter(a => a.playerId === player.id);
                    return playerAnswers.length >= totalQuestions;
                });
                // if (allFinished) {
                //     const scores = await calculateScores(session.id);
                //     io.to(getRoomCode(session.roomId)).emit('game_completed', scores);
                //     await db.update(rooms)
                //         .set({ status: 'completed' })
                //         .where(eq(rooms.id, session.roomId));
                // }
            }
        }));
        // Reconnection Handler
        socket.on('restore_session', (roomCode, userId) => __awaiter(this, void 0, void 0, function* () {
            var _a;
            const room = yield db_1.db.query.rooms.findFirst({
                where: (0, drizzle_orm_1.eq)(schema_1.rooms.roomCode, roomCode),
                with: {
                    players: true,
                    gameSessions: {
                        with: { answers: true }
                    }
                }
            });
            if (!room)
                return socket.emit('restore_error', 'Room not found');
            const player = room.players.find(p => p.userId === userId);
            if (!player)
                return socket.emit('restore_error', 'Player not found');
            // Update socket ID
            yield db_1.db.update(schema_1.players)
                .set({ socketId: socket.id })
                .where((0, drizzle_orm_1.eq)(schema_1.players.id, player.id));
            socket.join(roomCode);
            const response = {
                roomStatus: room.status,
                players: room.players.map(p => ({
                    id: p.id,
                    userId: p.userId,
                    isHost: p.isHost,
                    connected: !!p.socketId
                })),
                currentAnswers: (_a = room.gameSessions) === null || _a === void 0 ? void 0 : _a.flatMap(e => e.answers).filter(a => a.playerId === player.id)
            };
            if (room.status === 'active' && room.gameSessions) {
                Object.assign(response, {
                    // questions: JSON.parse(room.gameSessions[0].questions),
                    sessionId: room.gameSessions[0].id
                });
            }
            socket.emit('session_restored', response);
        }));
        // Disconnect Handler
        socket.on('disconnect', () => __awaiter(this, void 0, void 0, function* () {
            yield db_1.db.update(schema_1.players)
                .set({ socketId: null })
                .where((0, drizzle_orm_1.eq)(schema_1.players.socketId, socket.id));
        }));
    });
}
// Helper Functions
function calculateScores(sessionId) {
    return __awaiter(this, void 0, void 0, function* () {
        const answers = yield db_1.db.query.playerAnswers.findMany({
            where: (0, drizzle_orm_1.eq)(schema_1.playerAnswers.gameSessionId, sessionId),
            with: { player: true }
        });
        const scores = {};
        answers.forEach(answer => {
            if (!scores[answer.player.userId]) {
                scores[answer.player.userId] = { correct: 0, total: 0 };
            }
            scores[answer.player.userId].total++;
            if (answer.correctAnswer === answer.selectedAnswer)
                scores[answer.player.userId].correct++;
        });
        return scores;
    });
}
function generateRoomCode() {
    return Math.random().toString(36).substring(2, 6).toUpperCase();
}
//# sourceMappingURL=socketHandlers.js.map