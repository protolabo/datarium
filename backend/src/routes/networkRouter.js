// src/routes/networkRouter.js
import { Router }                 from 'express';
import * as netCtrl               from '../controllers/networkController.js';
import * as logCtrl               from '../controllers/networkLogController.js';

export default Router()
  /* lecture */
  .get   ('/networks',      netCtrl.list)
  .get   ('/networks/:id',  netCtrl.get)
  .get   ('/networkLogs',   logCtrl.searchLogs)
  /* ingestion */
  .post  ('/ingest',        logCtrl.recordUsageBatch);
