import { Router } from 'express';
import { listSsids, listServices } from '../controllers/ssidController.js';

export default Router()
  .get('/ssids', listSsids)
  .get('/ssids/:ssid/services', listServices);
