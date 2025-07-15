
// 1 fichier unique : crée l’appli Express, monte les routes,
// démarre le serveur HTTP et initialise Socket.io.


import express   from 'express';
import cors      from 'cors';

import usageRoutes from './routes/usageRoute.js';
import ssidRoutes  from './routes/ssidRoute.js';         

import { initSocket }   from './utils/socket.js';
import { PORT }         from './config/env.js';

// ---------- Création de l'app + middlewares ----------
const app = express();
app.use(cors());
app.use(express.json());

// ---------- Routes ----------
app.use(usageRoutes);
app.use(ssidRoutes);     // retirer si inutile

// ---------- Handler 500 ----------
app.use((err, req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Server error' });
});

// ---------- Lancement du HTTP + WebSocket ----------
const httpServer = app.listen(PORT, () =>
  console.log(`API http://localhost:${PORT}`)
);
initSocket(httpServer);
