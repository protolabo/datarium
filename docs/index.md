# Projet IFT3150: Datarium

> **Thèmes**: Systemes embarqués, Génie logiciel, Application mobile  
> **Superviseur**: Louis-Edouard Lafontant  
> **Collaborateurs:** Nom de(s) collaborateur(s) et partenaire(s)

## Informations importantes

<!-- !!! info "Dates importantes"
    - **Description du projet** : 16 mai 2025
    - **Foire 1: Prototypage** : 9-13 juin 2025
    - **Foire 2: Version beta** : 14-18 juillet 2025
    - **Présentation et rapport** : 11-15 août 2025 -->

## Équipe

- Aïssatou Ndiaye: Responsable de...
- Wendkuni Reine Rosine Guinguiere : Responsable de...
- Papa Moussa Diabaté: Responsable de...

## Description du projet

&nbsp;&nbsp;&nbsp;&nbsp;Datarium est un projet visant à concevoir un dispositif interactif de visualisation de l'empreinte numerique appelé thermometre de données. 

Ce dispositif reposera sur une carte Arduino zero , qui sera le coeur du systeme, permettant de collecter , traiter et afiicher les données en temps réel.

Le Thermometre de données offrira une interface visuelle de l'empreinte numérique produite par l'utilisateur ou un système , que ce soit par des indicateurs graphiques (Écran, LED, Jauge) ou par des effets physiques (Mouvement, Lumiere, Son).
Grâce à la polyvaleve de l'Arduino Zero, le dispositif pourr intégrer divers capteurs , modiles de communication et dispositifs de sortie pour fournir une visualisation  intercative.

L'objectif de Datarium est de sensibiliser les utilisateurs sur leur consommation numérique et de promouvoir des comportements plus responsables face aux ressources informatiques. En rendant l'empreinte numérique visible de manière tangible, ce projet vise à renforcer le comprehention des utilisateurs quant à leur utilisation des ressources numériques et à les inciter à adopter des pratiques plus durables.
   

### Contexte

À l’ère du numérique, nos gestes quotidiens – envoyer un courriel, naviguer sur le web, regarder une vidéo en streaming, utiliser des services cloud ou encore interagir avec des intelligences artificielles – génèrent une empreinte numérique invisible, mais bien réelle. Cette activité numérique repose sur un vaste réseau d’équipements physiques qui consomment de l’énergie à chaque étape. Par exemple, lorsqu’un utilisateur regarde une vidéo sur YouTube ou envoie un message via un chatbot, cela mobilise des serveurs distants pour traiter la demande, des réseaux Wi-Fi ou mobiles pour transmettre les données, et des appareils personnels (téléphones, ordinateurs, routeurs) pour afficher le résultat.
Même une action aussi simple que stocker un fichier dans un service en ligne comme Google Drive entraîne une série d’échanges invisibles entre plusieurs machines, consommant chacune de l’électricité. C’est l’ensemble de ce circuit, souvent ignoré par l’utilisateur, qui constitue l’empreinte numérique.


### Problématique ou motivations

Malgrés la croissance de l’activité numérique, la majorité des utilisateurs ne perçoivent pas son coût environnemental. L’empreinte numérique reste abstraite, car elle est difficile à visualiser, et ses effets sont différés, invisibles, et peu médiatisés.
Il n’existe que très peu d’outils accessibles permettant de rendre compréhensible l’impact d’une action numérique simple, comme consulter une vidéo ou utiliser un service cloud.

Ainsi dans un contexte où les enjeux environnementaux deviennent cruciaux, il est essentiel de développer des outils pédagogiques et accessibles pour faire comprendre l’impact des usages numériques. Ce projet se situe à la croisée de l’électronique, du mobile, et de la conscience écologique. Il propose une approche simple, intuitive et mesurable pour rendre visible l’invisible.

### Proposition et objectifs

Le projet Datarium a pour ambition de concevoir un dispositif interactif de sensibilisation à l’impact environnemental du numérique. Il s’inscrit dans une volonté pédagogique de rendre visible, compréhensible et tangible une empreinte souvent invisible : celle de nos actions numériques quotidiennes. Le dispositif associe un retour physique ou graphique en temps réel (jauge lumineuse, affichage à l’écran, son, etc.) à une application mobile qui collecte, estime et restitue les données environnementales de chaque usage. Cette proposition repose sur plusieurs objectifs fondamentaux :

