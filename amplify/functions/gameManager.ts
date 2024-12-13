// import { type Schema } from '../data/resource';
// import { Context } from '@aws-amplify/backend';

// interface StartGameInput {
//   userId: string;
// }

// export const startGameSession = async (ctx: Context, input: StartGameInput) => {
//   try {
//     const { userId } = input;
    
//     // Verify player exists
//     const player = await ctx.data.PlayerProfile.get({ id: userId });
//     if (!player) {
//       throw new Error('Player not found');
//     }

//     // Create new game session
//     const session = await ctx.data.GameSession.create({
//       playerId: userId,
//       score: 0,
//       timestamp: new Date(),
//       completed: false
//     });

//     return {
//       success: true,
//       session
//     };
//   } catch (error) {
//     console.error('Error starting game session:', error);
//     throw new Error('Failed to start game session');
//   }
// };

// interface UpdateScoreInput {
//   sessionId: string;
//   score: number;
// }

// export const updateGameScore = async (ctx: Context, input: UpdateScoreInput) => {
//   try {
//     const { sessionId, score } = input;
    
//     // Get current session
//     const session = await ctx.data.GameSession.get({ id: sessionId });
//     if (!session) {
//       throw new Error('Game session not found');
//     }
//     if (session.completed) {
//       throw new Error('Cannot update completed game session');
//     }

//     // Update session score
//     const updatedSession = await ctx.data.GameSession.update({
//       id: sessionId,
//       score: score,
//       timestamp: new Date()
//     });

//     return {
//       success: true,
//       session: updatedSession
//     };
//   } catch (error) {
//     console.error('Error updating game score:', error);
//     throw new Error('Failed to update game score');
//   }
// };

// interface EndGameInput {
//   sessionId: string;
//   finalScore: number;
// }

// export const endGameSession = async (ctx: Context, input: EndGameInput) => {
//   try {
//     const { sessionId, finalScore } = input;
    
//     // Get current session
//     const session = await ctx.data.GameSession.get({ id: sessionId });
//     if (!session) {
//       throw new Error('Game session not found');
//     }
//     if (session.completed) {
//       throw new Error('Game session already completed');
//     }

//     // Update session as completed
//     const updatedSession = await ctx.data.GameSession.update({
//       id: sessionId,
//       score: finalScore,
//       completed: true,
//       timestamp: new Date()
//     });

//     // Update player stats
//     await ctx.data.PlayerProfile.update({
//       id: session.playerId,
//       highScore: Math.max((await ctx.data.PlayerProfile.get({ id: session.playerId }))?.highScore || 0, finalScore),
//       totalGames: (await ctx.data.PlayerProfile.get({ id: session.playerId }))?.totalGames + 1 || 1,
//       lastPlayed: new Date()
//     });

//     return {
//       success: true,
//       session: updatedSession
//     };
//   } catch (error) {
//     console.error('Error ending game session:', error);
//     throw new Error('Failed to end game session');
//   }
// };