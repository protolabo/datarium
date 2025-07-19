import { db } from '../config/firebase.js';

export class NetworkLogRepo {
  /**
   * Insère un lot détaillé dans la collection networkLogs
   */
  static async insertLot({ networkId, serviceName, hostId,
                           bytes, kwh, co2, listenSec, category }) {
    /* ID lisible : <timestamp>_<hostId>  */
    const id = `${Date.now()}_${hostId}`;

    await db.doc(`networkLogs/${id}`).set({
      networkId,          // "Home_Wifi"
      timestamp : Date.now(),
      serviceName,        // "YouTube"
      hostId,
      bytes, kwh, co2,
      listenSec,          // Durée d'écoute en secondes
      category            // "video", "music"…
    });
  }
}