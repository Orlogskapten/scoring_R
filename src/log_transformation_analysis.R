# This r file handles the analysis of the log transformation of numerical continuous features
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/no_na_dataset.csv"


library(gridExtra)

data= read.csv(DATA_SOURCE)
head(data)

data$BAD= as.factor(data$BAD)
str(data)


# Figure size management 
fig <- function(width, heigth){
  options(repr.plot.width= width, repr.plot.height= heigth)
}

#### QQplot function ####
# QQPlot function
qqploting= function(data, column_name){
  ggplot2::qplot(sample= data[, c(column_name)], data= data) +
    ggplot2::stat_qq_line()
    #ggplot2::scale_color_manual(values=c("orange"))
}

# QQPlot function with BAD values consideration
qqploting_gr= function(data, column_name){
  ggplot2::qplot(sample= data[, c(column_name)], data= data, color= BAD) +
    ggplot2::scale_color_manual(values=c("darkgreen","darkred"))
}

qqploting(data, "LOAN")
qqploting_gr(data, "LOAN")

qqploting(data, "VALUE")
qqploting_gr(data, "VALUE")

qqploting(data, "MORTDUE")
qqploting_gr(data, "MORTDUE")

qqploting(data, "YOJ")
qqploting_gr(data, "YOJ")


#### Log transformation of previous column qqploted ####
data_log= data
col= c("LOAN", "VALUE", "MORTDUE")
data_log[, col] = log(data_log[, col])
# YOJ contain value = 0, we are going to make log(1+YOJ)
data_log$YOJ= log(data_log$YOJ + 1)

qqploting(data_log, "LOAN")
qqploting(data_log, "VALUE")
qqploting(data_log, "MORTDUE")
qqploting(data_log, "YOJ")


#### Final save for .doc ####
hist_plot= function(data, variable_name, color= "orange"){
  ggplot2::ggplot(as.data.frame(data)
                          , ggplot2::aes(x= data[, c(variable_name)])
                          , na.rm= T
  ) +
    ggplot2::geom_histogram(col= "black", fill= color, ggplot2::aes(y= ..density..), bins= 50) +
    ggplot2::stat_function(fun = dnorm, colour = "black", size= 1.8,
                  args = list(mean = mean(data[, c(variable_name)], na.rm = TRUE),
                              sd = sd(data[, c(variable_name)], na.rm = TRUE)
                              )
                  ) +
    ggplot2::xlab(variable_name)
}

# Visualize our merged plot
fig(8, 10)
grid.arrange(qqploting(data, "LOAN"), hist_plot(data, "LOAN"), qqploting(data_log, "LOAN"), hist_plot(data_log, "LOAN")
             , qqploting(data, "VALUE"), hist_plot(data, "VALUE"), qqploting(data_log, "VALUE"), hist_plot(data_log, "VALUE")
             , qqploting(data, "MORTDUE"), hist_plot(data, "MORTDUE"), qqploting(data_log, "MORTDUE"), hist_plot(data_log, "MORTDUE")
             , qqploting(data, "YOJ"), hist_plot(data, "YOJ"), qqploting(data_log, "YOJ"), hist_plot(data_log, "YOJ")
             , ncol= 4, nrow= 4
)

# Save the figure
g= arrangeGrob(qqploting(data, "LOAN"), hist_plot(data, "LOAN"), qqploting(data_log, "LOAN"), hist_plot(data_log, "LOAN")
               , qqploting(data, "VALUE"), hist_plot(data, "VALUE"), qqploting(data_log, "VALUE"), hist_plot(data_log, "VALUE")
               , qqploting(data, "MORTDUE"), hist_plot(data, "MORTDUE"), qqploting(data_log, "MORTDUE"), hist_plot(data_log, "MORTDUE")
               , qqploting(data, "YOJ"), hist_plot(data, "YOJ"), qqploting(data_log, "YOJ"), hist_plot(data_log, "YOJ")
               , ncol= 4, nrow= 4
)

ggplot2::ggsave("C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/images/log_qqplot.png", g, width= 10, height= 8)
