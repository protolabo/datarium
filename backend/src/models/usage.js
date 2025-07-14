// Ce module encapsule toutes les écritures dans Firestore quand une
// mesure arrive (via sniffer ou un test cURL).
// La fonction add() est appelée par le contrôleur ingest.

import { db } from '../config/firebase.js';
import admin from 'firebase-admin';

export async function add({ ssid, service, hostId, bytes, kwh, co2 }) {
  const svcRef = db.doc(`ssids/${ssid}/services/${service}`);

  await db.runTransaction(async t => {
    // 1. Lire l’état actuel du service
    const snap = await t.get(svcRef);
    //    S’il n’existe pas encore : valeurs à 0
    const d = snap.exists ? snap.data()
                           : { bytes: 0, kwh: 0, co2: 0, hosts: {} };

    // 2. Écrire la nouvelle somme
    t.set(svcRef, {
      bytes: d.bytes + bytes,
      kwh  : +(d.kwh + kwh).toFixed(6),
      co2  : +(d.co2 + co2).toFixed(2),
      hosts: { ...d.hosts, [hostId]: true }   // ajoute / conserve l’appareil
    });

    // 3. Mettre à jour le « réseau » (doc SSID racine)
    const ssidRef = db.doc(`ssids/${ssid}`);
    t.set(
      ssidRef,
      {
        createdAt: admin.firestore.FieldValue.serverTimestamp(), // si doc neuf
        lastSeen : admin.firestore.FieldValue.serverTimestamp()  // tjs mis à jour
      },
      { merge: true }    // fusionne avec d’éventuels champs existants
    );
  });
}
