import 'dotenv/config';
import fs from 'fs';
import express from 'express';
import cors from 'cors';
import admin from 'firebase-admin';

import ingestRoute  from './routes/ingest.js';
import metricsRoute from './routes/metrics.js';
import alertsRoute  from './routes/alerts.js';
import { initSocket } from './services/socket.js';

/*  Firebase Admin  */
const keyPath = process.env.FIREBASE_KEY_PATH;
if (!fs.existsSync(keyPath)) throw new Error('Clé Firebase manquante');
admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(fs.readFileSync(keyPath)))
});
const db = admin.firestore();

/*  Express */
const app = express();
app.use(cors());
app.use(express.json());

app.use('/ingest',  ingestRoute(db));
app.use('/metrics', metricsRoute(db));
app.use('/alerts',  alertsRoute(db));

/*Lancement  */
const server = app.listen(process.env.PORT, () =>
  console.log(`API sur http://localhost:${process.env.PORT}`)
);

/*  WebSocket temps réel */
initSocket(server, db);
