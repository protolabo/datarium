//ingest.js est le pont entre :les données brutes envoyées par le sniffer,
// la conversion en impact environnemental,l’écriture durable et transactionnelle dans Firestore.

import { bytesToImpact } from '../utils/impact.js'; // octets → kWh / CO₂
import { add } from '../models/usage.js';             // écrit en base
import { API_KEY_SNIFFER } from '../config/env.js';
import { levelFor }      from '../utils/threshold.js';
import { THERMO_UNIT }   from '../config/env.js';
import { pushThermo }    from '../utils/socket.js';

export async function ingest(req, res, next) {
  try {
    if (req.headers['x-api-key'] !== API_KEY_SNIFFER)
      return res.status(401).json({ error: 'Bad API key' });
    // 1. Accepter soit un objet, soit un tableau d’objets
    const batch = Array.isArray(req.body) ? req.body : [req.body];

    /* ---------- 1. calcul sur la fenêtre courante ---------- */
    let totalBytes = 0;
    for(const {bytes} of batch) totalBytes += bytes;
    const impact   = bytesToImpact(totalBytes);          // {kwh, co2}
    const value    = THERMO_UNIT === 'kwh' ? impact.kwh : impact.co2;
    const level    = levelFor(value);

    /* ---------- 2. push live à l’appli ---------- */
    pushThermo({ ts:Date.now(), unit:THERMO_UNIT, value, level });

    // 2. Boucler sur chaque mesure
    for (const it of batch) {
      const { ssid, hostId, service, bytes } = it;

      // 2-a. Validation minimale : on ignore les payloads incomplets
      if (!ssid || !service || typeof bytes !== 'number') continue;

      // 2-b. Conversion octets → impact
      const { kwh, co2 } = bytesToImpact(bytes);

      // 2-c. Persistance : on délègue au modèle Firestore
      await add({ ssid, service, hostId, bytes, kwh, co2 });
    }

    // 3. Tout s’est bien passé → 204 No Content
    res.sendStatus(204);
  } catch (e) {
    // 4. En cas d’erreur, on passe au middleware errorHandler
    next(e);
  }
}
