import { db }   from '../config/firebase.js';
import admin    from 'firebase-admin';

export class NetworkRepo {
  /**
   * Incrémente les compteurs du réseau + met à jour les dates.
   * @param {Object} p
   * @param {string} p.networkId  – SSID (ex : "Home_Wifi")
   * @param {number} p.bytes
   * @param {number} p.kwh
   * @param {number} p.co2
   * @param {number} p.listenSec  – durée de la fenêtre
   * @param {string} p.hostId     – appareil qui a généré le trafic
   */
  static async incrementAggregate({ networkId, bytes, kwh, co2, listenSec, hostId }) {
    const ref = db.doc(`networks/${networkId}`);

    await db.runTransaction(async (t) => {
      const snap = await t.get(ref);

      if (snap.exists) {
        t.update(ref, {
          lastBatchReceived : admin.firestore.FieldValue.serverTimestamp(),
          bytes     : admin.firestore.FieldValue.increment(bytes),
          kwh       : admin.firestore.FieldValue.increment(kwh),
          co2       : admin.firestore.FieldValue.increment(co2),
          listenSec : admin.firestore.FieldValue.increment(listenSec),
          [`listenedBy.${hostId}`] : true
        });
      }
        // Si le document n'existe pas, on le crée
      else {
        t.set(ref, {
          createdOn         : admin.firestore.FieldValue.serverTimestamp(),
          lastBatchReceived : admin.firestore.FieldValue.serverTimestamp(),
          bytes, kwh, co2, listenSec,
          listenedBy : { [hostId]: true }
        });
      }
    });
  }
  /*Liste des réseaux (GET /networks) */
  async listAll () {
    const col = await db.collection('networks')
                      .orderBy('lastBatchReceived', 'desc')   
                      .get();

    console.log('NETWORK DOCS', col.docs.map(d => d.id)); //Debug
    return col.docs.map(d => ({ id: d.id, ...d.data() }));   
}

  /*  Détails d’un réseau (GET /networks/:id) */
  async getById (networkId) {
    const snap = await db.doc(`networks/${networkId}`).get();
    return snap.exists ? { id: snap.id, ...snap.data() } : null;
  }

}