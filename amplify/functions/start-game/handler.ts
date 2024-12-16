// import type { Handler } from 'aws-lambda';
// import { generateClient } from '@aws-amplify/api';
// import { Amplify } from '@aws-amplify/core';
// import { type Schema } from '../../data/resource';

// Amplify.configure({
//   API: {
//     GraphQL: {
//       endpoint: process.env.API_ENDPOINT!,
//       region: process.env.REGION!,
//       defaultAuthMode: 'apiKey',
//       apiKey: process.env.API_KEY
//     }
//   }
// });

// // Generate the client after configuration
// export const client = generateClient<Schema>();

// export const handler: Handler = async (event) => {
//   const { playerId } = event.arguments;
  
//   // Add logging to debug the client
//   console.log('Client:', JSON.stringify(client));
//   console.log('Models:', JSON.stringify(client.models));
  
//   return await handleStartGame(playerId);
// }

// async function handleStartGame(playerId: string) {
//   try {
//       // Add more detailed error handling
//       if (!client?.models?.Game) {
//           console.error('Game model is not defined:', client);
//           throw new Error('Game model not initialized properly');
//       }
      
//       // First check if there are any waiting games
//       const { data: games } = await client.models.Game.list({
//           filter: {
//               status: { eq: 'WAITING' },
//               player1Id: { ne: playerId }
//           }
//       });

//       if (games && games.length > 0) {
//           const gameToJoin = games[0];
//           await client.models.Game.update({
//               id: gameToJoin.id,
//               player2Id: playerId,
//               status: 'PLAYING'
//           });
//           return 'JOINED';
//       }

//       // If no waiting games, create a new one
//       const { data: newGame } = await client.models.Game.create({
//           player1Id: playerId,
//           status: 'WAITING',
//           player1Score: 0,
//           player2Score: 0
//       });

//       if (!newGame?.id) {
//           throw new Error('Failed to create game');
//       }

//       return 'CREATED';
//   } catch (error) {
//       console.error('Error in handleStartGame:', error);
//       throw error;
//   }
// }
