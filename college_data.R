# filtering data for CollegeSearchTool
# Ryan Womack
# ryanwomack.com
# 2024-07-19
# see https://github.com/ryandata/CollegeSearchTool for sources of data and description

# set data to working directory
# setwd("~/womack/documents/ryan/work/shiny/CollegeSearchTool")

# download data
download.file("https://ed-public-download.scorecard.network/downloads/Most-Recent-Cohorts-Institution_05192025.zip", "college_data_raw.zip")

# unzip data
unzip("college_data_raw.zip")

# import data into R

mydata<-read.csv("Most-Recent-Cohorts-Institution_05192025.csv")
library(tidyverse)

# filter for institutions granting bachelors or higher
mydata3<-mydata[mydata$HIGHDEG>=3,]

# for comparison purposes
mydata0<-mydata[mydata$HIGHDEG==0,]
mydata1<-mydata[mydata$HIGHDEG==1,]
mydata2<-mydata[mydata$HIGHDEG==2,]

# filter out for profits
mydata4<-mydata3[{mydata3$SCHTYPE==1 | mydata3$SCHTYPE==2},]

#for comparison 
mydata5<-mydata3[mydata3$SCHTYPE==3,]
mydata6<-mydata3[mydata3$SCHTYPE=="NULL",]

# filter for schools awarding "primarily bachelors degrees"
mydata7 <- mydata4[mydata4$PREDDEG==3,]

#for comparison
mydata8 <- mydata4[mydata4$PREDDEG==1,]
mydata9 <- mydata4[mydata4$PREDDEG==2,]
mydata10 <- mydata4[mydata4$PREDDEG==4,]

# elimate "outlying areas"
mydata11 <- mydata7[mydata7$REGION<=8,]

# screen schools by Carnegie Classification
mydata12 <- 
  mydata11 %>%
  filter(CCBASIC %in% c("15","16","21"))

write.csv(mydata12,file="college_data.csv")

mydata12t<-t(mydata12)
write.csv(mydata12t, file = "college_data_transposed.csv")         
