#############################################
# Week 1, Day 2 Modeling Workshop
# Intro to R, part 2
#############################################


#reading other file formats
#haven can read SAS, SPSS, and Stata files
library(haven)

sasfile<-read_sas("myfile.sas7bdat")
spssfile<-read_sav("myfile.sav")
statafile<-read_dta("myfile.dta")

#these will create a "tibble", which can be used like a dataframe or 
#converted to a dataframe
#haven will keep all of the labels and information from the original 
#SAS/Stata/SPSS file
#dates and times are kept, as well as special missing values
spssdata<-data.frame(spssfile)



#getting help for functions/commands
?lm

## Annette Dobson (1990) "An Introduction to Generalized Linear Models".
## Page 9: Plant Weight Data.
ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)
lm.D9 <- lm(weight ~ group)
lm.D90 <- lm(weight ~ group - 1) # omitting intercept

lm.D9
summary(lm.D9)
attributes(lm.D9)


#writing our own functions
#new functions require the word "function" and then some dummy names to 
#represent the number of arguments for the function
#we have a function named "calculation1", with 3 arguments (x,y,z)
calculation1<-function(x,y,z){
    tmp<-x+y
    tmp2<-tmp/z
    return(tmp2)
}

calculation1

#let's use the function!
output1<-calculation1(3,9,10)

output1



#load our data from day 1
rdata<-read.csv("rdata.csv",header=TRUE,na=c(NA,""),stringsAsFactors=FALSE)

#fix our variables
#we create a new variable called "newdate" with a correct date format
rdata$newdate<-as.Date(rdata$dte)

#create another new variable
rdata$gender<-factor(c("M","F","F","M","M","M","F","F","M","F"))

#indexing
#name of dataframe with [rows,column]
rdata[1,6]
rdata

rdata[6,]
rdata[,7]
rdata[3:5,7:8]#colon means range

rdata[c(1,4,7),c(2,5)]#can use vectors to specify rows and columns



#plotting data
load("flu.RData")

?plot

#R has a function called "plot" that can be used for simple graphs
plot(flu$day,flu$cases,type="b",xlab="Day",ylab="Number of New Cases",
     col="red")

#how would we create a line plot?
plot(flu$day,flu$cases,xlab="Day",ylab="Number of New Cases",
     col="blue",main="School Outbreak",lty=2,type="l")

#R has other plotting functions for histograms, boxplots, and barplots
hist(flu$cases)
boxplot(flu$cases,main="Distribution of Case Numbers",col="springgreen2")

#R will only use a barplot with categorical data, so we add day of the week
flu$weekday<-factor(c("Mon","Tues","Weds","Thurs","Fri","Sat","Sun","Mon",
                      "Tues","Weds","Thurs","Fri","Sat","Sun"))

barplot(height=flu$cases,names=flu$weekday)

#464 students at school
#let's calculate the case prevalence for each day
flu$prev<-flu$cases/464

#plotting parameters can be modified to allow for multiple plot panels
#here we allow for 2 rows, 1 column of plot panels
par(mfrow=c(2,1))
plot(flu$day,flu$prev,type="l",main="Influenza Prevalence",
     xlab="Day",ylab="Prevalence",col="blue")
plot(flu$day,flu$cases,type="l",main="Influenza Cases",
     xlab="Day",ylab="Cases",col="red")

#this command turns off any changes you made to the 
#plotting parameters
dev.off()


#plotting rdata
#points() and lines() will add to a plot that already exists
plot(rdata$newdate,rdata$num,col="orange3")
points(rdata$newdate,rdata$int,col="purple")
lines(rdata$newdate,rdata$X,col="goldenrod")

#we can plot by groups/categories
boxplot(rdata$int~rdata$gender,col=rdata$gender,main="Int by Gender")

#colors can be specified as names, a number, or a hexcode
#R knows more than 600 color names
colors()







