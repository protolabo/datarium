// src/routes/serviceRouter.js
import { Router }         from 'express';
import * as svcCtrl       from '../controllers/serviceController.js';

const router= Router();
  router.get  ('/services',        svcCtrl.list)
  router.post ('/services',        svcCtrl.create)
  router.get  ('/services/:id',    svcCtrl.get)
  router.delete('/services/:id',   svcCtrl.remove);
export default router;
