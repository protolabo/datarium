// src/services/usageService.js
import { ImpactService }   from './impactService.js';
import { NetworkRepo }     from '../models/networksRepo.js';
import { NetworkLogRepo }  from '../models/networkLogRepo.js';

const impactSvc = new ImpactService();

/**
 * Persiste un batch complet envoyé par le sniffer.
 * 1 lot = 1 fenêtre de trafic pour (networkId, service, hostId)
 */
export class UsageService {
  /**
   * @param {Array<Object>} batch  tableau d’items { ssid, hostId, service, bytes, windowSec, category }
   */
  static async persistBatch(batch) {
    for (const lot of batch) {
      const {
        ssid      : networkId,
        hostId,
        service   : serviceName,
        bytes,
        windowSec : listenSec,
        category
      } = lot;

      /* 1. Conversion d’impact */
      const { kwh,  co2 } = impactSvc.bytesToImpact(bytes);

      /* 2. Agrégat réseau (collection networks/) */
      await NetworkRepo.incrementAggregate({
        networkId, bytes, kwh, co2, listenSec, hostId
      });

      /* 3. Journal plat (collection networkLogs/) */
      await NetworkLogRepo.insertLot({
        networkId, serviceName, hostId,
        bytes, kwh, co2, listenSec, category
      });
    }
  }
}
