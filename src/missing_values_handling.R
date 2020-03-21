# This r file handles the feature engineering relative to the handling of 
# missing values in the dataset.
DATA_SOURCE = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/hmeq.csv"
DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/no_na_dataset.csv"

library(naniar)

data = read.csv(DATA_SOURCE)
head(data)

# Visualizing missing values before handling
vis_miss(data, warn_large_data=F)

colSums(is.na(data))/nrow(data) # taux de na dans les colonnes (variable)

##### Handling the numerical columns missing values #####
# Fill NA continuous numerical values with mean of the column
for (column in c("MORTDUE", "VALUE", "YOJ", "CLAGE", "DEBTINC")) {
  data[is.na(data[column]), column] <- mean(data[!is.na(data[column]), column])
}

# Fill NA non-continuous numerical values with median one
for (column in c("DEROG", "DELINQ", "NINQ", "CLNO")) {
  data[is.na(data[column]), column] <- median(data[!is.na(data[column]), column])
}

##### Handling string-like missing values with new specific string
data$JOB <- as.character(data$JOB)
data[is.na(data["JOB"]), "JOB"] <- "NULL"
data$JOB <- as.factor(data$JOB)

data$REASON <- as.character(data$REASON)
data[is.na(data["REASON"]), "REASON"] <- "NULL"
data$REASON <- as.factor(data$REASON)

# Visualizing missing values after handling
vis_miss(data, warn_large_data=F)
head(data)

# Exporting the altered dataset to csv file
write.csv(data, file=DATA_EXPORT, row.names=FALSE)

