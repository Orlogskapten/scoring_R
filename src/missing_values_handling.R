# This r file handles the feature engineering relative to the handling of 
# missing values in the dataset.
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/hmeq.csv"
DATA_EXPORT = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"

library(naniar)

data = read.csv(DATA_SOURCE)
head(data)

# Visualizing missing values before handling
vis_miss(data, warn_large_data=F)

# Print the percentage of missing values into each columns
na_col= function(data){
  colSums(is.na(data))/nrow(data)
}

na_row= function(data){
  rowSums(is.na(data_new))/12
}

na_col(data) # taux de na dans les colonnes (variable)

##### Handling the rows with too many missing values #####
# First, we consider "" values for JOB and REASON as missing values (NA)
data[data["JOB"] == "", "JOB"] = NA
data[data["REASON"] == "", "REASON"] = NA

# Threshold = 0.37
# It eliminates simultaneous DEROG, DELINQ, CLAGE, NINQ and CLNO NA
data= data[-which(rowMeans(is.na(data)) > 0.37), ] 
vis_miss(data, warn_large_data= F)
dim(data)

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
data[is.na(data["JOB"]), "JOB"] <- "missing_value"
data$JOB <- as.factor(data$JOB)

data$REASON <- as.character(data$REASON)
data[is.na(data["REASON"]), "REASON"] <- "missing_value"
data$REASON <- as.factor(data$REASON)

# Visualizing missing values after handling
vis_miss(data, warn_large_data=F)
na_col(data)
head(data)

# Exporting the altered dataset to csv file
write.csv(data, file=DATA_EXPORT, row.names=FALSE)

