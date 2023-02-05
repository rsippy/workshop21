#############################################
# Week 2, Day 2 Modeling Workshop
# SEIR, Open SEIR 
#############################################

library(deSolve)

##################################################SEIR model
#here is our function to represent a closed SEIR model
seir.model.closed <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    E <- x[2]
    I <- x[3]                               #create local variable I
    R <- x[4]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -beta*S*I
            dE <- beta*S*I-sigma*E
            dI <- sigma*E-gamma*I
            dR <- gamma*I
            dx <- c(dS,dE,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

times <- seq(0,500,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7,sigma=1/7)        
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.closed,params))  #result stored in dataframe

plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR Epidemic, beta=0.3, gamma=1/7, sigma=1/7",
     ylim=c(0,1),xlim=c(0,500))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","E","I","R"),col=c("red","green","blue","gold"))

#why does the plot look like this?
#we didn't observe for a long enough time!
#change the "times" argument from 120 to 500

###############################################open SEIR model
#what do we need to add to make an open SEIR model?
#scenario: add both a birth rate and a death rate
#different rates for births and deaths
#rho=birth rate
#mu=death rate
seir.model.open <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    E <- x[2]
    I <- x[3]                               #create local variable I
    R <- x[4]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- rho*(S+E+I+R)-beta*S*I-mu*S   #we add births to the dS equation
            dE <- beta*S*I-sigma*E-mu*E         #we add our death rates to all
            dI <- sigma*E-gamma*I-mu*I
            dR <- gamma*I-mu*R
            dx <- c(dS,dE,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

times <- seq(0,500,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7,sigma=1/7,rho=1/180,mu=1/200)#we add our parameter values here        
xstart <- c(S=9999/10000,E=0,I=1/10000,R=0)     #initial conditions

out2 <- as.data.frame(lsoda(xstart,times,seir.model.open,params))  #result stored in dataframe

plot(NA,NA,xlab="Time",ylab="Proportion",main="Open SEIR Epidemic, beta=0.3, gamma=1/7, sigma=1/7",
     ylim=c(0,1),xlim=c(0,500))
lines(out2$time,out2$S,col="red",lwd=2)
lines(out2$time,out2$E,col="green",lwd=2)
lines(out2$time,out2$I,col="blue",lwd=2)
lines(out2$time,out2$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","E","I","R"),col=c("red","green","blue","gold"))

#this plot (with more reasonable values for rho and mu) 
#starts to show a new (smaller) outbreak occurring around time 400
#with new births being added, more susceptible people get added and eventually
#enough susceptible people build up that we see a new outbreak
#build-up of susceptibles may explain some epidemic patterns/dynamics we see
#for some diseases


