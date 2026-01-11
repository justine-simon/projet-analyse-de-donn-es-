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

Dans un premier temps, nous avons construit nos propres bases de données à partir des statistiques du site Mario Wiki. Des points sont ainsi attribués à chaque élément constituant le kart, ainsi qu’à chaque personnage, et ce pour la vitesse sur le sol, dans l’eau, dans l’air et en antigravité, ainsi que pour la maniabilité (ou manutention) dans ces mêmes environnements, le poids, l’accélération et le mini-turbo. Il est important de préciser que le jeu stocke les statistiques des pilotes et des pièces sous forme de points : pour chaque caractéristique, la somme des points du pilote, de la carrosserie, des pneus et du planeur donne un score compris entre 0 et 20, l’objectif étant d’obtenir la valeur la plus élevée possible afin d’être le plus performant. De ce fait, nous avons constitué quatre bases distinctes regroupant respectivement :

- les caractéristiques des personnages
- les statistiques des karts
- les statistiques des roues
- les statistiques des planeurs.

Les données ont ensuite été importées depuis des fichiers CSV, puis nettoyées et harmonisées. Un nettoyage automatique des noms de colonnes a notamment été effectué (standardisation en minuscules et en underscores) afin d’éviter les erreurs de saisie et de faciliter la fusion des bases. De plus, dans la base des personnages, certaines valeurs de la variable taille étaient indiquées par blocs ; nous avons donc propagé la catégorie correspondante à l’ensemble des personnages concernés. Enfin, pour chacune des bases, nous avons calculé des statistiques moyennes de vitesse et de maniabilité à partir des performances selon les différents environnements (sol, eau, air et antigravité).

## Classification des circuits et pondérations

Nous avons classé les 30 circuits de Mario Kart 8 Deluxe en quatre grandes catégories selon leurs caractéristiques dominantes :

- Circuits aquatiques (EAU)
- Circuits aériens (VOL)
- Circuits orientés vitesse (VITESSE)
- Circuits techniques (TECHNIQUE)

À chaque catégorie de circuit est associée une pondération spécifique des environnements (sol, eau, air, antigravité).
Par exemple, pour un circuit aquatique, les statistiques de vitesse et de maniabilité en eau sont davantage valorisées que celles liées aux autres environnements.
Ces pondérations permettent d’adapter l’évaluation des performances au contexte réel de course. De plus, pour simplifier l’analyse, nous avons affecté chaque circuit à une seule catégorie , ce qui rend le système plus lisible et plus facile à interpréter.


## Conception du questionnaire utilisateur

Le projet repose sur un questionnaire interactif en deux étapes :

### 1. Choix du contexte de jeu
Le joueur sélectionne son personnage préféré. Il choisit ensuite un circuit parmi la liste proposée, ce qui détermine automatiquement la catégorie du circuit et les pondérations associées. Nous avons aussi ajouté des contrôles de saisie : si le nom du personnage ou du circuit est mal écrit, le programme redemande une saisie correcte en affichant à nouveau la liste.

### 2. Définition des préférences de jeu
Le joueur attribue une note (de 0 à 10) à plusieurs critères de performance :
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
5. Construction d’un score global pour chaque combinaison, basé sur les préférences du joueur ; les statistiques du véhicule et les pondérations liées au circuit.
6. Classement des configurations par ordre décroissant de performance.

En effet, nous avons généré l’ensemble des combinaisons possibles entre les karts, les roues et les planeurs à l’aide d’un produit cartésien. Afin d’éviter les conflits de noms de variables, nous avons renommé les colonnes de statistiques de chaque composant en leur ajoutant un suffixe indiquant leur origine (kart, roue ou planeur). Pour chaque combinaison, nous avons ensuite calculé les statistiques finales du véhicule en additionnant les valeurs du kart, des roues, du planeur et du personnage choisi par l’utilisateur. Ces statistiques sont ensuite ajustées au contexte du circuit grâce à des pondérations spécifiques aux environnements (sol, eau, air et antigravité), permettant de calculer une vitesse et une maniabilité contextuelles. À partir de ces valeurs et du vecteur de préférences normalisé du joueur, nous construisons un score global pour chaque configuration. Enfin, toutes les combinaisons sont classées par ordre décroissant de score, ce qui permet d’identifier automatiquement la meilleure configuration ainsi que les meilleures alternatives.

## Données utilisées

Le projet repose sur plusieurs fichiers CSV, fais nous même, contenant les statistiques numériques des composants de Mario Kart 8 Deluxe.
Ces données constituent la base de calcul de l’ensemble des performances et permettent de reproduire fidèlement les mécaniques statistiques du jeu. 

