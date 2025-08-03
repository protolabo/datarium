// src/routes/serviceRouter.js
import { Router }         from 'express';
import * as svcCtrl       from '../controllers/serviceController.js';

<<<<<<< HEAD
export default Router()
  .get  ('/services',        svcCtrl.list)
  .post ('/services',        svcCtrl.create)
  .get  ('/services/:id',    svcCtrl.get)
  .patch('/services/:id',    svcCtrl.update)
  .delete('/services/:id',   svcCtrl.remove);
=======
const router= Router();
  router.get  ('/services',        svcCtrl.list)
  router.post ('/services',        svcCtrl.create)
  router.get  ('/services/:id',    svcCtrl.get)
  router.delete('/services/:id',   svcCtrl.remove);
export default router;
>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0
