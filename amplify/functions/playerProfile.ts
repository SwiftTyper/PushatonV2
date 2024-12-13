// import { type Schema } from '../data/resource';
// import { Context } from '@aws-amplify/backend';

// interface CreateProfileInput {
//   username: string;
// }

// export const createPlayerProfile = async (ctx: Context, input: CreateProfileInput) => {
//   try {
//     const { username } = input;
//     const newProfile = await ctx.data.PlayerProfile.create({
//       username,
//       highScore: 0,
//       totalGames: 0,
//       lastPlayed: new Date(),
//       createdAt: new Date(),
//       updatedAt: new Date()
//     });
//     return {
//       success: true,
//       profile: newProfile
//     };
//   } catch (error) {
//     console.error('Error creating player profile:', error);
//     throw new Error('Failed to create player profile');
//   }
// };

// interface UpdateStatsInput {
//   userId: string;
//   score: number;
// }

// export const updatePlayerStats = async (ctx: Context, input: UpdateStatsInput) => {
//   try {
//     const { userId, score } = input;
    
//     // Get current profile
//     const profile = await ctx.data.PlayerProfile.get({ id: userId });
//     if (!profile) {
//       throw new Error('Player profile not found');
//     }

//     // Update stats
//     const updates = {
//       highScore: Math.max(profile.highScore, score),
//       totalGames: profile.totalGames + 1,
//       lastPlayed: new Date(),
//       updatedAt: new Date()
//     };

//     const updatedProfile = await ctx.data.PlayerProfile.update({
//       id: userId,
//       ...updates
//     });

//     return {
//       success: true,
//       profile: updatedProfile
//     };
//   } catch (error) {
//     console.error('Error updating player stats:', error);
//     throw new Error('Failed to update player statistics');
//   }
// };

// interface GetPlayerInput {
//   userId: string;
// }

// export const getPlayerDetails = async (ctx: Context, input: GetPlayerInput) => {
//   try {
//     const { userId } = input;
//     const profile = await ctx.data.PlayerProfile.get({ id: userId });
    
//     if (!profile) {
//       throw new Error('Player profile not found');
//     }

//     return {
//       success: true,
//       profile
//     };
//   } catch (error) {
//     console.error('Error fetching player details:', error);
//     throw new Error('Failed to fetch player details');
//   }
// };