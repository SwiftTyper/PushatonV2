import { type ClientSchema, a, defineData } from '@aws-amplify/backend';
/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any unauthenticated user can "create", "read", "update", 
and "delete" any "Todo" records.
=========================================================================*/

// Define the schema for your backend
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

  Game: a.model({
      player1Id: a.string().required(),
      player2Id: a.string(),
      player1Score: a.integer().required().default(0),
      player2Score: a.integer().required().default(0),
      status: a.ref('GameStatus'),
      lastUpdateTime: a.datetime(),
  })
  .authorization((allow) => [allow.owner()]),

  Player: a.model({
    username: a.string().required(),
    position: a.ref('Position'),
    currentGameId: a.string(),
    highScore: a.integer().default(0),
    isOnline: a.boolean().required().default(false),
    lastActiveAt: a.datetime(),
  })
  .authorization((allow) => [allow.owner()]),
  // .authorization((allow) => [allow.owner(), allow.publicApiKey().to(['read'])])
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool'
  }
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server 
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>
