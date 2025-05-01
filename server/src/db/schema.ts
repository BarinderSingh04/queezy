import { mysqlTable, serial, text, int, timestamp, varchar, boolean, json, mysqlEnum } from 'drizzle-orm/mysql-core';
import { relations } from 'drizzle-orm/relations';

export const rooms = mysqlTable('rooms', {
  id: int('id').primaryKey().autoincrement(),
  roomCode: varchar('room_code', { length: 6 }).notNull().unique(),
  status: mysqlEnum('status', ['waiting', 'active', 'completed']).default('waiting'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const users = mysqlTable('users', {
  id: int('id').primaryKey().autoincrement(),
  name: text('name').notNull(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  avatar: varchar("avatar", { length: 255 }),
  createdAt: timestamp('created_at').defaultNow(),
  password: varchar("password", { length: 256 }).notNull(),
});

export const players = mysqlTable('players', {
  id: int('id').primaryKey().autoincrement(),
  socketId: varchar('socket_id', { length: 20 }),
  userId: int('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  roomId: int('room_id').notNull().references(() => rooms.id, { onDelete: 'cascade' }),
  isHost: boolean('is_host').default(false),
  lastActive: timestamp('last_active').defaultNow(),
});

export const gameSessions = mysqlTable('game_sessions', {
  id: int('id').primaryKey().autoincrement(),
  roomId: int('room_id').notNull().references(() => rooms.id, { onDelete: 'cascade' }),
  startedAt: timestamp('started_at').defaultNow(),
  questions: json('questions').notNull(),
  difficulty: mysqlEnum('difficulty', ['easy', 'medium', 'hard']).default("easy"),
  type: mysqlEnum('type', ['boolean', 'multiple']).default("multiple"),
  categoryId: int('category_id').notNull(),
  endedAt: timestamp('ended_at'),
});

export const playerAnswers = mysqlTable('player_answers', {
  id: int('id').primaryKey().autoincrement(),
  gameSessionId: int('game_session_id').notNull().references(() => gameSessions.id, { onDelete: 'cascade' }),
  playerId: int('player_id').notNull().references(() => players.id, { onDelete: 'cascade' }),
  questionText: text('question_text').notNull(),
  selectedAnswer: text('selected_answer'),
  correctAnswer: text('correct_answer').notNull(),
});

export const roomRelations = relations(rooms, ({ many }) => ({
  players: many(players),
  gameSessions: many(gameSessions),
}));

export const playerRelations = relations(players, ({ one }) => ({
  room: one(rooms, {
    fields: [players.roomId],
    references: [rooms.id],
  }),
  user: one(users, {
    fields: [players.userId],
    references: [users.id],
  }),
}));

export const gameSessionRelations = relations(gameSessions, ({ one, many }) => ({
  room: one(rooms, {
    fields: [gameSessions.roomId],
    references: [rooms.id],
  }),
  answers: many(playerAnswers),
}));

export const playerAnswerRelations = relations(playerAnswers, ({ one }) => ({
  gameSession: one(gameSessions, {
    fields: [playerAnswers.gameSessionId],
    references: [gameSessions.id],
  }),
  player: one(players, {
    fields: [playerAnswers.playerId],
    references: [players.id],
  }),
}));



