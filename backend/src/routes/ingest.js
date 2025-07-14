import { Router } from 'express';

import { ingest } from '../controllers/ingest.js';

export default Router().post('/ingest', ingest);
