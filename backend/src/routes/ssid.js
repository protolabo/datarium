import { Router } from 'express';
import { list, listServices } from '../controllers/ssid.js';

export default Router()
  .get('/ssids', list)
  .get('/ssids/:ssid/services', listServices);
