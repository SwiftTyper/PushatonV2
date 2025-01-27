import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  Position: a.customType({
    y: a.float().required(),
    z: a.float().required()
  }),

  GameStatus: a.enum([
    'WAITING',
    'PLAYING',
    'FINISHED'
  ]),

  CoinArrangement: a.enum([
    'STRAIGHT',
    'DOUBLE_STRAIGHT',
    'ARC'
  ]),

  ObstacleData: a.customType({
    isLow: a.boolean().required(),
    coinArrangement: a.ref('CoinArrangement'),
    coinValue: a.integer()
  }),

  Game: a.model({
    id: a.id().required(),
    player1Id: a.string().required(),
    player2Id: a.string(),
    status: a.ref('GameStatus').required(),
    winner: a.string(),
    obstacles: a.ref('ObstacleData').required().array().required(),
    createdAt: a.datetime(), 
  })
  .identifier(['id'])
  .authorization((allow) => [
    allow.authenticated(),
  ]),

  Player: a.model({
    username: a.id().required(),
    currentGameId: a.string(),
    position: a.ref('Position'),
    score: a.integer(),
    highScore: a.integer().required().default(0),
    isOnline: a.boolean().required().default(false),
    isPlayerAlive: a.boolean(),
  })
  .identifier(['username'])
  .authorization((allow) => [
    allow.guest().to(['read']),
    allow.authenticated().to(['create', 'read']),
    allow.owner().to(['update', 'delete', 'create', 'read'])
  ]),

})

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool",
  },
});
