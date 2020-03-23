# This r file handles the analysis of the log transformation of numerical continuous features
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"


data= read.csv(DATA_SOURCE)
head(data)

data$BAD= as.factor(data$BAD)
str(data)


# Figure size management 
fig <- function(width, heigth){
  options(repr.plot.width= width, repr.plot.height= heigth)
}

# QQPlot function
qqploting= function(data, column_name){
  ggplot2::qplot(sample= data[, c(column_name)], data= data) +
    ggplot2::scale_color_manual(values=c("orange"))
}

# QQPlot function with BAD values consideration
qqploting_gr= function(data, column_name){
  ggplot2::qplot(sample= data[, c(column_name)], data= data, color= BAD) +
    ggplot2::scale_color_manual(values=c("darkgreen","darkred"))
}

#### QQploting ####
qqploting(data, "LOAN")
qqploting_gr(data, "LOAN")

qqploting(data, "VALUE")
qqploting_gr(data, "VALUE")

qqploting(data, "MORTDUE")
qqploting_gr(data, "MORTDUE")

qqploting(data, "YOJ")
qqploting_gr(data, "YOJ")

