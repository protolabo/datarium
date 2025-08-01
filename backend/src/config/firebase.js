import admin from 'firebase-admin';
import fs from 'fs';
import { FIREBASE_KEY_PATH } from './env.js';

const creds = JSON.parse(fs.readFileSync(FIREBASE_KEY_PATH));
admin.initializeApp({ credential: admin.credential.cert(creds) });

export const db = admin.firestore();
