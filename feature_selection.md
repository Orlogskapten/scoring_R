# Feature Selection

Nous allons maintenant utiliser une méthode de sélection de variable dans le but d'utiliser uniquement les variables les plus pertinentes dans l'explication de notre variable cible (BAD). Cela nous permettra de diminuer la variance du modèle, et donc notre modèle sera plus précis quand appliqué à des données réelles.

Etant donné que le nombre de variables disponibles dans notre jeux de données est relativement faible (13 variables, 20 si l'on compte les différentes modalités des facteurs), une recherche pas à pas ne sera pas nécessaire. Nous allons donc utiliser des recherches exhaustives, qui nous assureront d'obtenir les meilleures combinaisons de variables.

Nous avons utilisé les critères AIC (Critère d'Information d'Akaike) et BIC (Critère d'Information Bayésien) pour la sélection des variables, et avons comparé les résultats.
Pour le critère AIC, les variables suivantes ont été sélectionnées :
- LOAN
- MORTDUE
- REASON
- JOB
- YOJ
- DEROG
- DELINQ
- CLAGE
- NINQ
- CLNO
- DEBTINC

Autrement dit, la variable VALUE n'a pas été retenue, ce qui semble cohérent avec le fait qu'elle soit fortement corrélée avec MORTDUE. L'AIC obtenu par bestglm en utilisant cette meilleure combinaison de variable est de 4327.09.

Pour le critère BIC, les variables suivantes ont été sélectionnées :
- LOAN
- MORTDUE
- JOB
- DEROG
- DELINQ
- CLAGE
- NINQ
- DEBTINC

Nous pouvons ainsi observer que le critère BIC a été plus sévère et a retenu moins de variables (8 variables) que le critère AIC (11 variables). Celà semble logique car le BIC est reconnu pour pénaliser plus fortement le nombre de paramètres à estimer que le l'AIC
