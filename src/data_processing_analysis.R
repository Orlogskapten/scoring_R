# This r file handles the analysis of the preprocessing of the dataset.
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/preprocessed_dataset.csv"

library(gridExtra)


# Data import
data <- read.csv(DATA_SOURCE)
head(data)

# Histogram function
hist_plot= function(data, variable_name, color= "orange"){
  ggplot2::ggplot(as.data.frame(data)
                  , ggplot2::aes(x= data[, c(variable_name)])
                  , na.rm= T
  ) +
    ggplot2::geom_histogram(col= "black", fill= color, ggplot2::aes(y= ..count..), bins= 30) +
    ggplot2::xlab(variable_name)
}

# Figure size management 
fig <- function(width, heigth){
  options(repr.plot.width= width, repr.plot.height= heigth)
}

fig(2,2)
h_loan= hist_plot(data, "LOAN")
h_mort= hist_plot(data, "MORTDUE")
h_val= hist_plot(data, "VALUE")
h_yoj= hist_plot(data, "YOJ")
h_cla= hist_plot(data, "CLAGE")
h_cln= hist_plot(data, "CLNO")
h_debt= hist_plot(data, "DEBTINC")


##### Before preprocessing histogram
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"
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

# JOB
for(value in unique(data$JOB)){
  new_column_name <- paste("JOB", value, sep="_")
  data[new_column_name] <- 0
  data[data["JOB"] == value, new_column_name] <- 1
}
data$JOB <- NULL

##### Log transformation for LOAN, VALUE and MORTDUE
for (col in c("LOAN", "VALUE", "MORTDUE")){
  data[, c(col)]= log(1 + data[, c(col)])
}

fig(2,2)
b_loan= hist_plot(data, "LOAN")
b_mort= hist_plot(data, "MORTDUE")
b_val= hist_plot(data, "VALUE")
b_yoj= hist_plot(data, "YOJ")
b_cla= hist_plot(data, "CLAGE")
b_cln= hist_plot(data, "CLNO")
b_debt= hist_plot(data, "DEBTINC")

#plot(h_debt)

##### Assembling those plots
g= arrangeGrob(b_loan, h_loan
               , b_mort, h_mort
               , b_val, h_val
               , b_yoj, h_yoj
               , b_cla, h_cla
               , b_cln, h_cln
               , b_debt, h_debt
               , ncol= 2, nrow= 7, top= "(A gauche) La distribution avant le scaling
(A droite) La distribution après le scaling"
)
  
ggplot2::ggsave("C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/images/before_after_dist_scale.png", g, width= 5, height= 7)

