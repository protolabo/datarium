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

## 1. `config/` – variables & bootstrap

| Fichier | Rôle | Extrait clé |
|---------|------|-------------|
| **`env.js`** | Charge `.env` via **dotenv** et expose toutes les constantes (PORT, API_KEY_SNIFFER, KWH_FACTOR…). | ```js\nexport const { PORT, API_KEY_SNIFFER, KWH_FACTOR, CO2_FACTOR, THERMO_UNIT, THRESHOLDS_KWH, THRESHOLDS_CO2 } = process.env;\n``` |
| **`firebase.js`** | Initialise **Firebase‑Admin** (singleton)<br>et exporte **`db`**. | ```js\nimport admin from 'firebase-admin';\nadmin.initializeApp({ credential: admin.credential.cert(serviceAccount) });\nexport const db = admin.firestore();\n``` |

---

## 2. `controllers/` – logique métier “fine”

| Fichier | End‑point(s) | Responsabilités majeures |
|---------|--------------|--------------------------|
| **`usageController.js`** | `POST /ingest` | 1. validation (`ingestValidator`) ; 2. calcul impact (`impactService`) ; 3. persistance (`usageService`) ; 4. push temps‑réel (`notificationService`) ; 5. réponse **204 No Content** |
| **`networkController.js`** | `GET /networks` ; `GET /networks/:id` | Lit les agrégats via **`networksRepo`** |
| **`networkLogController.js`** | `GET /networkLogs` | Gère filtrage + pagination → **`networkLogRepo.search()`** |
| **`serviceController.js`** | `GET /services` | Sert la liste descriptive des services (YouTube, Spotify…) via **`servicesRepo`** |

---

## 3. `models/` – entités & accès Firestore

| Fichier | Objet représenté | Méthodes / remarques |
|---------|------------------|----------------------|
| **`serviceUsage.js`** | Classe d’entité pour le couple **(networkId, serviceName)** en RAM | `addWindow()`, `toDoc()` |
| **`networksRepo.js`** | Repository **`networks/`** (agrégat par SSID) | `incrementAggregate()`, `listAll()`, `getById()` |
| **`networkLogRepo.js`** | Repository **`networkLogs/`** (journal plat) | `insertLot()`, `search()` |
| **`servicesRepo.js`** | Repository **`services/`** (métadonnées) | `listAll()`, `getByName()` |

---

## 4. `routes/` – transport HTTP

| Routeur | Chemins exposés |
|---------|-----------------|
| **`indexRoute.js`** | Monte tous les sous‑routeurs |
| **`usageRoute.js`** | `POST /ingest` |
| **`networkRoute.js`** | `GET /networks`, `GET /networks/:id` |
| **`networkLogRoute.js`** | `GET /networkLogs` (query : `networkId`, `serviceName`, `from`, `to`, `limit`) |
| **`serviceRoute.js`** | `GET /services`, `GET /services/:name` |

---

## 5. `services/` – briques indépendantes d’Express

| Fichier | Rôle |
|---------|------|
| **`impactService.js`** | Conversion octets → kWh → gCO₂ + calcul du niveau couleur (`levelFor`) |
| **`usageService.js`** | Orchestre un batch : calcule l’impact puis appelle `networksRepo.incrementAggregate()` **+** `networkLogRepo.insertLot()` |
| **`notificationService.js`** | `pushThermo()` : simple wrapper autour de Socket.io (via `utils/socket.js`) |

---

## 6. `utils/` – helpers techniques

| Fichier | Utilité |
|---------|---------|
| **`threshold.js`** | Transforme les seuils définis dans `.env` en palette couleur (0 = vert 👉 3 = rouge) |
| **`impact.js`** | Fonctions utilitaires pures (utilisées dans les tests) |
| **`socket.js`** | `initSocket(httpServer)` + `pushThermo(payload)` – isole entièrement Socket.io |

---

## 7. `validators/`

| Fichier | But |
|---------|-----|
| **`recordsValidator.js`** | Vérifie la structure d’un lot `/ingest` (ssid, service, bytes :number, etc.) → retourne `{ valid, errors[] }` |

---

## 8. `app.js` – point d’entrée

1. Crée l’instance **Express**  
2. `app.use(cors())`, `app.use(express.json())`  
3. Monte le routeur principal : `app.use(indexRoute)`  
4. Ajoute le **handler 500** centralisé  
5. Lance le serveur HTTP → `app.listen(PORT)`  
6. Initialise WebSocket : `initSocket(httpServer)`  



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
    POST	/records	Envoie un ou plusieurs lots de trafic	Header X-API-Key
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
Invoke-RestMethod -Method Post -Uri "http://localhost:8000/records" `
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