// src/routes/indexRoute.js
import { Router }         from 'express';
import networkRouter      from './networkRouter.js';
import serviceRouter      from './serviceRouter.js';

<<<<<<< HEAD
export default Router()
  .use(networkRouter)
  .use(serviceRouter);
=======
const router = Router();
 router .use(networkRouter)
 router.use(serviceRouter);
export default router;
>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0
