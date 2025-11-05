import { Router } from 'express';
import networkRouter from './networkRouter.js';
import serviceRouter from './serviceRouter.js';
import recommendationRouter from './recommendationRouter.js';

const router = Router();
router.use(networkRouter)
router.use(serviceRouter);
router.use('/recommendations', recommendationRouter);

export default router;