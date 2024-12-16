// import { type Handler } from 'aws-lambda';




// export const handler: Handler = async (event) => {
//   try {
//     // Log the incoming event for debugging
//     console.log('Event received:', JSON.stringify(event, null, 2));

//     // Extract operation and parameters
//     const { operation, playerId, y, z } = event;

//     // Return the response in the format expected by the Swift client
//     switch (operation) {
//       case 'START_GAME':
//         const startGameResult = await handleStartGame(playerId);
//         return startGameResult;
//       case 'UPDATE_POSITION':
//         const updatePositionResult = await handleUpdatePosition(playerId, y, z);
//         return updatePositionResult;
//       case 'GET_POSITION':
//         const getPositionResult = await handleGetPosition(playerId);
//         return getPositionResult;
//       case 'LEAVE_GAME':
//         const leaveGameResult = await handleLeaveGame(playerId);
//         return leaveGameResult;
//       default:
//         throw new Error(`Invalid operation: ${operation}`);
//     }
//   } catch (err: any) {
//     console.error('Error:', err);
//     throw err; // Let API Gateway handle the error response
//   }
// };


// async function handleUpdatePosition(playerId: string, y: number, z: number) {
//   try {
//     await client.models.Player.update({
//       id: playerId,
//       position: { y, z }
//     });

//     return {
//       playerId,
//       position: { y, z }
//     };
//   } catch (error) {
//     console.error('Error in handleUpdatePosition:', error);
//     throw error;
//   }
// }

// async function handleGetPosition(playerId: string) {
//   try {
//     const { data: player } = await client.models.Player.get({ id: playerId });
    
//     if (!player) {
//       throw new Error('Player not found');
//     }

//     return {
//       playerId,
//       position: player.position
//     };
//   } catch (error) {
//     console.error('Error in handleGetPosition:', error);
//     throw error;
//   }
// }
