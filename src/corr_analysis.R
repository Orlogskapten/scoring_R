# This r file handles the analysis of correlation between our features
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"

install.packages("ggcorrplot")
library(ggcorrplot)
library(dplyr)


# Data import
data <- read.csv(DATA_SOURCE)
head(data)

# We are going to save the categorical feature

##### Log transformation for LOAN, VALUE and MORTDUE
for (col in c("LOAN", "VALUE", "MORTDUE")){
  data[, c(col)]= log(1 + data[, c(col)])
}


##### Feature Scaling for the numerical columns #####
for(column in c("LOAN", "MORTDUE", "VALUE", "YOJ", "CLAGE", "CLNO", "DEBTINC")){
  column_mean <- colMeans(data[column])
  column_std <- sd(as.double(data[[column]]))
  data[column] <- (data[column] - column_mean) / column_std
}

##### Test if X can explain Y 
# X and Y 2 categorical features
# it return if X explain Y
chi_test= function(data_chi, x, seuil= 0.05){
  print("on test H0 : 'les répartitions de Y parmi les différentes modalités de X sont
        différentes ou non'")
  chi2= chisq.test(data_chi$BAD, data_chi[, c(x)])
  p_val= chi2$p.value #: la p-value.
  print(p_val)
  print("Résultat du test :")
  if (p_val < seuil){print("On peut rejeter H0")} # X affect Y
  else {print("On accepte H0")}
}

chi_test(data, "REASON")
chi_test(data, "JOB")

##### Correlation between numerical variables
num_data= data[,-c(1, 5, 6)]
co= round(cor(num_data), 2)
g= ggcorrplot::ggcorrplot(co)
print(g)

ggplot2::ggsave("C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/images/corr.png", g, width= 4, height= 4)


##### ANOVA
num_data= data[,-c(5, 6)]
# ARRIVER A GORGONNDER LES MODALITE DE BAD 00000...111111
num_data$BAD= as.factor(num_data$BAD)
num_data$BAD= ordered(num_data$BAD, levels= c(1, 0))

head(num_data)

g= group_by(num_data, BAD) %>%
  summarise(
    count = n(),
    mean = mean(num_data$LOAN, na.rm = TRUE),
    sd = sd(num_data$LOAN, na.rm = TRUE)
  )
g

mean(data[(data$BAD=1), c("LOAN")], na.rm= T)


