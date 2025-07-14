import { createApp } from './app.js';
import { initSocket } from './utils/socket.js';   // chemin conforme
import { PORT } from './config/env.js';

const app = createApp();
const httpServer = app.listen(PORT, () => console.log(`API http://localhost:${PORT}`));
initSocket(httpServer);     