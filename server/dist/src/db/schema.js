"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.playerAnswerRelations = exports.gameSessionRelations = exports.playerRelations = exports.roomRelations = exports.playerAnswers = exports.gameSessions = exports.rooms = exports.players = exports.users = void 0;
const mysql_core_1 = require("drizzle-orm/mysql-core");
const relations_1 = require("drizzle-orm/relations");
exports.users = (0, mysql_core_1.mysqlTable)('users', {
    id: (0, mysql_core_1.serial)('id').primaryKey(),
    username: (0, mysql_core_1.text)('username').notNull(),
    createdAt: (0, mysql_core_1.timestamp)('created_at').defaultNow(),
});
exports.players = (0, mysql_core_1.mysqlTable)('players', {
    id: (0, mysql_core_1.serial)('id').primaryKey(),
    socketId: (0, mysql_core_1.varchar)('socket_id', { length: 20 }),
    userId: (0, mysql_core_1.varchar)('user_id', { length: 36 }).notNull(),
    roomId: (0, mysql_core_1.int)('room_id').references(() => exports.rooms.id),
    isHost: (0, mysql_core_1.boolean)('is_host').default(false),
    lastActive: (0, mysql_core_1.timestamp)('last_active').defaultNow(),
});
exports.rooms = (0, mysql_core_1.mysqlTable)('rooms', {
    id: (0, mysql_core_1.serial)('id').primaryKey(),
    roomCode: (0, mysql_core_1.varchar)('room_code', { length: 6 }).notNull().unique(),
    status: (0, mysql_core_1.mysqlEnum)('status', ['waiting', 'active', 'completed']).default('waiting'),
    createdAt: (0, mysql_core_1.timestamp)('created_at').defaultNow(),
});
exports.gameSessions = (0, mysql_core_1.mysqlTable)('game_sessions', {
    id: (0, mysql_core_1.serial)('id').primaryKey(),
    roomId: (0, mysql_core_1.int)('room_id').references(() => exports.rooms.id),
    startedAt: (0, mysql_core_1.timestamp)('started_at').defaultNow(),
    questions: (0, mysql_core_1.json)('questions').notNull(),
    endedAt: (0, mysql_core_1.timestamp)('ended_at'),
});
exports.playerAnswers = (0, mysql_core_1.mysqlTable)('player_answers', {
    id: (0, mysql_core_1.serial)('id').primaryKey(),
    gameSessionId: (0, mysql_core_1.int)('game_session_id').notNull().references(() => exports.gameSessions.id),
    playerId: (0, mysql_core_1.int)('user_id').notNull().references(() => exports.players.id),
    questionText: (0, mysql_core_1.text)('question_text').notNull(),
    selectedAnswer: (0, mysql_core_1.text)('selected_answer'),
    correctAnswer: (0, mysql_core_1.text)('correct_answer').notNull(),
});
exports.roomRelations = (0, relations_1.relations)(exports.rooms, ({ many }) => ({
    players: many(exports.players),
    gameSessions: many(exports.gameSessions),
}));
exports.playerRelations = (0, relations_1.relations)(exports.players, ({ one }) => ({
    room: one(exports.rooms, {
        fields: [exports.players.roomId],
        references: [exports.rooms.id],
    }),
}));
exports.gameSessionRelations = (0, relations_1.relations)(exports.gameSessions, ({ one, many }) => ({
    room: one(exports.rooms, {
        fields: [exports.gameSessions.roomId],
        references: [exports.rooms.id],
    }),
    answers: many(exports.playerAnswers),
}));
exports.playerAnswerRelations = (0, relations_1.relations)(exports.playerAnswers, ({ one }) => ({
    gameSession: one(exports.gameSessions, {
        fields: [exports.playerAnswers.gameSessionId],
        references: [exports.gameSessions.id],
    }),
    player: one(exports.players, {
        fields: [exports.playerAnswers.playerId],
        references: [exports.players.id],
    }),
}));
//# sourceMappingURL=schema.js.map