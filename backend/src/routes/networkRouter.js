// Regroupe TOUTES les routes HTTP de l’API.
import { Router }         from 'express';

/* contrôleurs */
import * as netCtrl  from '../controllers/networkController.js';
import * as logCtrl  from '../controllers/networkLogController.js';

const router = Router();

/* ---------- lecture réseaux ---------- */
router.get('/networks',          netCtrl.list);        // GET  /networks
router.get('/networks/:id',      netCtrl.get);         // GET  /networks/Home

/* ---------- lecture logs -------------- */
router.get('/networkLogs',                   logCtrl.searchLogs);      // ?networkId=&limit=
router.get('/networkLogs/latest',logCtrl.getLastLog);      // dernier log global
router.get('/networkLogs/recent',logCtrl.getRecentLogs);     // 10 derniers d’un réseau
router.get('/networkStatsEsp32',  netCtrl.getEsp32Stats)     // route pour recuperer les stats pour l'esp32


/* ---------- Records ---- */
router.post('/records',          logCtrl.recordUsageBatch);           // POST /records

export default router;
