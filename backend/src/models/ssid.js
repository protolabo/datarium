import { db } from '../config/firebase.js';

/* Renvoie la liste de TOUS les SSID connus, du plus récent au plus ancien */
export async function listAll() {
  const col = await db
    .collection('ssids')
    .orderBy('lastSeen', 'desc')   // tri par dernière activité
    .get();

  // On ne retourne que l’id du doc (= le nom du réseau)
  return col.docs.map(d => d.id);  // ["Home_Wifi", …]
}

/* Renvoie la consommation de CHAQUE service pour un SSID donné
        - ssid  : "Home_Wifi"
        - field : "kwh"  ou  "co2"  (choisi par le contrôleur en fonction du ?unit=)
*/
export async function listServices(ssid, field) {
  const col = await db
    .collection(`ssids/${ssid}/services`)
    .orderBy(field, 'desc')        // on classe du plus gros consommateur au plus petit
    .get();

  // [{ service:"YouTube", value:1.8 }, { service:"Spotify", value:0.3 }, …]
  return col.docs.map(d => ({ service: d.id, value: d.data()[field] }));
}
