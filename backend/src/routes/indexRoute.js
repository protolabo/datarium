// Routeur principal : mappe chaque URL vers son contrôleur dédié

import { Router } from 'express';

/* contrôleurs */
import * as usageCtrl    from '../controllers/usageController.js';
import * as networkCtrl  from '../controllers/networkController.js';
import * as logCtrl      from '../controllers/networkLogController.js';

const router = Router();

/* Ingestion de trafic (POST) */
router.post('/ingest', usageCtrl.recordUsageBatch);



/*  Lecture des agrégats réseau (GET) */
/**
 * GET /networks
 * liste des SSID, triés par lastBatchReceived desc.
 */
router.get('/networks', networkCtrl.list);

/**
 * GET /networks/:id
 *  agrégat complet pour un réseau donné (bytes, kwh, co2, listenSec…)
 */
router.get('/networks/:id', networkCtrl.get);



/*Lecture du journal détaillé (GET) */
router.get('/networkLogs', logCtrl.search);

export default router;   