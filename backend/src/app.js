import express from 'express';
import cors from 'cors';
import ingestRoutes from './routes/ingest.js';
import ssidRoutes   from './routes/ssid.js';

export function createApp(){
  const app = express();
  app.use(cors());
  app.use(express.json());
  app.use(ingestRoutes);
  app.use(ssidRoutes);

  return app;
}
