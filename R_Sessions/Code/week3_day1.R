#############################################
# Week 3, Day 1 Modeling Workshop
# Adding Stochasticity
#############################################

#load our package
library(deSolve)

#####################################################SEIR vaccination
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

#single value for beta
times <- seq(0,200,by=2)                    #function seq returns a sequence
params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.85) #set alpha to 1 (normal transmission)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

#plotting the results
plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR with Vaccination, beta=2, gamma=1/10, sigma=1/3, nu=1/20, ve=0.80",
     ylim=c(0,1),xlim=c(0,200))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$V,col="orange",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","V","E","I","R"),col=c("red","orange","green","blue","gold"))





#for loop, to run set of simulations/runs
#how many simulations?
n_sim<-50

#what distribution of beta?
sample_beta_values <- rexp(n_sim,1.5)

hist(sample_beta_values,main="Distribution of Beta")

#empty matrix to store the output
#note the dimensions + names must match the dimensions of the model output!
#we also add a column for simulation number and beta
sveir_output_var_beta <- matrix(NA,ncol=8)
colnames(sveir_output_var_beta) = c("time","S","V","E","I","R","sim_num","beta")

#set of parameters (without beta)
params <- c(gamma=1/10,sigma=1/3,nu=1/20,ve=0.85) #set alpha to 1 (normal transmission)       


for(ii in 1:n_sim){
    tmp_params = c(beta=sample_beta_values[ii], params)
    output <- lsoda(xstart,times,seir.model.vac,tmp_params)
    output <- cbind(output, sim_num = ii, beta=sample_beta_values[ii])
    sveir_output_var_beta <- rbind(sveir_output_var_beta, output)
}

#cleaner output as data.frame
sveir_output_var_beta <- as.data.frame(sveir_output_var_beta[-1,])
#what does the output look like?
head(sveir_output_var_beta)
tail(sveir_output_var_beta)

#plot
plot(NA,NA,xlab="Time",ylab="Proportion",main="SEIR with Vaccination, Varying beta",
     ylim=c(0,1),xlim=c(0,200))
for(ii in 1:n_sim){
    lines(sveir_output_var_beta$time[sveir_output_var_beta$sim_num==ii],sveir_output_var_beta$I[sveir_output_var_beta$sim_num==ii],col="blue")
}

################################################SEIR with N, output as number of people
seir.n.vac <- function (t, x, params) {    #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    V <- x[2]                               #local variable V
    E <- x[3]
    I <- x[4]                               #create local variable I
    R <- x[5]                               #create local variable R
        with(                                   #we can simplify code using "with"
        as.list(params),                   #this argument to "with" lets us use the variable names
        {                                  #the system of rate equations
            dS <- -beta*S*I/N-nu*S
            dV <- nu*S-beta*(1-ve)*V*I/N
            dE <- beta*S*I/N+beta*(1-ve)*V*I/N-sigma*E
            dI <- sigma*E-gamma*I
            dR <- gamma*I
            dx <- c(dS,dV,dE,dI,dR)          #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}

N<-10000
times <- seq(0,200,by=2)                    #function seq returns a sequence
params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.85) #set alpha to 1 (normal transmission)       
xstart <- c(S=9999,V=0,E=0,I=1,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.n.vac,params))  #result stored in dataframe

#plotting the results
plot(NA,NA,xlab="Time",ylab="Number of People",main="SEIR with Vaccination, beta=2, gamma=1/10, sigma=1/3, nu=1/20, ve=0.80",
     ylim=c(0,N),xlim=c(0,200))
lines(out$time,out$S,col="red",lwd=2)
lines(out$time,out$V,col="orange",lwd=2)
lines(out$time,out$E,col="green",lwd=2)
lines(out$time,out$I,col="blue",lwd=2)
lines(out$time,out$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","V","E","I","R"),col=c("red","orange","green","blue","gold"))

#total number infected
max(out$R)
