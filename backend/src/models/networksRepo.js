/* import { db } from '../config/firebase.js';
import admin from 'firebase-admin'; */
import { supabase } from '../config/supabase.js';

export class NetworkRepo {
    /**
        * Incrémente les compteurs du réseau + met à jour les dates. 
        * il est écrit la fonction(rpc) dans supabase car les transactions sont mieux gérées en SQL
        * @param {Object} p
        * @param {string} p.networkId  – SSID (ex : "Home_Wifi")
        * @param {number} p.bytes
        * @param {number} p.kwh
        * @param {number} p.co2
        * @param {number} p.listenSec  – durée de la fenêtre
        * @param {string} p.hostId     – appareil qui a généré le trafic
     */
    static async incrementAggregate({ networkId, bytes, kwh, co2, listenSec, hostId }) {
        const { error } = await supabase.rpc('increment_network_aggregates', {
            p_network_id: networkId,
            p_bytes: bytes,
            p_kwh: kwh,
            p_co2: co2,
            p_listen_sec: listenSec,
            p_host_id: hostId
        });

        if (error) {
            console.error('Error in incrementAggregate RPC:', error);
            throw error;
        }
    }

    /*Liste des réseaux (GET /networks) */
    static async listAll() {
        const { data, error } = await supabase
            .from('network')
            .select('*')
            .order('last_batch_received', { ascending: false }); 
            // ascendint: false = du + récent au + ancien

        if (error) {
            console.error('Error in listAll networks:', error);
            throw error;
        }
        // console.log('NETWORK DOCS', data.map(d => d.id)); //Debug
        return data || [];
    }

    /*  Détails d’un réseau (GET /networks/:id) */
    static async getById(networkId) {
        const { data, error } = await supabase
            .from('network')
            .select('*')
            .eq('id', networkId)
            .single(); // c'est juste un rangée unique mais pas un tableau

        // erreur PGRST116 = "No rows found" – on la gère en renvoyant null
        if (error && error.code !== 'PGRST116') { 
            console.error('Error in getById network:', error);
            throw error;
        }
        
        return data;
    }
}




/* export class NetworkRepo {
    static async incrementAggregate({ networkId, bytes, kwh, co2, listenSec, hostId }) {
        const ref = db.doc(`networks/${networkId}`);

        await db.runTransaction(async (t) => {
            const snap = await t.get(ref);

            if (snap.exists) {
                t.update(ref, {
                    lastBatchReceived: admin.firestore.FieldValue.serverTimestamp(),
                    bytes: admin.firestore.FieldValue.increment(bytes),
                    kwh: admin.firestore.FieldValue.increment(kwh),
                    co2: admin.firestore.FieldValue.increment(co2),
                    listenSec: admin.firestore.FieldValue.increment(listenSec),
                    [`listenedBy.${hostId}`]: true
                });
            }
            // Si le document n'existe pas, on le crée
            else {
                t.set(ref, {
                    createdOn: admin.firestore.FieldValue.serverTimestamp(),
                    lastBatchReceived: admin.firestore.FieldValue.serverTimestamp(),
                    bytes, kwh, co2, listenSec,
                    listenedBy: { [hostId]: true }
                });
            }
        });
    }
    
    async listAll() {
        const col = await db.collection('networks')
            .orderBy('lastBatchReceived', 'desc')
            .get();

        console.log('NETWORK DOCS', col.docs.map(d => d.id)); //Debug
        return col.docs.map(d => ({ id: d.id, ...d.data() }));
    }

    
    async getById(networkId) {
        const snap = await db.doc(`networks/${networkId}`).get();
        return snap.exists ? { id: snap.id, ...snap.data() } : null;
    }

} */