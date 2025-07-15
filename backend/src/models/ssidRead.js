import { db } from '../config/firebase.js';

export class SSIDReadRepository {
  async listAll() {
    const snap = await db.collection('ssids').orderBy('lastSeen', 'desc').get();
    return snap.docs.map(d => d.id);               // ["Home_Wifi", ...]
  }

  /**
   * Retourne tous les services d’un ssid ordonnés par field (kwh ou co2)
   * @param {string} ssid
   * @param {'kwh'|'co2'} field
   */
  async listServices(ssid, field) {
    const snap = await db
      .collection(`ssids/${ssid}/services`)
      .orderBy(field, 'desc')
      .get();
    return snap.docs.map(d => ({ service: d.id, value: d.data()[field] }));
  }
}
