# This r file handles the feature selection process
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/preprocessed_dataset.csv"
DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/feature_selected.csv"

library(bestglm)

data <- read.csv(DATA_SOURCE)
# Changing columns order for bestglm method
data <- data[c("LOAN", "MORTDUE", "VALUE", "REASON", "JOB", "YOJ", "DEROG", 
               "DELINQ", "CLAGE", "NINQ", "CLNO", "DEBTINC", "BAD")]

model <- bestglm(data, family=binomial, IC="AIC")
model$BestModel
# The selected features:
model$BestModels[1,]

# Drop the non-selected features
for(column in colnames(data)){
  if(column != "BAD" && !model$BestModels[1, column]){
    data[column] <- NULL
  }
}

# Export the dataset containing only the selected features
head(data)
write.csv(data, file=DATA_EXPORT, row.names=FALSE)
