import { createClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from './env.js';


export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);


/* import admin from 'firebase-admin';
import fs from 'fs';
import { FIREBASE_KEY_PATH } from './env1.js';

const creds = JSON.parse(fs.readFileSync(FIREBASE_KEY_PATH));
admin.initializeApp({ credential: admin.credential.cert(creds) });

export const db = admin.firestore(); */
