# Études préliminaires

## Analyse du problème

Avec la montée en puissance des services numériques (streaming, réseaux sociaux, cloud), les utilisateurs ont de plus en plus de mal à comprendre l'impact de leur consommation numérique sur l'environnement. Cette méconnaissance les empêche de prendre des décisions responsables en matière d'utilisation des ressources numériques.

    . Les utilisateurs ne sont pas conscients de la quantité de données qu'ils consomment.

    . Ils ignorent souvent l'impact énergétique et environnemental de leur usage numérique (CO₂, énergie).

    . Il n'existe pas de solution simple et visuelle pour les sensibiliser en temps réel.

## Exigences

Exigences fonctionnelles :

1. Le dispositif doit détecter automatiquement ou permettre à l’utilisateur de sélectionner un service numérique utilisé (YouTube, Netflix, Gmail, etc.).
2. Il doit mesurer ou estimer la consommation de données associée au service utilisé.
3. Il doit afficher visuellement l'impact de cette consommation sur un dispositif physique (LED, jauge, lumière).
4. L'utilisateur doit pouvoir visualiser facilement l'impact en temps réel sur l'interface (application mobile + dispositif physique).
5. Le système doit fonctionner sur Android (détection automatique) et iOS (mode manuel).

6. L'utilisateur peut choisir la categorie ou service a mesurer 

Exigences non fonctionnelles :

1. La solution doit être simple et intuitive à utiliser.
2. L'affichage de l'impact doit être clair (vert, jaune, rouge).
3. Le dispositif doit être économe en énergie (Arduino Zero + Bluetooth).
4. La latence entre la détection de l'impact et l'affichage doit être inférieure à 1 seconde.
5. Le système doit être sécurisé (pas d’accès non autorisé aux données de l’utilisateur).


## Recherche de solutions

- GlassWire Mobile : Analyse la consommation de données par application et alerte en cas de pic. Utilise un VPN local.
- NetGuard : Firewall qui permet de bloquer les connexions d’applications spécifiques, utilise aussi un VPN local.
- TrackerControl : Montre les trackers et domaines que les applications contactent.
- Wireshark / Pi-hole : Analyse fine du trafic sur réseau local (PC).
- AdGuard iOS : Utilise un VPN local pour analyser les domaines contactés par les applications.

Comparaison avec Datarium :

Contrairement aux solutions existantes, Datarium vise à sensibiliser les utilisateurs à leur consommation numérique de manière pédagogique et visuelle, plutôt que de les protéger contre les risques de sécurité.

L’approche de Datarium est simplifiée (pas de VPN local, pas de contrôle réseau complet), mais met l'accent sur la compréhension et la sensibilisation.


## Revue de littérature


## Méthodologie

Utilisation d'une application Flutter (Android + iOS) pour la détection et la visualisation de l'impact numérique.

Communication entre l’application et l’ESP32 via Bluetooth.

ESP32 reçoit les instructions et traduit l’impact en un signal tangible (LED, jauge).

Estimation de la consommation selon le service sélectionné :

Automatique sur Android (détection de l’application active).

Manuel sur iOS (sélection du service par l’utilisateur).

Une table de correspondance entre les services et leur impact (volume de données, énergie, CO₂) sera utilisée.

