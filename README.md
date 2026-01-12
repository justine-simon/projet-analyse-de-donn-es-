# Projet-analyse-de-données 

## Présentation du projet

Ce projet vise à analyser et exploiter les statistiques des différents composants de Mario Kart 8 Deluxe (personnages, karts, roues et planeurs) afin de déterminer automatiquement la combinaison optimale en fonction des préférences du joueur.

Dans Mario Kart 8 Deluxe, chaque composant possède des caractéristiques spécifiques (vitesse, accélération, maniabilité, poids, mini-turbo, etc.). Le choix d’un véhicule repose donc sur des arbitrages entre ces statistiques, qui dépendent à la fois du style de jeu du joueur et du type de circuit et de personnage sélectionné.


## Objectifs du projet

Les objectifs principaux de ce projet sont :

- intégrer des préférences utilisateur via un questionnaire interactif 
- mettre en place un système de pondération contextuelle 
- automatiser le classement et la sélection de solutions optimales 
- proposer une aide à la décision personnalisée pour le joueur.


## Construction des bases de données

Dans un premier temps, nous avons construit nos propres bases de données à partir des statistiques du site Mario Wiki. 
Des points sont ainsi attribués à chaque élément constituant le kart, ainsi qu’à chaque personnage, et ce pour la vitesse sur le sol, dans l’eau, dans l’air et en antigravité, ainsi que pour la maniabilité (ou manutention) dans ces mêmes environnements, le poids, l’accélération et le mini-turbo. Il est important de préciser que le jeu stocke les statistiques des pilotes et des pièces sous forme de points : pour chaque caractéristique, la somme des points du pilote, de la carrosserie, des pneus et du planeur donne un score compris entre 0 et 20, l’objectif étant d’obtenir la valeur la plus élevée possible afin d’être le plus performant. 
De ce fait, nous avons constitué quatre bases distinctes regroupant respectivement :

- les statistiques des personnages
- les statistiques des karts
- les statistiques des roues
- les statistiques des planeurs.

Les données ont ensuite été importées depuis des fichiers CSV, via le package readr, qui nous a permis d'indiquer le séparateur de colonnes, gérer les virgules décimales et convertir les données en tableaux exploitables. Ensuite, nous avons nettoyé et harmonisé nos bases grâce aux packages dplyr et janitor, qui nous ont permis de filtrer des lignes, sélectionner des colonnes, renommer des variables, créer de nouvelles colonnes et simplifier leurs noms. En effet, un nettoyage automatique des noms de colonnes a notamment été effectué (standardisation en minuscules et en underscores) afin d’éviter les erreurs de saisie et de faciliter la fusion des bases. De plus, dans la base des personnages, certaines valeurs de la variable taille étaient indiquées par blocs, nous avons donc propagé la catégorie correspondante à l’ensemble des personnages concernés. Enfin, pour chacune des bases, nous avons calculé des statistiques moyennes de vitesse et de maniabilité à partir des performances selon les différents environnements (sol, eau, air et antigravité).


## Classification des circuits et pondérations

Nous avons classé 30 circuits de Mario Kart 8 Deluxe en quatre grandes catégories selon leurs caractéristiques dominantes :

- Circuits aquatiques (EAU)
- Circuits aériens (VOL)
- Circuits orientés vitesse (VITESSE)
- Circuits techniques (TECHNIQUE)
  
Nous avons fait le choix de simplifier la classification en attribuant chaque circuit à une seule catégorie, même si, dans la réalité, un circuit peut comporter plusieurs types de zones, comme par exemple du sol et de l’eau. Le critère retenu a donc été l’environnement dominant sur l’ensemble du circuit.

À chaque catégorie de circuit, nous avons associé une pondération spécifique des environnements (sol, eau, air, antigravité).
La pondération des circuits sert à adapter le calcul de la vitesse et de la maniabilité au type de piste choisi, au lieu d’utiliser des valeurs “moyennes” identiques partout. Concrètement, chaque catégorie de circuit est associée à un jeu de coefficients (qui somment à 1) répartis sur les quatre environnements : sol, eau, air et antigravité. 
Par exemple, un circuit EAU utilise sol = 0,40, eau = 0,45, air = 0,05, anti = 0,10 (donc on privilégie fortement les performances en eau), un circuit VOL utilise sol = 0,35, eau = 0,10, air = 0,40, anti = 0,15 (on valorise davantage l’air), et les circuits VITESSE / TECHNIQUE utilisent sol = 0,45, eau = 0,05, air = 0,10, anti = 0,40. 
Ces coefficients auront donc un impact sur le score final. 


