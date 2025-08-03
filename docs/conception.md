# Conception

## Architecture
### Modele C4
<<<<<<< HEAD
![Modele C4](images/ModeleC4.svg)
=======
![Modele C4](images/datarium.svg)
>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0

- Décrire l'architecture du système proposé.

## Choix technologiques

<<<<<<< HEAD
- Justifier les technologies et outils choisis.

## Modèles et diagrammes

- Inclure des diagrammes UML, maquettes, etc.
=======
Pour ce projet nous devions :

 - Collecte du trafic réseau: Mettre en place une solution capable de capturer et d’analyser le trafic réseau sur un segment donné (via   un sniffer réseau), en respectant les contraintes de confidentialité.

 -  Identification des services Internet sollicités: Analyser les requêtes réseau pour identifier les services ou applications en ligne utilisées (ex. : YouTube, Google Maps, Facebook, ChatPGT).

 - Évaluation de l’impact énergétique par requête: Estimer la consommation énergétique et les émissions de CO₂ associées à chaque          requête.  Les unités de mesure seront standardisées en kWh et grammes de CO₂.

 - Stockage et agrégation des données: Implémenter une architecture de stockage fiable et scalable pour enregistrer les données de trafic analysé et les mesures d’impact énergétique.

 - Diffusion en temps réel vers des clients externes Mettre en œuvre un mécanisme de diffusion des données agrégées en quasi temps réel vers des applications mobiles et/ou des dispositifs embarqués (ESP32).

 Les technologies ci-dessous ont été choisies car elles répondent à ces contraintes tout en restant simples à mettre en œuvre et à maintenir.

#### Backend : Node 18 + Express
Plutôt que d’opter pour des environnements plus lourds (Spring Boot en Java, Django en Python), nous avons privilégié Node JS : le langage JavaScript est déjà familier et l’écosystème NPM regorge de bibliothèques prêtes à l’emploi.
Express ajoute à Node les éléments qui manquent pour définir des routes HTTP et traiter les requêtes ; il transforme ainsi le moteur brut de Node en un serveur web léger et directement exploitable. Cette légèreté permet de comprendre la mécanique interne en quelques heures et de modifier un endpoint sans délai : un simple nodemon redémarre le serveur dès qu’un fichier change et l’API répond à nouveau en moins d’une seconde.

En pratique, Node 18 + Express sert de point central et satisfait deux des exigences majeures du projet :

Stockage et agrégation fiables – le moteur événementiel non bloquant de Node ingère chaque lot JSON posté par le sniffeur dès son arrivée ; les middlewares Express (body-parser, validation, API-Key) le font passer dans un contrôleur qui calcule l’impact énergétique, puis déclenchent des appels atomiques vers Cloud Firestore. Les transactions Firestore, pilotées depuis le code Node, garantissent que l’agrégat (collection networks) et le journal brut (collection networkLogs) sont tenus à jour dans la même milliseconde, sans risque d’incohérence même lorsque plusieurs sniffeurs publient en parallèle.

Diffusion quasi temps réel – Express reste assez léger pour laisser Socket.io s’installer dans le même processus : aussitôt qu’un lot est persisté, on émet un io.emit('thermo', payload) ; la boucle d’événements de Node, optimisée pour l’I/O, relaye l’information aux applis Flutter et à l’ESP32 sans thread bloquant ni polling. Résultat : le thermomètre change de couleur sous 100 ms sur Wi-Fi local, répondant pleinement à l’exigence de diffusion instantanée.

#### Temps réel : Socket.io
L’affichage du thermomètre doit se mettre à jour immédiatement lorsqu’un nouveau lot de trafic est reçu. Plutôt que de forcer l’application mobile à interroger l’API toutes les deux secondes (technique dite de polling, énergivore et coûteuse), nous utilisons Socket.io. Cette librairie encapsule la technologie WebSocket : côté serveur on diffuse en une ligne io.emit('thermo', payload), côté client on écoute socket.on('thermo', …). L’abstraction gère d’elle-même les déconnexions, les tentatives de reconnexion et même un repli sur HTTP longue-polling si le pare-feu bloque les WebSocket, sans que nous ayons à coder ces cas particuliers.

#### Base de données : Firebase / Cloud Firestore
Nos données se répartissent en deux familles très différentes :

 - des documents « bruts » – chaque fenêtre de 4 secondes provenant d’un sniffer ;

 - des agrégats – un compteur global par réseau Wi-Fi.

