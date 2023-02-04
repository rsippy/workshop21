#Plots/visualization
#Practice session day 
#30 June 2022

###################################libraries
library(xlsx)
library(tidyverse)
library(RColorBrewer)
library(reshape2)
###################################load clim file
clim<-read.csv("clim.csv",header=TRUE,na=c(NA,""),
               stringsAsFactors=FALSE)

#################################load dengue file
library(xlsx)

y2014<-read.xlsx("dengue.xlsx",1)#year 2014, 1st sheet

#################################first example
data(mpg)

ggplot(data = mpg) +
    geom_point(mapping = aes(x=displ,y=hwy),
               stroke=4) +
    scale_x_continuous(breaks=c(2,3,10)) +
    ggtitle("Car Data") +
    labs(x="Engine Size", y="Fuel Efficiency") +
    theme_classic()

ggplot(data = mpg,mapping = aes(x=displ,y=hwy)) +
    geom_line(color="lightblue",linetype=4,size=2) +
    scale_x_continuous(breaks=c(2,3,4)) +
    ggtitle("Car Data") +
    labs(x="Engine Size", y="Fuel Efficiency") +
    theme_classic()



####################################grouped bar plot
y2014m<-melt(y2014,id.vars=c("Clinic","Visits"))

ggplot(y2014m, aes(fill=Visits, y=value, x=Clinic)) + 
    geom_bar(position="fill", stat="identity")
