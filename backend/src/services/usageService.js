


import { NetworkRepo }    from '../models/networksRepo.js';
import { NetworkLogRepo } from '../models/networkLog.js';

export class UsageService {
  /**
   * Persiste un batch de mesures provenant du sniffer
   * @param {Array}   batch     – payload POST /ingest
   * @param {object}  impactSvc – instance d’ImpactService
   */
  async persistBatch(batch, impactSvc) {
    for (const it of batch) {
      const {
        ssid        : networkId,
        service     : serviceName,
        hostId,
        bytes,
        category,
        windowSec   : listenSec
      } = it;

      /* conversion énergie / CO₂ */
      const { kwh, co2 } = impactSvc.bytesToImpact(bytes);

      /* 1. Agrégat réseau (merge + increment) */
      await NetworkRepo.incrementAggregate({
        networkId,
        bytes, kwh, co2,
        listenSec,
        hostId
      });

      /* 2. Journal détaillé (append only) */
      await NetworkLogRepo.insertLot({
        networkId,
        serviceName,
        hostId,
        bytes, kwh, co2,
        listenSec,
        category
      });
    }
  }
}