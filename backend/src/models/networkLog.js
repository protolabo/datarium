import { db } from '../config/firebase.js';

export class NetworkLogRepo {
    /** Insère un lot détaillé dans la collection networkLogs*/
    static async insertLot({ networkId, serviceName, hostId,
        bytes, kwh, co2, listenSec, category }) {
        /* ID lisible : <timestamp>_<hostId>  */
        const id = `${Date.now()}_${hostId}`;

        await db.doc(`networkLogs/${id}`).set({
            networkId,          // "Home_Wifi"
            timestamp: Date.now(),
            serviceName,        // "YouTube"
            hostId,
            bytes, kwh, co2,
            listenSec,          // Durée d'écoute en secondes
            category            // "video", "music"…
        });
    }
    /** Cherche des lots, filtrables par SSID, service, période */
    static async search({ networkId, serviceName, fromTs, toTs, limit = 100 }) {
        let q = db.collection('networkLogs').orderBy('timestamp', 'desc');

        if (networkId) q = q.where('networkId', '==', networkId);
        if (serviceName) q = q.where('serviceName', '==', serviceName);
        if (fromTs) q = q.where('timestamp', '>=', fromTs);
        if (toTs) q = q.where('timestamp', '<=', toTs);

        const snap = await q.limit(limit).get();
        return snap.docs.map(d => ({ id: d.id, ...d.data() }));
    }

    /**
     * Retourne les N derniers lots toutes catégories / réseaux confondus.
     * @param {number} limit  nombre de documents (défaut : 1)
     * @returns {Array<Object>} tableau de logs triés du + récent au + ancien
     */
    static async fetchLatest(limit = 1) {
        const snap = await db.collection('networkLogs')
            .orderBy('timestamp', 'desc')
            .limit(limit)
            .get();
        return snap.docs.map(d => ({ id: d.id, ...d.data() }));
    }
}