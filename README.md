# projet-analyse-de-données 

## Présentation du projet

Ce projet a pour objectif d’analyser et d’exploiter les statistiques des différents composants de Mario Kart 8 Deluxe (personnages, karts, roues et ailes) afin de déterminer la meilleure combinaison possible en fonction des préférences du joueur.

Chaque composant du jeu possède des caractéristiques spécifiques (vitesse, accélération, maniabilité, poids, etc.). Le choix d’un véhicule dans Mario Kart 8 Deluxe repose donc sur des arbitrages entre ces statistiques. L’objectif du projet est d’automatiser cette recherche afin d’identifier les combinaisons qui maximisent les performances selon les critères définis par l’utilisateur.

## Processus de création du questionnaire 
Dans un premier temps nous avons créer nos bases de statstiques, pour les personnages, les roues, les planneurs et les karts. 
Apres avoir importé nos bases, nous avons determiner pour les 30 circuits de Mario Kart 8 Deluxe son type (eau, vol, grande vitesse, technique)

par la suite pour chaque type de circuits on a determiner un poucentage pour chaque catégorie. par exemple, pour un circuit eau, les varibale vitesse eau et maniabilité eau sont plus importante que celle pour le sol l'air ou la gravité. 

Pour la création de notre questionnaire, nous avons pris la décision de le faire en 2 parties. 
Dans un premier temps, le joueur choisi son personnage préféré puis sont circuit. et ensuite il détermine ces preferences en fonction de nos différentes catégories qui définisse sont style de jeu. 
Notre code calcule esuite le meilleur combo pour maximiser les statistiques afin de proposer le meilleur combo en focntion des préferences du jeu du joueur. 

Les objectifs principaux du projet sont les suivants :

- Importer et structurer les bases de données contenant les statistiques des composants de Mario Kart 8 Deluxe

- Combiner les statistiques des personnages, karts, roues et ailes

- Permettre à l’utilisateur de définir ses préférences de performance (par exemple : vitesse maximale, accélération, maniabilité)

- Identifier les meilleures combinaisons possibles en fonction de ces préférences

- Comparer et classer les différentes configurations de véhicules

## Données utilisées

Le projet repose sur plusieurs bases de données au format CSV, stockées dans le dossier "données".
Chaque base correspond à un type de composant du jeu :

Statistiques des personnages

Statistiques des karts

Statistiques des roues

Statistiques des ailes (planeurs)

Ces bases de données contiennent les valeurs numériques associées aux différentes statistiques de performance utilisées dans le jeu.

## Principe de fonctionnement

Le code procède de la manière suivante :

Chargement des différentes bases de données

Fusion des statistiques des composants pour générer l’ensemble des combinaisons possibles

Calcul des statistiques globales de chaque combinaison

Application d’un critère de sélection basé sur les préférences du joueur

Classement des combinaisons afin d’identifier celles offrant les meilleures performances

Le résultat final permet de recommander une ou plusieurs configurations optimales selon le style de jeu recherché.
