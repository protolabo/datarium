import 'dotenv/config';
import admin from 'firebase-admin';
import fs from 'fs';

const key = JSON.parse(fs.readFileSync(process.env.FIREBASE_KEY_PATH));
admin.initializeApp({ credential: admin.credential.cert(key) });
const db = admin.firestore();

await db.doc('healthcheck/ping').set({ ts: Date.now() });
console.log('Firestore OK');
process.exit();
