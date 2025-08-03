<<<<<<< HEAD
// src/controllers/networkLogController.js
import { validateBatch }      from '../validators/ingestValidator.js';
import { ImpactService }      from '../services/impactService.js';
import { NetworkRepo }        from '../models/networksRepo.js';
import { NetworkLogRepo }     from '../models/networkLog.js';
import { API_KEY_SNIFFER }    from '../config/env.js';

const impactSvc = new ImpactService();

/* ---------- POST /ingest --------------- */
export async function recordUsageBatch(req, res, next) {
  try {
    if (req.headers['x-api-key'] !== API_KEY_SNIFFER)
      return res.status(401).json({ error: 'Bad API key' });

    const batch   = Array.isArray(req.body) ? req.body : [req.body];
    const { valid, errors } = validateBatch(batch);
    if (!valid) return res.status(400).json({ errors });

    for (const lot of batch) {
      const { ssid:networkId, service, hostId, bytes, windowSec, category } = lot;
      const { kwh, co2 } = impactSvc.bytesToImpact(bytes);

      /* 1️⃣  agrégat réseau */
      await NetworkRepo.incrementAggregate({
        networkId, bytes, kwh, co2, listenSec: windowSec, hostId
      });

      /* 2️⃣  journal détaillé */
      await NetworkLogRepo.insertLot({
        networkId, serviceName:service, hostId,
        bytes, kwh, co2, listenSec: windowSec, category
      });
    }
    res.sendStatus(204);
  } catch(e){ next(e); }
}

/* ---------- GET /networkLogs ----------- */
export async function searchLogs(req,res,next){
  try{
=======

import { validateBatch }   from '../validators/recordsValidator.js';
import { ImpactService }   from '../services/impactService.js';
import { NetworkRepo }     from '../models/networksRepo.js';
import { NetworkLogRepo }  from '../models/networkLog.js';   // <-- nom corrigé
import { API_KEY_SNIFFER } from '../config/env.js';
import { ServiceRepo } from '../models/serviceRepo.js'; 

const impactSvc = new ImpactService();

/*  POST /records  (ex‑/ingest)*/
export async function recordUsageBatch (req, res, next) {
  try {
    /* sécurité */
    if (req.headers['x-api-key'] !== API_KEY_SNIFFER)
      return res.status(401).json({ error: 'Bad API key' });

    /* validation */
    const batch = Array.isArray(req.body) ? req.body : [req.body];
    const { valid, errors } = validateBatch(batch);
    if (!valid) return res.status(400).json({ errors });

    /* boucle sur chaque lot */
    for (const lot of batch) {
      const { ssid:networkId, service, hostId,
              bytes, windowSec, category } = lot;

        await ServiceRepo.ajoutService({
            id        : service,           // id = “YouTube”, “ChatGPT”… 
            name      : service,           // tu peux mettre un vrai libellé si différent
            category  : category || null   // “video”, “ai”… (optionnel)
        });      
      const { kwh, co2 } = impactSvc.bytesToImpact(bytes);

      /* agrégat réseau */
      await NetworkRepo.incrementAggregate({
        networkId, bytes, kwh, co2,
        listenSec: windowSec,
        hostId
      });

      /* journal détaillé */
      await NetworkLogRepo.insertLot({
        networkId,
        serviceName : service,
        hostId,
        bytes, kwh, co2,
        listenSec   : windowSec,
        category
      });
    }
    res.sendStatus(204);                 // ✅ Terminé
  } catch (e) { next(e); }
}

/*2.  GET /networkLogs  */
export async function searchLogs (req, res, next) {
  try {
>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0
    const { networkId, serviceName, from, to, limit } = req.query;

    const logs = await NetworkLogRepo.search({
      networkId,
      serviceName,
      fromTs : from ? +from : undefined,
      toTs   : to   ? +to   : undefined,
<<<<<<< HEAD
      limit  : +limit || 100
    });
    res.json(logs);
  }catch(e){ next(e); }
}
=======
      limit  : +limit || 100         // défaut 100
    });
    res.json(logs);
  } catch (e) { next(e); }
}

/* GET /networkLogs/latest  (1 seul)  */
export async function getLastLog(req, res, next) {
  try {
    const [log] = await NetworkLogRepo.fetchLatest(1);
    log ? res.json(log) : res.sendStatus(204);
  } catch (e) { next(e); }
}

/*  GET /networkLogs/recent?limit=10   */
export async function getRecentLogs(req, res, next) {
  try {
    const limit = +req.query.limit || 10;          // défaut : 10
    const logs  = await NetworkLogRepo.fetchLatest(limit);
    res.json(logs);                                // tableau JSON
  } catch (e) { next(e); }
}

>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0
