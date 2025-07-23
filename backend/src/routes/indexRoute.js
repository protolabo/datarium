// src/routes/indexRoute.js
import { Router }         from 'express';
import networkRouter      from './networkRouter.js';
import serviceRouter      from './serviceRouter.js';

const router = Router();
 router .use(networkRouter)
 router.use(serviceRouter);
export default router;
