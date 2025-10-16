import express from 'express';
import cors from 'cors';
import routes from './routes/indexRoute.js';
import auth from 'basic-auth';
import { initSocket } from './utils/socket.js';
import { PORT } from './config/env.js';

const app = express();
app.use(cors());
app.use(express.json());

const USER = 'admin';
const PASSWORD = '1234';

app.use((req, res, next) => {
    const credentials = auth(req);
    if (!credentials || credentials.name !== USER || credentials.pass !== PASSWORD) {
        res.setHeader('WWW-Authenticate', 'Basic realm="Datarium secure area"');
        return res.status(401).json({ error: 'Access denied' });
    }
    next();
});

app.use(routes);



app.use((err, req, res, _) => { console.error(err); res.status(500).json({ error: 'Server error' }); });

//const httpServer = app.listen(PORT, () => console.log(`API http://localhost:${PORT}`));
//initSocket(httpServer);

export default app;


