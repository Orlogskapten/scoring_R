# Feature Selection

Nous allons maintenant utiliser une méthode de sélection de variable dans le but d'utiliser uniquement les variables les plus pertinentes dans l'explication de notre variable cible (BAD). Cela nous permettra de diminuer la variance du modèle, et donc notre modèle sera plus précis quand appliqué à des données réelles.

Etant donné que le nombre de variables disponibles dans notre jeux de données est relativement faible (13 variables, 20 si l'on compte les différentes modalités des facteurs), une recherche pas à pas ne sera pas nécessaire. Nous allons donc utiliser une recherche exhaustive, qui nous assurera d'obtenir la meilleure combinaison de variables.

Nous avons choisi d'utiliser le critère d'AIC pour le choix des variables, et le package bestglm nous a permis de sélectionner les variables suivantes :
- LOAN
- MORTDUE
- REASONHomeImp
- REASONmissing_value
- JOBmissing_value
- JOBOffice
- JOBOther
- JOBProfExe
- JOBSales
- JOBSelf
- YOJ
- DEROG
- DELINQ
- CLAGE
- NINQ
- CLNO
- DEBTINC

Autrement dit, la variable VALUE n'a pas été retenue. L'AIC obtenu par bestglm en utilisant cette meilleure combinaison de variable est de 4327.09.
