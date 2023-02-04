#############################################
# Week 1, Day 1 Modeling Workshop
# Intro to R
#############################################

#install the package
#you must install the package the first time you 
#want to use it
install.packages("colorist")
install.packages("RColorBrewer")

#then you must load the package
#load package/libraries
library(RColorBrewer)

#basic math calculations
#R objects are created by placing a name then an arrow <- 
#then defining the object
#here we have an object named "a" and it is defined as "5 + 29"
varu<-55
a<- 5 + 29
10+47*8


#R will remember what "a" is and return its value if we type "a"
#R objects can be single values, multiple values (vector), 
#a matrix (rows and columns of numbers), an array (3D matrix, a list,
#or a dataframe (rows and columns of mixed data types)
#here we have a vector of numeric data called "b"
b<-c(3,5,1,7,4,2,2.5,8,11,0,6,4.5,2)

#R already knows:
pi #certain numbers
log(10) #mathematical functions
sin(10)
cos(10)
exp(10)

log(b)

seq(1:10)#sequence
rep(4,7)#repeat
?rep()

rep(times=10,6)

#R knows some functions
#you can perform functions on objects
mean(b)
median(b)
min(b)
max(b)
sd(b)

min(log(b))

############################################################################

#learn about your data
summary(b)
class(b)
str(b)
head(b)



###############################################################################
#loading your datasets- R files
load("rdata.RData")

#looking at the first 6 lines of your data
head(rdata)

#looking at the last 6 lines of your data
tail(rdata)

#looking at the structure of your data (what type of variables are they?)
str(rdata)

#what are the different variable types of R?
#numeric: any real number, can have infinite decimal places
#integer: any whole number
#logic: true or false, R recognizes true and false values
T #true
TRUE #true
F #false
FALSE #false
#character
#any string of characters, can have punctuation or spaces
#NA represents a missing value, can exist in any variable type
#factors 
#categorical, can have levels or not
#must specify the levels, otherwise R puts them in alphabetical order
#date
#year-month-day, year/month/day format is default for R to recognize
#can change to other formats

#open csv file
#can click on file and choose "import" option or type code below
#all functions have options 
#here we read in the rdata CSV file, and we use options to specify that
#the data have variable names (header), any values of NA or blanks should 
#be NA, and to treat character strings as characters (not factors)
rdata2<-read.csv("rdata.csv",header=TRUE,na=c(NA,""),
                 stringsAsFactors=FALSE)


#imported data will sometimes create errors or loss of information that must
#be corrected!
#fix our variables
#we create a new variable called "newdate" with a correct date format
rdata2$newdate<-as.Date(rdata2$dte)

#haven package can be used to read in SPSS files!
library(haven)
