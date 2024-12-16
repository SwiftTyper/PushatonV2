import { defineFunction } from '@aws-amplify/backend';

export const startGame = defineFunction({
    name: 'start-game',
    entry: './handler.ts'
});
