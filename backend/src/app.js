import express   from 'express';
import cors      from 'cors';

import usageRoutes     from './routes/usageRoute.js';
import networksRoutes  from './routes/indexRoute.js';     

import { initSocket } from './utils/socket.js';
import { PORT }       from './config/env.js';

const app = express();
app.use(cors());
app.use(express.json());

/* Routes REST  */
app.use(usageRoutes);
app.use(networksRoutes);   // ← MONTE les routes /networks

/* Handler 500  */
app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Server error' });
});

/* HTTP + WebSocket  */
const httpServer = app.listen(PORT, () =>
  console.log(`API http://localhost:${PORT}`)
);
initSocket(httpServer);
