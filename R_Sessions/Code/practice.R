#This is my script
#Practice session day 3
#8 June 2022

###################################load clim file
clim<-read.csv("clim.csv",header=TRUE,na=c(NA,""),
                 stringsAsFactors=FALSE)

#################################reading an xls file
install.packages("xlsx")
library(xlsx)

y2014<-read.xlsx("dengue.xlsx",1)#year 2014, 1st sheet
y2015<-read.xlsx("dengue.xlsx",sheetName="2015")#year 2015, 2nd sheet


######################################data wrangling
#remove variable
str(clim)

#indexing
clim[4,7]
clim[4,3:7]

#removing the first column
clim2<-clim[ ,2:7] #keep columns 2-7
str(clim2)

clim3<-clim[ ,-1] #remove column 1
str(clim3)

clim4<-clim[,c(2,3,7)]
str(clim4)













