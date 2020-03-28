# This r file handles the feature selection process
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/preprocessed_dataset.csv"
AIC_DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/AIC_selection.csv"
BIC_DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/BIC_selection.csv"

library(bestglm)

data <- read.csv(DATA_SOURCE)
# Changing columns order for bestglm method
data <- data[c("LOAN", "MORTDUE", "VALUE", "REASON", "JOB", "YOJ", "DEROG", 
               "DELINQ", "CLAGE", "NINQ", "CLNO", "DEBTINC", "BAD")]

##### AIC exhaustive feature selection #####
aic_model <- bestglm(data, family=binomial, IC="AIC")
aic_model$BestModel
# The selected features:
aic_model$BestModels[1,]


##### BIC exhaustive feature selection #####
bic_model <- bestglm(data, family=binomial, IC="BIC")
bic_model$BestModel
# The selected features:
bic_model$BestModels[1,]


aic_selection <- data
bic_selection <- data

# Drop the non-selected features
for(column in colnames(data)){
  if(column != "BAD" && !aic_model$BestModels[1, column]){
    aic_selection[column] <- NULL
  }
  if(column != "BAD" && !bic_model$BestModels[1, column]){
    bic_selection[column] <- NULL
  }
}

# Export the dataset containing only the selected features
write.csv(aic_selection, file=AIC_DATA_EXPORT, row.names=FALSE)
write.csv(bic_selection, file=BIC_DATA_EXPORT, row.names=FALSE)
