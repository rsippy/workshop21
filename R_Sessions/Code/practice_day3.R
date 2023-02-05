#############################################
# Week 1, Day 3 Modeling Workshop
# Intro to R, SIR models
#############################################


#random numbers
#R has functions to generate random numbers from many distributions
#normal distribution
norm<-rnorm(10,mean=150,sd=20)
expn<-rexp(20,rate=100)

#generate 100 random numbers from a normal distribution
norm100<-rnorm(100,mean=27,sd=5)
norm1000<-rnorm(1000,mean=27,sd=5)

#make a plot
hist(norm100,main="100 Random Numbers",col="skyblue")
hist(norm1000,main="1000 Random Numbers",col="skyblue")



##########################################################SIR model
library(deSolve)
?lsoda


#creating a function to represent SIR model
#here the function is called "sir.model.closed" and it takes 3 arguments
sir.model.closed <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    I <- x[2]                               #create local variable I
    R <- x[3]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -beta*S*I
            dI <- beta*S*I-gamma*I
            dR <- gamma*I
            dx <- c(dS,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

#R will remember the function and apply it when we call for it
sir.model.closed

#sir model function wanted 3 arguments (t,x,params)
#t is time points/unit
#params are parameters
#x is starting values

#here we will enter some values for the arguments
times <- seq(0,120,by=2)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/12)             #function c "c"ombines values into a vector
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions

#let's run our SIR model function
#we will simulate an epidemic trajectory
#here we save the model output as a dataframe
sir.out <- as.data.frame(lsoda(xstart,times,sir.model.closed,params))  #result stored in dataframe
out

#now we plot the results
op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
par(op)                                                     #re-set graphical parameters
dev.off()

?plot
?distribution
?lines
?legend

#plot all the lines together
plot(NA,NA,xlab="Time",ylab="Proportion",main="SIR Epidemic, beta=0.9, gamma=1/12",
     ylim=c(0,1),xlim=c(0,120))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","I","R"),col=c("red","blue","gold"))

#questions about the epidemic
#what was the maximum proportion infected at once?
max(out$I)
#when did the epidemic peak occur? (maximum infected)
subset(out,out$I==max(out$I))

