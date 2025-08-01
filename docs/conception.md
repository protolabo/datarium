# Conception

## Architecture
### Modele C4
![Modele C4](images/ModeleC4.svg)

- Décrire l'architecture du système proposé.

## Choix technologiques

Pour ce projet nous devions :

 - Collecter le trafic réseau en provenance de sniffeurs.

 - Calculer son impact énergétique (kWh / g CO₂).

 - Stocker et agréger ces données de façon fiable.

 - Diffuser en temps réel un « thermomètre » couleur vers une application mobile ou sur la composante (ESP32).

Les technologies ci-dessous ont été choisies car elles répondent à ces contraintes tout en restant simples à mettre en œuvre et à maintenir.

#### Backend : Node 18 + Express
Nous avons retenu Node JS car JavaScript est déjà connu de l’équipe et possède un écosystème immense.
Express offre un routeur HTTP très léger ; on ajoute seulement les middlewares dont on a besoin (CORS, JSON, API-Key).


Avantage principal : cycle de développement rapide – un nodemon relance le serveur dès qu’on modifie un fichier.

#### Temps réel : Socket.io
Le « thermomètre » doit changer de couleur instantanément.
Socket.io masque la complexité du WebSocket : une simple ligne io.emit('thermo', payload) côté serveur et socket.on('thermo', …) côté mobile.


#### Base de données : Firebase / Cloud Firestore
Nous voulions :

 - un schéma flexible (les logs bruts et les agrégats n’ont pas le même format) ;

 - des transactions atomiques sans config complexe ;

 - zéro serveur à maintenir.

Firestore y répond parfaitement : c’est du NoSQL managé par Google, il s’adapte automatiquement à la charge et propose un kit Node.js prêt à l’emploi.

#### Authentification minimale : en-tête X-API-Key
Le sniffeur n’a pas d’interface utilisateur ; un simple secret partagé dans l’en-tête suffit pour l’instant.
Si, dans le futur, nous voulons un contrôle d’accès plus fin, nous pourrions migrer vers Firebase Auth ou JWT sans toucher au reste du code.

#### Organisation interne (Services / Repositories)
Le code du backend est découpé ainsi :

 - Services (ImpactService, NotificationService…) : règles métier pures, faciles à tester.

 - Repositories (networksRepo, networkLogRepo) : accès Firestore uniquement.

 - Controllers : point de contact HTTP qui oriente la requête, appelle les services puis répond.

Cette séparation assure que l’on peut changer Firestore pour une autre base dans le futur sans réécrire la logique de calcul.

#### Application mobile : Flutter 3
Flutter compile en natif pour iOS et Android à partir d’un seul code Dart.
Le hot-reload visuel est précieux : on voit immédiatement le rendu des jauges.
Le package socket_io_client se connecte en une ligne au backend.

#### Sniffer PC : Python 3 + Scapy
Scapy est la référence open-source pour capturer et analyser les paquets réseau.
En quelques dizaines de lignes on filtre, on catégorise (YouTube, Spotify…), puis on envoie un JSON au backend via la librairie requests.

#### Composante ESP32
L’ESP32 n'est pas couteux et possède Wi-Fi + Bluetooth sur la même puce contrairement a la Arduino uno .
3

## Modèles et diagrammes
### Diagramme de la base de donnée
![Diagramme FireStore](images/firestore.svg)

### Diagramme de l'API
![Diagramme API](images/API.svg)


## Prototype

- Inclure des diagrammes UML, maquettes, etc.
