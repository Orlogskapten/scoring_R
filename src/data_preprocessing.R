# This r file handles the preprocessing of the dataset.
# How to take raw data and convert these to data exploitable by the model?

DATA_SOURCE = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/no_na_dataset.csv"
DATA_EXPORT = "C:/Users/paull/Desktop/MoSEF/Scoring/scoring_R/data/preprocessed_dataset.csv"

# Data import
data <- read.csv(DATA_SOURCE)
head(data)


##### One Hot Encoding the two factors variables #####
# REASON
for(value in unique(data$REASON)){
  new_column_name <- paste("REASON", value, sep="_")
  data[new_column_name] <- 0
  data[data["REASON"] == value, new_column_name] <- 1
}
data$REASON <- NULL

# Debtcon
for(value in unique(data$JOB)){
  new_column_name <- paste("JOB", value, sep="_")
  data[new_column_name] <- 0
  data[data["JOB"] == value, new_column_name] <- 1
}
data$JOB <- NULL
head(data)

# Export the preprocessed dataset
write.csv(data, file=DATA_EXPORT, row.names=FALSE)
