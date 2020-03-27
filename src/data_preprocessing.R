# This r file handles the preprocessing of the dataset.
# How to take raw data and convert these to data exploitable by the model?
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/no_na_dataset.csv"
DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/preprocessed_dataset.csv"

# Data import
data <- read.csv(DATA_SOURCE)
head(data)


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

# Export the preprocessed dataset
head(data)
write.csv(data, file=DATA_EXPORT, row.names=FALSE)
