// import { z } from 'zod';

// // Player Profile Schemas
// export const createProfileSchema = z.object({
//   username: z.string().min(3).max(50),
// });

// export const updateStatsSchema = z.object({
//   userId: z.string().uuid(),
//   score: z.number().int().min(0),
// });

// export const getPlayerSchema = z.object({
//   userId: z.string().uuid(),
// });

// // Game Session Schemas
// export const startGameSchema = z.object({
//   userId: z.string().uuid(),
// });

// export const updateScoreSchema = z.object({
//   sessionId: z.string().uuid(),
//   score: z.number().int().min(0),
// });

// export const endGameSchema = z.object({
//   sessionId: z.string().uuid(),
//   finalScore: z.number().int().min(0),
// });

// // Leaderboard Schemas
// export const leaderboardSchema = z.object({
//   limit: z.number().int().min(1).max(100).optional(),
// });

// export const playerRankingSchema = z.object({
//   userId: z.string().uuid(),
//   nearby: z.number().int().min(1).max(20).optional(),
// });

// export const timeBasedSchema = z.object({
//   timeRange: z.enum(['day', 'week', 'month']),
//   limit: z.number().int().min(1).max(100).optional(),
// });