## Conception du questionnaire utilisateur

Le projet repose sur un questionnaire intéractif en deux étapes :

### 1. Choix du contexte de jeu

Dans un premier temps, le joueur choisit son personnage et son circuit.
Le programme affiche d’abord la liste complète des personnages disponibles dans la base de données. L’utilisateur doit en saisir un. Pour éviter les erreurs, nous avons nettoyé tous les noms (passage en minuscules, suppression des espaces inutiles) et nous utilisons une boucle de contrôle : si le personnage n’est pas trouvé, le programme affiche un message d’erreur et redemande la saisie en proposant à nouveau la liste.
Le même principe est appliqué pour le circuit. Le joueur choisit un circuit parmi la liste proposée. Ce choix est très important, chaque circuit étant associé à une catégorie.

### 2. Définition des préférences de jeu
Dans un second temps, le joueur attribue une note (de 0 à 10) à plusieurs critères de performance :

- vitesse 
- mini-turbo (drift) 
- maniabilité 
- accélération 
- poids.

Ces préférences sont normalisées afin de construire un profil de jeu cohérent, utilisé ensuite pour le calcul du score final. En effet, cette étape est essentielle car elle permet d’interpréter les réponses non pas comme des valeurs absolues, mais comme des poids relatifs. En effet, deux joueurs peuvent avoir exactement les mêmes préférences tout en utilisant des échelles différentes (par exemple 10–10–10–10–10 ou 5–5–5–5–5). Sans normalisation, ces deux profils produiraient des scores différents alors qu’ils traduisent le même style de jeu. La normalisation consiste à diviser chaque préférence par la somme totale afin d’obtenir un vecteur dont la somme vaut 1. Ainsi, chaque valeur représente la part d’importance accordée à un critère (vitesse, maniabilité, etc.), ce qui rend les scores comparables et cohérents entre utilisateurs.


## Principe de fonctionnement de l’algorithme

Le code fonctionne selon les étapes suivantes :

1. Chargement et préparation des bases de données.
2. Génération de l’ensemble des combinaisons possibles entre karts, roues et planeurs.
3. Addition des statistiques de chaque composant avec celles du personnage choisi.
4. Calcul de statistiques contextuelles (vitesse et maniabilité pondérées selon le type de circuit).
5. Construction d’un score global pour chaque combinaison, basé sur les préférences du joueur, les statistiques du véhicule et les pondérations liées au circuit.
6. Classement des configurations par ordre décroissant de performance.

En effet, nous avons généré l’ensemble des combinaisons possibles entre les karts, les roues et les planeurs à l’aide d’un produit cartésien. Afin d’éviter les conflits de noms de variables, nous avons renommé les colonnes de statistiques de chaque composant en leur ajoutant un suffixe indiquant leur origine (kart, roue ou planeur). Pour chaque combinaison, nous avons ensuite calculé les statistiques finales du véhicule en additionnant les valeurs du kart, des roues, du planeur et du personnage choisi par l’utilisateur. Ces statistiques sont ensuite ajustées au contexte du circuit grâce à des pondérations spécifiques aux environnements (sol, eau, air et antigravité), permettant de calculer une vitesse et une maniabilité contextuelles. À partir de ces valeurs et du vecteur de préférences normalisé du joueur, nous construisons un score global pour chaque configuration. Enfin, toutes les combinaisons sont classées par ordre décroissant de score, ce qui permet d’identifier automatiquement la meilleure configuration ainsi que les meilleures alternatives. 
Ainsi, le code renvoit uniquement le classement des 10 meilleurs combos et le meilleur de ce classement. 


## Limites du projet

Notre projet fonctionne en théorie, cependant nous pouvons émettre différentes limites à celui-ci. 
En effet, les pondérations attribués aux catégories de circuits reposent sur des hypothèses et non sur des données empiriques issues du jeu. De même, la catégorisation des circuits est très simplifiée dans notre modèle, puisqu'il n'y en a que 4 et que chaque circuit appartient à une seule catégorie. De plus, le score calculé est une agrégation pondérée de statistiques, ce qui implique une hypothèse forte : chaque critère contribue de façon indépendante aux résultats. En pratique, il existe des interactions entre les varibales que notre modèle ne capture pas. Enfin, cela peut être compliqué pour un joueur de déterminer son style de jeu à travers des notes. 
