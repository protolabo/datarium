import { db } from '../config/firebase.js';

export class ServiceUsageLogRepository {
  /**
   * Ajoute une fenêtre et lui assigne un ID séquentiel access_1, access_2, …
   * Séquence stockée dans ssids/{ssid}/services/{service}.windowSeq
   */
  async addWindow({ ssid, service, hostId,
                    bytes, kwh, co2,
                    windowSec, category }) {

    const svcRef = db.doc(`ssids/${ssid}/services/${service}`);

    await db.runTransaction(async (t) => {
      // Lire le doc service pour récupérer (ou créer) le compteur
      const snap = await t.get(svcRef);
      const cur  = snap.exists && typeof snap.data().windowSeq === 'number'
        ? snap.data().windowSeq
        : 0;
      const next = cur + 1;

      // ID lisible
      const id = `access_${next}`;

      // Sous-collection correcte
      const winRef = svcRef.collection('accesService').doc(id);

      // Écrire la fenêtre
      t.set(winRef, {
        ts: Date.now(),
        hostId,
        bytes,
        kwh,
        co2,
        windowSec,
        category
      });

      // Mettre à jour le compteur dans le doc service
      t.set(svcRef, { windowSeq: next }, { merge: true });
    });
  }
}