import { Router } from 'express';
import { recordUsageBatch } from '../controllers/usageController.js';

export default Router().post('/ingest', recordUsageBatch);
