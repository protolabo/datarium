
// Repository Firestore pour l'entité ServiceUsage.
// Il gère TOUTES les lectures/écritures concernant la consommation
// d'un service (YouTube, Netflix, …) sur un réseau Wi-Fi (SSID qui est le nom).


import admin from 'firebase-admin';
import { db } from '../config/firebase.js';
import { ServiceUsage } from './serviceUsage.js';

/**
 * Repository chargé d'incrémenter les compteurs d'un (ssid, service).
 * On utilise une TRANSACTION pour assurer la cohérence en cas
 * de trafic concurrent (plusieurs sniffeurs ou fenêtres qui se chevauchent).
 */
export class ServiceUsageRepository {
  /**
   * Incrémente les compteurs d'un document service
   * @param {Object} p
   * @param {string} p.ssid      - Nom du réseau Wi-Fi
   * @param {string} p.service   - Nom du service (YouTube, Netflix…)
   * @param {string} p.hostId    - Nom de la machine qui a généré le trafic
   * @param {number} p.bytes     - Octets de la fenêtre
   * @param {number} p.kwh       - kWh de la fenêtre
   * @param {number} p.co2       - g CO₂ de la fenêtre
   */
  // timestamps et le temps d'ecoute de chaque enregistrement de service, les categories de service

  async increment({ ssid, service, hostId, bytes, kwh, co2, category, windowSec }) {
    // 1. Chemin du document Firestore
    const ref = db.doc(`ssids/${ssid}/services/${service}`);

    // 2. Transaction → lecture puis écriture atomiques
    await db.runTransaction(async (t) => {
      // Lecture de l'état courant
      const snap = await t.get(ref);

      // Instancie notre entité métier
      //  - si le doc existe → on part de ses valeurs
      //  - sinon           → nouveaux compteurs à zéro
      const current = snap.exists
        ? new ServiceUsage({ ...snap.data(), ssid, service })
        : new ServiceUsage({ ssid, service, firstSeen: admin.firestore.FieldValue.serverTimestamp() });

      // Enregistre l'appareil dans la map "hosts"
      current.hostId = hostId;

      // Ajoute la fenêtre courante aux compteurs
      current.addWindow({ bytes, kwh, co2, windowSec, category});
      current.lastSeen = admin.firestore.FieldValue.serverTimestamp();
      // 3. Écriture du document mis à jour
      t.set(ref, current.toDoc(), { merge: true }); 

      // 4. Mise à jour du champ "lastSeen" pour le SSID (facilite la purge)
      t.set(
        db.doc(`ssids/${ssid}`),
        { lastSeen: admin.firestore.FieldValue.serverTimestamp() },
        { merge: true } 
      );
    });
  }
}
