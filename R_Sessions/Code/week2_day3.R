#############################################
# Week 2, Day 3 Modeling Workshop
# Modeling Interventions
#############################################

#load our package
library(deSolve)

##################################################SEIR model with txt
#here is our function to represent a closed SEIR model
#where we are treating some infected individuals
seir.model.txt <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    E <- x[2]
    I <- x[3]                               #create local variable I
    R <- x[4]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -beta*S*I
            dE <- beta*S*I-sigma*E
            dI <- sigma*E-(gamma+tau)*I
            dR <- (gamma+tau)*I
            dx <- c(dS,dE,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

times <- seq(0,150,by=5)                    #function seq returns a sequence
params <- c(beta=0.7,gamma=1/4,sigma=1/2,tau=0) #set tau to 0 (no treatment)       
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.txt,params))  #result stored in dataframe

plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR Epidemic, beta=0.7, gamma=1/4, sigma=1/2, tau=0 vs tau=1/4",
     ylim=c(0,1),xlim=c(0,150))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","E","I","R"),col=c("red","green","blue","gold"))

times <- seq(0,150,by=5)                    #function seq returns a sequence
params <- c(beta=0.7,gamma=1/4,sigma=1/2,tau=1/4) #now some are treated       
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out2 <- as.data.frame(lsoda(xstart,times,seir.model.txt,params))  #result stored in dataframe

lines(out2$time,out2$S,col="red",lwd=2,lty=2)
lines(out2$time,out2$E,col="green",lwd=2,lty=2)
lines(out2$time,out2$I,col="blue",lwd=2,lty=2)
lines(out2$time,out2$R,col="gold",lwd=2,lty=2)

#what is the reduction in the total number infected with this treatment?
max(out$R)
max(out2$R)
max(out$R)*10000-max(out2$R)*10000





########################################################social distancing
#here is our function to represent a closed SEIR model
#where we are reducing transmission
seir.model.sd <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    E <- x[2]
    I <- x[3]                               #create local variable I
    R <- x[4]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -alpha*beta*S*I
            dE <- alpha*beta*S*I-sigma*E
            dI <- sigma*E-gamma*I
            dR <- gamma*I
            dx <- c(dS,dE,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

times <- seq(0,150,by=2)                    #function seq returns a sequence
params <- c(beta=0.9,gamma=1/5,sigma=1/3,alpha=1) #set alpha to 1 (normal transmission)       
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.sd,params))  #result stored in dataframe

plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR Epidemic, beta=0.9, gamma=1/5, sigma=1/3, alpha=1 vs alpha=0.75",
     ylim=c(0,1),xlim=c(0,150))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","E","I","R"),col=c("red","green","blue","gold"))

times <- seq(0,150,by=2)                    #function seq returns a sequence
params <- c(beta=0.9,gamma=1/5,sigma=1/3,alpha=0.25) #now contact is reduced      
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out2 <- as.data.frame(lsoda(xstart,times,seir.model.sd,params))  #result stored in dataframe

lines(out2$time,out2$S,col="red",lwd=2,lty=2)
lines(out2$time,out2$E,col="green",lwd=2,lty=2)
lines(out2$time,out2$I,col="blue",lwd=2,lty=2)
lines(out2$time,out2$R,col="gold",lwd=2,lty=2)

#how much would we need to reduce transmission to eliminate the epidemic?#
max(out$R)
max(out2$R)




########################################################vaccination
#here is our function to represent a closed SEIR model
#where we are modeling a vaccinated group of people
#and the vaccine is gives partial immunity
seir.model.vac <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    V <- x[2]                               #local variable V
    E <- x[3]
    I <- x[4]                               #create local variable I
    R <- x[5]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -beta*S*I-nu*S
            dV <- nu*S-beta*(1-ve)*V*I
            dE <- beta*S*I+beta*(1-ve)*V*I-sigma*E
            dI <- sigma*E-gamma*I
            dR <- gamma*I
            dx <- c(dS,dV,dE,dI,dR)          #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

#this requires us to add a new compartment V
#and two new parameters, nu and ve
#nu is the vaccination rate among susceptibles
#ve is the vaccine efficacy
#V are vaccinated people

#what would the diagram for the model look like?



times <- seq(0,200,by=2)                    #function seq returns a sequence
params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.85) #set alpha to 1 (normal transmission)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/10,ve=0.85) #set alpha to 1 (normal transmission)
out2 <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.95) #set alpha to 1 (normal transmission)
out3 <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR with Vaccination, beta=2, gamma=1/10, sigma=1/3, nu=1/20, ve=0.80",
     ylim=c(0,1),xlim=c(0,200))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$V,col="orange",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","V","E","I","R"),col=c("red","orange","green","blue","gold"))

lines(out$time,out3$S,col="red",lwd=2,lty=3)
lines(out$time,out3$V,col="orange",lwd=2,lty=3)
lines(out$time,out3$E,col="green",lwd=2,lty=3)
lines(out$time,out3$I,col="blue",lwd=2,lty=3)
lines(out$time,out3$R,col="gold",lwd=2,lty=3)

#what proportion were infected by the end?
max(out$R)

#what if we increase the vaccination rate?
max(out2$R)

#what if we improve vaccine efficacy?
max(out3$R)

#which would have the bigger impact on reducing total infections?






