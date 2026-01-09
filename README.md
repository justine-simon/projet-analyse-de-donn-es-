# projet-analyse-de-données 

## Présentation du projet

Ce projet vise à analyser et exploiter les statistiques des différents composants de Mario Kart 8 Deluxe (personnages, karts, roues et planeurs) afin de déterminer automatiquement la combinaison optimale en fonction des préférences du joueur.

Dans Mario Kart 8 Deluxe, chaque composant possède des caractéristiques spécifiques (vitesse, accélération, maniabilité, poids, mini-turbo, etc.). Le choix d’un véhicule repose donc sur des arbitrages entre ces statistiques, qui dépendent à la fois du style de jeu du joueur et du type de circuit sélectionné.
L’objectif de ce projet est d’automatiser cette prise de décision en proposant, à partir de critères personnalisés, les configurations offrant les meilleures performances possibles.

## Construction des bases de données

Dans un premier temps, plusieurs bases de données ont été constituées à partir des statistiques du jeu. Elles regroupent :

- les caractéristiques des personnages ;
- les statistiques des karts ;
- les statistiques des roues ;
- les statistiques des planeurs.

Les données ont été importées depuis des fichiers CSV, nettoyées et harmonisées (noms de variables, formats numériques, cohérence des catégories) afin de permettre leur combinaison ultérieure.
Pour les personnages, des statistiques moyennes de vitesse et de maniabilité ont également été calculées à partir des performances selon l’environnement (sol, eau, air et antigravité).


## Classification des circuits et pondérations

Les 30 circuits de Mario Kart 8 Deluxe ont ensuite été classés en quatre grandes catégories selon leurs caractéristiques dominantes :

- Circuits aquatiques (EAU)
- Circuits aériens (VOL)
- Circuits orientés vitesse (VITESSE)
- Circuits techniques (TECHNIQUE)

À chaque catégorie de circuit est associée une pondération spécifique des environnements (sol, eau, air, antigravité).
Par exemple, pour un circuit aquatique, les statistiques de vitesse et de maniabilité en eau sont davantage valorisées que celles liées aux autres environnements.
Ces pondérations permettent d’adapter l’évaluation des performances au contexte réel de course.


## Conception du questionnaire utilisateur

Le projet repose sur un questionnaire interactif en deux étapes :

### 1. Choix du contexte de jeu
Le joueur sélectionne son personnage préféré. Il choisit ensuite un circuit parmi la liste proposée, ce qui détermine automatiquement la catégorie du circuit et les pondérations associées.

### 2. Définition des préférences de jeu
Le joueur attribue une note (de 0 à 10) à plusieurs critères de performance :
- vitesse ;
- mini-turbo (drift) ;
- maniabilité ;
- accélération ;
- poids.
Ces préférences sont normalisées afin de construire un profil de jeu cohérent, utilisé ensuite pour le calcul du score final.


## Principe de fonctionnement de l’algorithme

Le code fonctionne selon les étapes suivantes :

1. Chargement et préparation des bases de données.
2. Génération de l’ensemble des combinaisons possibles entre karts, roues et planeurs.
3. Addition des statistiques de chaque composant avec celles du personnage choisi.
4. Calcul de statistiques contextuelles (vitesse et maniabilité pondérées selon le type de circuit).
5. Construction d’un score global pour chaque combinaison, basé sur les préférences du joueur ; les statistiques du véhicule et les pondérations liées au circuit.
6. Classement des configurations par ordre décroissant de performance.

Le programme retourne alors la meilleure combinaison recommandée ainsi qu’un classement des meilleures configurations selon le score obtenu.


## Objectifs du projet

Les objectifs principaux de ce projet sont :

- intégrer des préférences utilisateur via un questionnaire interactif ;
- mettre en place un système de pondération contextuelle ;
- automatiser le classement et la sélection de solutions optimales ;
- proposer une aide à la décision personnalisée pour le joueur.


## Données utilisées

Le projet repose sur plusieurs fichiers CSV, fais nous même, contenant les statistiques numériques des composants de Mario Kart 8 Deluxe.
Ces données constituent la base de calcul de l’ensemble des performances et permettent de reproduire fidèlement les mécaniques statistiques du jeu. 

