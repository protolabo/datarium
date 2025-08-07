
import { validateBatch }   from '../validators/recordsValidator.js';
import { ImpactService }   from '../services/impactService.js';
import { NetworkRepo }     from '../models/networksRepo.js';
import { NetworkLogRepo }  from '../models/networkLog.js';
import { ServiceRepo }     from '../models/serviceRepo.js';
import { API_KEY_SNIFFER } from '../config/env.js';

const impactSvc = new ImpactService();

/* ---------- POST /records  --------------------------- */
export async function recordUsageBatch (req, res, next) {
  try {
    if (req.headers['x-api-key'] !== API_KEY_SNIFFER)
      return res.status(401).json({ error: 'Bad API key' });

    const batch = Array.isArray(req.body) ? req.body : [req.body];
    const { valid, errors } = validateBatch(batch);
    if (!valid) return res.status(400).json({ errors });

    for (const lot of batch) {
      const { ssid: networkId, service, hostId, bytes,
              windowSec, category } = lot;

      /* assure la présence du service */
      await ServiceRepo.ajoutService({
        id: service,
        name: service,
        category: category ?? null
      });

      const { kwh, co2 } = impactSvc.bytesToImpact(bytes);

      await NetworkRepo.incrementAggregate({
        networkId, bytes, kwh, co2,
        listenSec: windowSec, hostId
      });

      await NetworkLogRepo.insertLot({
        networkId,
        serviceName: service,
        hostId,
        bytes, kwh, co2,
        listenSec: windowSec,
        category
      });
    }
    res.sendStatus(204);
  } catch (e) { next(e); }
}

/* ---------- GET /networkLogs  ------------------------ */
export async function searchLogs (req, res, next) {
  try {
    const { networkId, serviceName, from, to, limit } = req.query;
    const logs = await NetworkLogRepo.search({
      networkId,
      serviceName,
      fromTs : from ? +from : undefined,
      toTs   : to   ? +to   : undefined,
      limit  : +limit || 100         // défaut 100
    });
    res.json(logs);
  } catch (e) { next(e); }
}

/* ---------- GET /networkLogs/latest ------------------ */
export async function getLastLog (req, res, next) {
  try {
    const [log] = await NetworkLogRepo.fetchLatest(1);
    log ? res.json(log) : res.sendStatus(204);
  } catch (e) { next(e); }
}

/* ---------- GET /networkLogs/recent ------------------ */
export async function getRecentLogs (req, res, next) {
  try {
    const limit = +req.query.limit || 10;
    const logs  = await NetworkLogRepo.fetchLatest(limit);
    res.json(logs);
  } catch (e) { next(e); }
}
