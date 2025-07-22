// src/routes/serviceRouter.js
import { Router }         from 'express';
import * as svcCtrl       from '../controllers/serviceController.js';

export default Router()
  .get  ('/services',        svcCtrl.list)
  .post ('/services',        svcCtrl.create)
  .get  ('/services/:id',    svcCtrl.get)
  .patch('/services/:id',    svcCtrl.update)
  .delete('/services/:id',   svcCtrl.remove);
