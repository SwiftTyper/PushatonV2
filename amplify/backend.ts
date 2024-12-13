import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';

// Configure backend
defineBackend({
  auth,
  data,
});