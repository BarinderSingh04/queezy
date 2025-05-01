import { Request, Response } from "express";
import { CreateGameType, GetScoresType } from "../types/game.types";
import { db } from "../db";
import { and, desc, eq, sql } from "drizzle-orm";
import { gameSessions, playerAnswers, players, rooms, users } from "../db/schema";
import triviaService from "../services/trivia.service";
import { UserRequestInterface } from "../types/user.types";

class GameController {
    async createGame(req: Request<{}, {}, CreateGameType>, res: Response) {
        try {
            const data = req.body;
            const room = await db.query.rooms.findFirst({
                where: eq(rooms.roomCode, data.roomCode),
                with: { players: true }
            });

            if (!room) {
                res.status(404).json({
                    success: 0,
                    message: 'Room not found'
                });
                return;
            }

            if (!room.players.some(p => p.isHost)) {
                res.status(401).json({
                    success: 0,
                    message: 'Only host can start the game'
                });
                return;
            }

            const questions = await triviaService.getQuestions(data);

            const gameData = {
                roomId: room.id,
                questions: JSON.stringify(questions),
                difficulty: data.difficulty,
                type: data.type,
                categoryId: data.categoryId
            }
            const [session] = await db.insert(gameSessions).values(gameData).$returningId();

            const playerList = await db.select(
                {
                    id: users.id,
                    name: users.name,
                    avatar: users.avatar,
                    isHost: players.isHost
                }
            ).from(players).
                innerJoin(users, eq(users.id, players.userId)).
                where(eq(players.roomId, room.id));

            await db.update(rooms)
                .set({ status: 'active' })
                .where(eq(rooms.id, room.id));

            res.json({
                success: 1,
                sessionId: session.id,
                questions,
                players: playerList
            });
        } catch (error) {
            res.status(500).json({
                "success": 0,
                "message": `Error creating game: ${error}`
            });
        }
    }

    async gameScores(req: Request<GetScoresType>, res: Response) {
        const { sessionId } = req.params;
        try {
            const session = await db.query.gameSessions.findFirst({
                where: eq(gameSessions.id, Number(sessionId)),
            });

            if (!session) {
                res.json({
                    success: 0,
                    message: 'Session not found'
                });
                return;
            }

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

            res.json({
                success: 1,
                message: 'Scores fetched successfully',
                data: scores
            });
        } catch (error) {
            res.status(500).json({
                "success": 0,
                "message": `Error creating game: ${error}`
            });
        }
    }

    async leaderboard(req: Request, res: Response) {
        try {
            const result = await db.select({
                playerId: playerAnswers.playerId,
                avatar: users.avatar,
                userName: users.name,
                correctAnswers: sql<number>`COUNT(*)`.as('correct_answers'),
            })
                .from(playerAnswers)
                .innerJoin(players, eq(playerAnswers.id, players.id))
                .innerJoin(users, eq(users.id, players.userId))
                .where(eq(playerAnswers.selectedAnswer, playerAnswers.correctAnswer))
                .groupBy(users.id)
                .orderBy(desc(sql`correct_answers`));

            res.json({
                success: 1,
                message: 'Leaderboard fetched successfully',
                data: result
            });

        } catch (error) {
            res.status(500).json({
                "success": 0,
                "message": `Error getting leaderboard: ${error}`
            });
        }
    }

    async playedGames(req: UserRequestInterface, res: Response) {
        const { id } = req.user;
        try {
            const results = await db
                .select({
                    userId: users.id,
                    name: users.name,
                    avatar: users.avatar,
                    totalQuizzes: sql<number>`COUNT(DISTINCT ${playerAnswers.gameSessionId})`,
                    totalWins: sql<number>`SUM(
                CASE
                  WHEN (
                    SELECT COUNT(*) 
                    FROM ${playerAnswers} AS pa2
                    WHERE pa2.game_session_id = ${playerAnswers.gameSessionId}
                      AND pa2.player_id = ${playerAnswers.playerId}
                      AND pa2.selected_answer = pa2.correct_answer
                  ) * 1.0 / 
                  (
                    SELECT COUNT(*) 
                    FROM ${playerAnswers} AS pa3
                    WHERE pa3.game_session_id = ${playerAnswers.gameSessionId}
                      AND pa3.player_id = ${playerAnswers.playerId}
                  ) >= 0.7
                THEN 1 ELSE 0 END
              )`,
                })
                .from(playerAnswers)
                .innerJoin(players, eq(playerAnswers.playerId, players.id))
                .innerJoin(users, eq(players.userId, users.id))
                .groupBy(users.id);


            res.json({
                success: 1,
                message: 'Leaderboard fetched successfully',
                data: results
            });

        } catch (error) {
            res.status(500).json({
                "success": 0,
                "message": `Error getting played games: ${error}`
            });
        }
    }
}

export default new GameController();