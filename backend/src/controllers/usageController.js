import { validateBatch }          from '../validators/recordsValidator.js';
import { ImpactService }          from '../services/impactService.js';
import { UsageService }           from '../services/usageService.js';
import { NotificationService }    from '../services/notificationService.js';
import { API_KEY_SNIFFER, THERMO_UNIT } from '../config/env.js';

const impactSvc   = new ImpactService();
const usageSvc    = new UsageService();
const notifySvc   = new NotificationService();

/** POST /ingest */
export async function recordUsageBatch(req, res, next) {
  try {
    // Clé API
    if (req.headers['x-api-key'] !== API_KEY_SNIFFER)
      return res.status(401).json({ error: 'Bad API key' });

    const batch = Array.isArray(req.body) ? req.body : [req.body];

    // Validation
    const { valid, errors } = validateBatch(batch);
    if (!valid) return res.status(400).json({ errors });

    // Impact global (= thermo live)
    const totalBytes = batch.reduce((s, { bytes }) => s + bytes, 0);
    const impact     = impactSvc.bytesToImpact(totalBytes);
    const value      = THERMO_UNIT === 'kwh' ? impact.kwh : impact.co2;
    const level      = impactSvc.levelFor(value);

    // Notification live
    notifySvc.pushThermo({ ts: Date.now(), unit: THERMO_UNIT, value, level });

    // Persistance
    await usageSvc.persistBatch(batch, impactSvc);

    res.sendStatus(204);
  } catch (e) { next(e); }
}
