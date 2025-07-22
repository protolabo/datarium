// src/app.js
import express     from 'express';
import cors        from 'cors';
import routes      from './routes/indexRoute.js';
import { initSocket } from './utils/socket.js';
import { PORT }       from './config/env.js';

const app = express();
app.use(cors());
app.use(express.json());
app.use(routes);

app.use((err,req,res,_)=>{ console.error(err); res.status(500).json({error:'Server error'}); });

const httpServer = app.listen(PORT, () => console.log(`API http://localhost:${PORT}`));
initSocket(httpServer);
