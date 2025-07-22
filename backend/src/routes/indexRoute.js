// src/routes/indexRoute.js
import { Router }         from 'express';
import networkRouter      from './networkRouter.js';
import serviceRouter      from './serviceRouter.js';

export default Router()
  .use(networkRouter)
  .use(serviceRouter);
