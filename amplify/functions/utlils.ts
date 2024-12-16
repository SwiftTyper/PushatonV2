// Make sure Amplify is configured before generating the client
import { Amplify } from 'aws-amplify';
import { generateClient } from 'aws-amplify/api';
import { type Schema } from '../data/resource';

Amplify.configure({
  API: {
    GraphQL: {
      endpoint: process.env.API_ENDPOINT!,
      region: process.env.REGION!,
      defaultAuthMode: 'apiKey',
      apiKey: process.env.API_KEY
    }
  }
});

// Generate the client after configuration
export const client = generateClient<Schema>();