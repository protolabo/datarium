# datarium
# Back‑end Node / Express + Firebase

Ce dépôt contient l’API **Datarium** qui :

* reçoit des lots de trafic réseau envoyés par les sniffeurs ESP32 ou PC ;
* calcule l’impact énergétique (kWh / g CO₂) ;
* agrège les compteurs par réseau Wi‑Fi (*networks/*) ;
* enregistre chaque lot brut dans le journal (*networkLogs*) ;
* diffuse en temps réel (Socket.io) le niveau du “thermomètre CO₂ / kWh”.

 **Stack** : Node 18, Express, Firebase‑Admin (Cloud Firestore), Socket.io.  


---

## Arborescence

src/
├─ config/ #  clés & constantes
├─ controllers/ # logique métier (fine)
├─ models/ # entités + accès Firestore
├─ routes/ # couche transport HTTP
├─ services/ # briques réutilisables (no Express)
├─ utils/ # helpers techniques
├─ validators/ # validation de payload
└─ app.js # point d’entrée (HTTP + WebSocket)

## 1 . `config/` – variables globales

| Fichier        | Rôle | Extrait |
|---------       |------|---------|
| **`env.js`**   | Charge le `.env` via `dotenv` et expose toutes les constantes du projet. | ```js export const { PORT, API_KEY_SNIFFER, KWH_FACTOR, … } = process.env;``` |
| **`firebase.js`** | Initialise **Firebase‑Admin** (singleton) et exporte `db`. | ```js admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });``` |

---

## 2 . `controllers/` – logique métier “fine”

| Fichier | End‑point | Responsabilité détaillée |
|---------|-----------|--------------------------|
| **`usageController.js`** | `POST /ingest` | 1- validation ; 2- calcul impact ; 3- persistance (`usageService`); 4- push temps‑réel; 5- `204 No Content`. |
| **`networkController.js`** | `GET /networks` & `GET /networks/:id` | Interroge `networksRepo` et renvoie du JSON prêt pour le front. |
| **`networkLogController.js`** | `GET /networkLogs` | Gère filtrage/pagination puis → `networkLogRepo.search()`. |

---

## 3 . `models/` – entités + accès Firestore

| Fichier | Qu’est‑ce que c’est ? | Méthodes clés |
|---------|-----------------------|---------------|
| **`serviceUsage.js`** | Classe d’entité : compteurs d’un couple **(network, service)**. | `addWindow()`, `toDoc()`. |
| **`networksRepo.js`** | Repository  collection **`networks/`** (agrégat par SSID). | `incrementAggregate()`, `listAll()`, `getById()`. |
| **`networkLog.js`**   | Repository   collection **`networkLogs/`** . | `insertLot()`, `search()`. |

---

## 4 . `routes/` – transport HTTP

| Fichier             | Contenu essentiel                                                 |
|---------            |------------------                                                 |
| **`indexRoute.js`** | Monte les sous‑routeurs (`usageRoute`, …).           |
| **`usageRoute.js`** | `Router().post('/ingest', recordUsageBatch)`                      |

---

## 5 . `services/` – briques indépendantes d’Express

| Fichier | Rôle | Particularité |
|---------|------|--------------|
| **`impactService.js`** | bytes → kWh → g CO₂ & `levelFor()` |  facile à tester. |
| **`usageService.js`** | Orchestration d’un batch : appelle à la suite `networksRepo` & `networkLogRepo`. |
| **`notificationService.js`** | `pushThermo()` :  délègue à `utils/socket.js`. | Permet de découpler Socket.io du reste. |

---

## 6 . `utils/` – helpers

| Fichier              | À quoi ça sert ?                                          |
|---------             |------------------                                         |
| **`threshold.js`**   | Calcul du niveau couleur (vert / jaune / orange / rouge). |
| **`impact.js`**      | Fonctions utilitaires utilisées par les tests unitaires.  |
| **`socket.js`**      | `initSocket(httpServer)` + `pushThermo(payload)`.         |

---

## 7 . `validators/`

| Fichier                  | Rôle                                                                        |
|---------                 |------                                                                       |
| **`ingestValidator.js`** | Vérifie la **forme** du payload `/ingest` et renvoie `{ valid, errors[] }`. |

---

## 8 . `app.js` – point d’entrée

```js
// 1. création Express 
const app = express();
app.use(cors());
app.use(express.json());

// 2. routes
app.use(indexRoute);

// 3. handler 500
app.use((err, req, res, _) => {
  console.error(err);
  res.status(500).json({ error: 'Server error' });
});

// 4. HTTP + WebSocket
const httpServer = app.listen(PORT, () => console.log(`API http://localhost:${PORT}`));
initSocket(httpServer);



### Schéma Firestore

networks (collection)
└─ {networkId} (doc) ex: "Home_Wifi"
• bytes (number)
• kwh (number)
• co2 (number)
• listenSec (number)
• createdOn (timestamp)
• lastBatchReceived(timestamp)
• listenedBy (map<string,bool>)
• … futurs champs

networkLogs (collection groupe)
└─ {timestamp_hostId} (doc) ex: "1721105400000_DESKTOP‑A"
• networkId (string)
• timestamp (number ms)
• serviceName (string) ex : "YouTube"
• hostId (string)
• bytes (number)
• kwh, co2 (number)
• listenSec (number)
• category (string)


## Installation

```bash
git clone https://github.com/your‑org/datarium‑backend.git
cd datarium‑backend

cp .env.example .env           # renseigner les variables ci‑dessous
npm install
npm run dev                    # nodemon + hot reload
Fichier .env
Clé	Exemple / Description
PORT	8000
API_KEY_SNIFFER	ChangeMe – clé partagée avec les sniffeurs
FIREBASE_PROJECT_ID	datarium-xxxx
KWH_FACTOR	5.5e-8 – kWh par octet
CO2_FACTOR	0.41 – g CO₂ par kWh (moyenne FR)
THERMO_UNIT	kwh | gco2 – unité du thermomètre
THRESHOLDS_KWH	0.01,0.05,0.1 – seuils vert/jaune/orange
THRESHOLDS_CO2	4,20,40 – mêmes seuils en g CO₂

Place aussi serviceAccount.json (clé privée Firebase‑Admin) dans le dossier services
et ajoute‑le au .gitignore.

Endpoints
    Méthode	URL	Description	Auth
    POST	/ingest	Envoie un ou plusieurs lots de trafic	Header X-API-Key
    GET	/networks	Liste tous les réseaux (tri DESC par lastBatchReceived)	—
    GET	/networks/:id	Détails d’un réseau	—
    GET	/networkLogs?networkId=&limit=&from=&to=&serviceName=	Recherche dans le journal plat	—

Exemples curl / PowerShell

# Envoi d’un batch (2 fenêtres)
$headers = @{ 'X-API-Key' = 'ChangeMe'; 'Content-Type' = 'application/json' }
$body = @'
[
  { "ssid":"Home_Wifi","hostId":"DESKTOP-A","service":"YouTube",
    "category":"video","bytes":1048576,"windowSec":10 },
  { "ssid":"Home_Wifi","hostId":"DESKTOP-A","service":"YouTube",
    "category":"video","bytes":524288,"windowSec":5  }
]
'@
Invoke-RestMethod -Method Post -Uri "http://localhost:8000/ingest" `
                  -Headers $headers -Body $body


# Liste des réseaux
curl http://localhost:8000/networks | jq

# Journal des 50 dernières fenêtres pour Home_Wifi
curl "http://localhost:8000/networkLogs?networkId=Home_Wifi&limit=50" | jq
Socket.io
Le backend ouvre ws://localhost:8000

Canal : thermo

Payload :
    { "ts": 1721105400000,
    "unit": "kwh",
    "value": 0.0034,
    "level": 1 }     // 0=vert,1=jaune,2=orange,3=rouge


Tests rapides: 
    npm test                
    node src/testFirestore.js   # script utilitaire de purge ou d’index