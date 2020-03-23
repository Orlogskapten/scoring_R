# This r file handles the analysis of the missing values
rm(list = ls()) # clean env
DATA_SOURCE = "C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/data/hmeq.csv"

library(naniar)
library(dplyr)

data = read.csv(DATA_SOURCE)
head(data)

# Visualizing missing values 
vis_miss(data, warn_large_data=F)
# MAR or MNAR ?

# Print the percentage of missing values into each columns
na_col= function(data){
  colSums(is.na(data))/nrow(data)
}

na_row= function(data){
  rowSums(is.na(data_new))/12
}

na_col(data)
# 21% for the DEBTINC

# Visualisation of missing values per BAD values
data_bad0= data[data$BAD == 0,]
data_bad1= data[data$BAD == 1,]

save_viss= function(data, name){
  t= vis_miss(data, warn_large_data=F)
  ggplot2::ggsave(sprintf("C:/Users/Wenceslas/Desktop/R/R_project/scoring/projecto/scoring_R/images/viss_%s.png", name), t, width= 6, height= 4)
}

vis_miss(data_bad0, warn_large_data= F)
na_col(data_bad0)
save_viss(data_bad0, "bad0")
# Only 10% of NA in DEBTINC

vis_miss(data_bad1, warn_large_data=F)
na_col(data_bad1)
save_viss(data_bad1, "bad1")


# Around 65% of missing values for DEBTINC

# DEBTINC NA are MNAR
# and for others it seems to be MAR

# Missing values percentage per observation

data_new= data
data_new[data["JOB"] == "", "JOB"] = NA
data_new[data["REASON"] == "", "REASON"] = NA

sum(na_row(data_new) > 0.37) # treshhold which eliminates simultaneous DEROG, DELINQ, CLAGE, NINQ and CLNO NA

data_new= data_new[-which(rowMeans(is.na(data_new)) > 0.37), ] 
vis_miss(data_new, warn_large_data= F)
dim(data_new)
save_viss(data_new, "thresh")



# Visualisation of missing values per BAD values into the new dataset
data_bad0= data[data_new$BAD == 0,]
data_bad1= data[data_new$BAD == 1,]

vis_miss(data_bad0, warn_large_data= F)
na_col(data_bad0)

vis_miss(data_bad1, warn_large_data=F)
na_col(data_bad1)


# Barplot the BAD modalities percentage
data_2= data_new
data_2$BAD= factor(data_new$BAD)
g= data_2 %>% 
  group_by(BAD) %>% 
  summarise(Count = n())%>% 
  mutate(percent = prop.table(Count)*100)%>%
  ggplot2::ggplot(ggplot2::aes(reorder(BAD, -percent), percent), fill = BAD)+
  ggplot2::geom_col(fill = c("darkgreen", "darkred"))+
  ggplot2::geom_text(ggplot2::aes(label = sprintf("%.2f%%", percent)), hjust = 0.01,vjust = -0.5, size =3)+ 
  ggplot2::ggtitle("BAD Percent")
print(g)
# The NA deleting session didn't inbalance our classes