#### Rendre visible et compréhensible l’empreinte réelle du numérique
 L’empreinte numérique est souvent différée, abstraite ou mal connue : émissions de CO₂, consommation électrique, utilisation des ressources minérales, etc. Datarium cherche à la matérialiser en temps réel, au moment même de l’usage (ex. : une LED qui change de couleur selon l’intensité de l’impact).

En s’appuyant sur des données scientifiques solides (ACV, analyses d’émissions, études sur les usages), le dispositif agit aussi comme un outil de transparence citoyenne face à l’opacité des impacts numériques. Il permet ainsi de réconcilier l’expérience utilisateur avec les conséquences environnementales réelles de ses choix numériques.


#### Encourager des usages numériques plus responsables
  L’objectif est de favoriser des comportements de sobriété numérique volontaire, comme :

    - préférer le Wi-Fi à la 5G (données mobiles)

    - limiter la lecture de vidéos en haute résolution, ou l'utilisation de l'IA

    - prolonger la durée de vie des équipements

  En traduisant et rendant lisibles les impacts en unités tangibles, Datarium aide l’utilisateur à mieux ajuster ses pratiques sans contraintes techniques.

#### Adapter l’affichage selon le type d’action et de connexion
  Une requête d’IA, une vidéo en streaming, un e-mail ou une recherche web n’ont pas le même impact.

  Le système est pensé pour analyser le type de service utilisé (via des protocoles ou des signatures réseau) et le mode de connexion (Wi-Fi, 4G, 5G) afin d’ajuster dynamiquement l’indicateur.

#### Donner à l’utilisateur le pouvoir d’explorer ses usages
 L’application mobile permettra à chaque utilisateur de :

 Choisir une catégorie de services à suivre (streaming, réseaux sociaux, requêtes IA, etc.)

Identifier quels services consomment le plus en énergie, données ou CO₂

Comparer différentes pratiques numériques et visualiser leur empreinte respective

Cette approche favorise l’appropriation individuelle des enjeux de durabilité numérique, et crée un espace interactif d’exploration et d’apprentissage personnalisé.


#### Sensibiliser sans culpabiliser
   Le projet ne cherche pas à pointer du doigt les utilisateurs, mais à donner des repères concrets pour mieux comprendre et arbitrer ses choix numériques.

   En proposant peut-etre des comparaisons simples (ex. : "cette vidéo HD = 200g CO₂ = 2 km en voiture"), l’interface favorise une prise de conscience accessible.   

## Échéancier

!!! info
    Le suivi complet est disponible dans la page [Suivi de projet](suivi.md).

| Jalon (*Milestone*)            | Date prévue   | Livrable                            | Statut      |
|--------------------------------|---------------|-------------------------------------|-------------|
| Ouverture de projet            | 1 mai         | Proposition de projet               | ✅ Terminé  |
| Analyse des exigences          | 16 mai        | Document d'analyse                  | ✅ Terminé |
| Prototype 1                    | 23 mai        | Maquette + Flux d'activités         | ✅ Terminé  |
| Prototype 2                    | 30 mai        | Prototype finale + Flux             | 🔄 En cours   |
| Architecture                   | 30 mai        | Diagramme UML ou modèle C4          | ⏳ À venir  |
| Modèle de donneés              | 6 juin        | Diagramme UML ou entité-association | ⏳ À venir  |
| Revue de conception            | 6 juin        | Feedback encadrant + ajustements    | ⏳ À venir  |
| Implémentation v1              | 20 juin       | Application v1                      | ⏳ À venir  |
| Implémentation v2 + tests      | 11 juillet    | Application v2 + Tests              | ⏳ À venir  |
| Implémentation v3              | 1er août      | Version finale                      | ⏳ À venir  |
| Tests                          | 11-31 juillet | Plan + Résultats intermédiaires     | ⏳ À venir  |
| Évaluation finale              | 8 août        | Analyse des résultats + Discussion  | ⏳ À venir  |
| Présentation + Rapport         | 15 août       | Présentation + Rapport              | ⏳ À venir  |
