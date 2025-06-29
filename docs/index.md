# Projet IFT3150: Datarium

> **Thèmes**: Systemes embarqués, Génie logiciel, Application mobile  
> **Superviseur**: Louis-Edouard Lafontant  

<!-- ## Informations importantes -->

<!-- !!! info "Dates importantes"
    - **Description du projet** : 23 mai 2025
    - **Foire 1: Prototypage** : 9-13 juin 2025
    - **Foire 2: Version beta** : 14-18 juillet 2025
    - **Présentation et rapport** : 11-15 août 2025 -->

## Équipe

- Aïssatou Ndiaye: Responsable de...
- Wendkuni Reine Rosine Guinguiere : Responsable de...
- Papa Moussa Diabaté: Responsable de...

## Description du projet

Datarium est un projet visant à concevoir un dispositif interactif de visualisation de l'empreinte numerique appelé thermometre de données. 

Ce dispositif reposera sur une carte Arduino zero , qui sera le coeur du systeme, permettant de collecter , traiter et afiicher les données en temps réel.

Le Thermometre de données offrira une interface visuelle de l'empreinte numérique produite par l'utilisateur ou un système , que ce soit par des indicateurs graphiques (Écran, LED, Jauge) ou par des effets physiques (Mouvement, Lumiere, Son).
Grâce à la polyvaleve de l'Arduino Zero, le dispositif pourr intégrer divers capteurs , modiles de communication et dispositifs de sortie pour fournir une visualisation  intercative.

L'objectif de Datarium est de: 

1. Développer un dispositif interactif permettant la visualisation en temps réel de l’impact environnemental d’actions numériques.
2. Traduire l’impact numérique en signaux visibles et compréhensibles, via un retour physique ou graphique (ex. : lumière, jauge, écran).
3. Connecter ce dispositif à une application mobile, pour enrichir l’expérience utilisateur et le suivi de l’impact.
4. Sensibiliser les utilisateurs à leur empreinte environnementale numérique de manière concrète et intuitive.
5. Encourager des comportements numériques plus responsables, en rendant l’impact visible et immédiat.
   

### Contexte

À l’ère du numérique, nos gestes quotidiens – envoyer un courriel, naviguer sur le web, regarder une vidéo en streaming, utiliser des services cloud ou encore interagir avec des intelligences artificielles – génèrent une empreinte numérique invisible, mais bien réelle. Cette activité numérique repose sur un vaste réseau d’équipements physiques qui consomment de l’énergie à chaque étape. Par exemple, lorsqu’un utilisateur regarde une vidéo sur YouTube ou envoie un message via un chatbot, cela mobilise des serveurs distants pour traiter la demande, des réseaux Wi-Fi ou mobiles pour transmettre les données, et des appareils personnels (téléphones, ordinateurs, routeurs) pour afficher le résultat.
Même une action aussi simple que stocker un fichier dans un service en ligne comme Google Drive entraîne une série d’échanges invisibles entre plusieurs machines, consommant chacune de l’électricité. C’est l’ensemble de ce circuit, souvent ignoré par l’utilisateur, qui constitue l’empreinte numérique.


### Problématique ou motivations

Malgrés la croissance de l’activité numérique, la majorité des utilisateurs ne perçoivent pas son coût environnemental. L’empreinte numérique reste abstraite, car elle est difficile à visualiser, et ses effets sont différés, invisibles, et peu médiatisés.
Il n’existe que très peu d’outils accessibles permettant de rendre compréhensible l’impact d’une action numérique simple, comme consulter une vidéo ou utiliser un service cloud.

Ainsi dans un contexte où les enjeux environnementaux deviennent cruciaux, il est essentiel de développer des outils pédagogiques et accessibles pour faire comprendre l’impact des usages numériques. Ce projet se situe à la croisée de l’électronique, du mobile, et de la conscience écologique. Il propose une approche simple, intuitive et mesurable pour rendre visible l’invisible.

### Proposition et objectifs

