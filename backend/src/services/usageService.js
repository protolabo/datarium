
// Ce service reçoit un lot de mesures provenant du contrôleur,
// convertit les octets en kWh / CO₂ via ImpactService, puis délègue au
// repository pour mettre à jour Firestore.


import { ServiceUsageRepository } from '../models/serviceUsage.repo.js';

export class UsageService {
  // Repository instancié une seule fois (champ privé ES2022)
  #repo = new ServiceUsageRepository();

  /**
   * Persiste un lot de mesures.
   * @param {Array<Object>} batch     - Tableau d'items { ssid, hostId, service, bytes }
   * @param {ImpactService} impactSvc - Service capable de convertir octets → impact
   */
  async persistBatch(batch, impactSvc) {
    // Parcourt chaque ligne du lot
    for (const it of batch) {
      const { ssid, service, hostId, bytes } = it;

      // Conversion octets → kWh / CO₂ via ImpactService
      const { kwh, co2 } = impactSvc.bytesToImpact(bytes);

      // Incrément des compteurs dans Firestore (transaction)
      await this.#repo.increment({ ssid, service, hostId, bytes, kwh, co2 });
    }
  }
}