Un schéma relationnel rigide  tel que SQL aurait imposé des jointures complexes ou des migrations fréquentes. Firestore, base NoSQL entièrement gérée par Google, accepte au contraire des documents de formes variées dans une même collection et applique des transactions ACID (Atomicite Coherence Isolation et Durabilite) en une seule instruction. De plus, aucun serveur n’est à installer : la base se dimensionne toute seule selon le volume de requêtes. 

Cette solution de stockage répond directement à l’exigence « Stockage et agrégation des données » : Firestore enregistre chaque lot brut sans schéma fixe et, dans le même temps, met à jour les compteurs agrégés d’un seul appel transactionnel, garantissant à la fois cohérence ACID et montée en charge automatique lorsque le nombre de réseaux ou de sniffeurs augmente.

#### Authentification minimale : en-tête X-API-Key
Le sniffer n’a ni clavier ni interface graphique pour saisir un mot de passe. Nous avons donc placé un secret partagé dans le fichier de configuration ; chacune des requêtes vers /records porte ce secret dans l’en-tête X-API-Key. Le middleware Express se contente de comparer la valeur reçue à celle stockée dans les variables d’environnement. Dans le futur afin de passer à Firebase Auth ou à des jetons JWT : il suffira de remplacer ce middleware sans toucher au reste du code.

#### Organisation interne (Services / Repositories)
Le projet sépare strictement les responsabilités :

Controllers : points de contact HTTP. Ils valident les paramètres, appellent les services et renvoient la réponse.
Services : règles métier purs (conversion octets→kWh, diffusion Socket.io…). 
Repositories/models : code d’accès à Firestore. 

Cette stratification rend le dépôt compréhensible pour un nouveau développeur : un bug d’API se cherchera côté controller, un ajustement d’algorithme côté service, un problème de base côté repository/model.

#### Application mobile : Flutter 3

Plutôt que de maintenir deux projets natifs (Kotlin pour Android, Swift pour iOS) – solution exigeante en temps et en expertise – nous avons choisi Flutter. Le framework compile en code natif pour les deux plates-formes à partir d’un unique projet Dart, et son hot reload permet de visualiser instantanément la moindre modification de l’interface. Le package socket_io_client se connecte naturellement au backend, ce qui simplifie la réception des mises à jour du thermomètre.

#### Sniffer PC : Python 3 + Scapy
Nous faisons une capture du traffic grace a un framework python nommé Scapy. Cet outil permet d'intercepter le traffic sur un segment réseau et d'analyser les divers paquets recus et envoyés. Nous avons privilégié Scapy à d'autres outils comme PyShark pour plusieurs raisons :
- Le nombre de paquets intercepté était beaucoup plus important avec scapy.
- Scapy permet de faire une capture en asynchrone qui fournit des fonctions comme star et stop. Ceci permet de faire une capture tout en permettant de faire d'autres traitements dans le programme.
Scapy est la référence open-source pour capturer et analyser les paquets réseau. 
En quelques dizaines de lignes on filtre, on catégorise les paquets en fonction de leur provenance (YouTube, Spotify…), puis on envoie un JSON au backend via la librairie requests.
Avec pyshark ca aurait été moins efficient a cause des traitements et communications avec le backend.

#### Composante ESP32
Pour matérialiser visuellement l’impact énergétique, nous avons retenu un ESP32 équipé de LED : il communique avec l'API du backend et le microcontrôleur change instantanément la couleur de la LED (vert → jaune → orange → rouge) d’après le niveau reçu. Ce choix s’est imposé face à l’Arduino Uno envisagé au départ : contrairement à l’Uno, l’ESP32 embarque nativement le Wi-Fi et le Bluetooth LE, ce qui évite l’ajout d’un shield réseau coûteux et encombrant. Avec l'ESP32 nous obtenons un module compact, autonome et programmable depuis l’IDE Arduino, capable de se connecter directement à l’API et d’afficher en temps réel l’état “carbone” du réseau sans qu’aucune configuration supplémentaire ne soit nécessaire.

## Modèles et diagrammes
### Diagramme de la base de donnée
![Diagramme FireStore](images/firestore.svg)

### Diagramme de l'API
![Diagramme API](images/API.svg)

>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0

## Prototype

- Inclure des diagrammes UML, maquettes, etc.