Le projet Datarium a pour ambition de concevoir un dispositif interactif de sensibilisation à l’impact environnemental du numérique. Il s’inscrit dans une volonté pédagogique de rendre visible, compréhensible et tangible une empreinte souvent invisible : celle de nos actions numériques quotidiennes. Le dispositif associe un retour physique ou graphique en temps réel (jauge lumineuse, affichage à l’écran, son, etc.) à une application mobile qui collecte, estime et restitue les données environnementales de chaque usage. Cette proposition repose sur plusieurs objectifs fondamentaux :

#### Rendre perceptible l’empreinte numérique au moment de l’usage
  L’empreinte numérique est souvent abstraite ou différée (émissions CO₂, consommation électrique, usage des ressources).

  En affichant une représentation instantanée (ex. : une LED qui passe du vert au rouge selon la charge environnementale), Datarium crée un effet de feedback immédiat, qui aide à comprendre l’impact au moment de l’action.

#### Sensibiliser sans culpabiliser
   Le projet ne cherche pas à pointer du doigt les utilisateurs, mais à donner des repères concrets pour mieux comprendre et arbitrer ses choix numériques.

   En proposant peut-etre des comparaisons simples (ex. : "cette vidéo HD = 200g CO₂ = 2 km en voiture"), l’interface favorise une prise de conscience accessible.

#### Encourager des usages numériques plus responsables
  L’objectif est de favoriser des comportements de sobriété numérique volontaire, comme :

    - préférer le Wi-Fi à la 5G

    - limiter la lecture de vidéos en haute résolution, ou l'utilisation de l'IA

    - prolonger la durée de vie des équipements

  En traduisant les impacts en unités tangibles, Datarium aide l’utilisateur à mieux ajuster ses pratiques sans contraintes techniques.

#### Adapter l’affichage selon le type d’action et de connexion
  Une requête d’IA, une vidéo en streaming, un e-mail ou une recherche web n’ont pas le même impact.

  Le système est pensé pour analyser le type de service utilisé (via des protocoles ou des signatures réseau) et le mode de connexion (Wi-Fi, 4G, 5G) afin d’ajuster dynamiquement l’indicateur.

#### Offrir un support à la pédagogie et à la recherche
   Le dispositif constitue un outil d’observation comportementale, permettant de mesurer les effets de rétroaction visuelle sur les habitudes numériques.

#### Renforcer la transparence sur l’empreinte réelle du numérique
   En s’appuyant sur les données de la littérature scientifique (ACV, études sur l’IA, impact des data centers), Datarium se positionne comme un outil de médiation citoyenne face à l’opacité des impacts numériques.

## Échéancier

!!! info
    Le suivi complet est disponible dans la page [Suivi de projet](suivi.md).

| Jalon (*Milestone*)            | Date prévue   | Livrable                            | Statut      |
|--------------------------------|---------------|-------------------------------------|-------------|
| Ouverture de projet            | 1 mai         | Proposition de projet               | ✅ Terminé  |
| Analyse des exigences          | 16 mai        | Document d'analyse                  | 🔄 En cours |
| Prototype 1                    | 23 mai        | Maquette + Flux d'activités         | 🔄 En cours |
| Prototype 2                    | 30 mai        | Prototype finale + Flux             | ⏳ À venir  |
| Architecture                   | 30 mai        | Diagramme UML ou modèle C4          | ⏳ À venir  |
| Modèle de donneés              | 6 juin        | Diagramme UML ou entité-association | ⏳ À venir  |
| Revue de conception            | 6 juin        | Feedback encadrant + ajustements    | ⏳ À venir  |
| Implémentation v1              | 20 juin       | Application v1                      | ⏳ À venir  |
| Implémentation v2 + tests      | 11 juillet    | Application v2 + Tests              | ⏳ À venir  |
| Implémentation v3              | 1er août      | Version finale                      | ⏳ À venir  |
| Tests                          | 11-31 juillet | Plan + Résultats intermédiaires     | ⏳ À venir  |
| Évaluation finale              | 8 août        | Analyse des résultats + Discussion  | ⏳ À venir  |
| Présentation + Rapport         | 15 août       | Présentation + Rapport              | ⏳ À venir  |
