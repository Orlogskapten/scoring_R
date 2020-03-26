# This r file handles the analysis of correlation between our features
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"

#install.packages("ggcorrplot")
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
num_data= num_data[order(num_data$BAD), ]
num_data$BAD= as.factor(num_data$BAD)

head(num_data)
tail(num_data)

boxplot_anova= function(data, variable){
  m_1= mean(data[(data$BAD==1), c(variable)])
  m_0= mean(data[(data$BAD==0), c(variable)])
  
  data$BAD= as.factor(data$BAD)
  # Extract p_value from summary "dataframe"
  p= summary(aov(data[, c(variable)] ~ BAD, data= data))[[1]][["Pr(>F)"]][1]
  if (p<0.05){res= paste("Toutes les moyennes de", variable, "sont différentes")
  } else {res= paste("Toutes les moyennes de", variable
  , "sont égales")}
  
  g= ggplot2::ggplot(data, ggplot2::aes(x= BAD, y= data[, c(variable)], fill= BAD)) +
    geom_boxplot() +
    ggplot2::scale_fill_manual(values=c("darkgreen","darkred")) +
    ggplot2::geom_segment(x=1, y=m_0, xend=2, yend=m_1, size= 1.5, color= "red") +
    ggplot2::labs(y= variable, title= res)
}

loan= boxplot_anova(data, "LOAN")
mort= boxplot_anova(data, "MORTDUE")
value= boxplot_anova(data, "VALUE")
yoj= boxplot_anova(data, "YOJ")
clage= boxplot_anova(data, "CLAGE")
clno= boxplot_anova(data, "CLNO")
debt= boxplot_anova(data, "DEBTINC")

print(debt)

