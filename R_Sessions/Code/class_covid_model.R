#########################
# Live Code from Class
# Week 3, Day 2
#########################

#can we vary the timing of vaccination start?


library(deSolve)

#starting a vaccination later on in the epidemic

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

#start vaccination at day 50
#vaccination rate (nu)
#day 0-49: nu=0
#day 50-200: nu=1/20
nus<-c(rep(0,50),rep(1/20,150))

times <- seq(0,200,by=1)                    #function seq returns a sequence
params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=0,ve=0.85)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

out <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

times50<-seq(0,20,by=1)
params50 <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=0,ve=0.85)       
xstart50 <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

out50 <- as.data.frame(lsoda(xstart50,times50,seir.model.vac,params50))  #result stored in dataframe

times150<-seq(21,190,by=1)
params150 <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.85)       
#where are we in SEIR?
tail(out50)
xstart150<-as.numeric(out150[21,2:6])     #initial conditions

out150 <- as.data.frame(lsoda(xstart150,times150,seir.model.vac,params150))  #result stored in dataframe
colnames(out150)[2:6]<-c("S","V","E","I","R")

times <- seq(0,200,by=1)                    #function seq returns a sequence
params <- c(beta=1.5,gamma=1/10,sigma=1/3,nu=1/20,ve=0.85)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

outv <- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

plot(out50$time,out50$I,xlim=c(0,200),ylim=c(0,1),type='l')
lines(out150$time,out150$I,col=2)
lines(out150$time,out150$V,col=3)
lines(out150$time,out150$S,col=4)
lines(out150$time,out150$R,col=5)
lines(out$time,out$I)
lines(outv$time,outv$I,col=2,lty=2)

#########################################################COVID-19 values
#latent period 6d
#infectious period 6d
#R0: 2.5
beta<-R0/(gamma)
beta<-2.5/(1/6)

times <- seq(0,200,by=1)                    #function seq returns a sequence
params <- c(beta=7.5,gamma=1/6,sigma=1/6,nu=0,ve=0.85)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

outcov<- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

plot(outcov$time,outcov$S,xlim=c(0,200),ylim=c(0,1),type='l')
lines(outcov$time,outcov$V,col=2)
lines(outcov$time,outcov$E,col=3)
lines(outcov$time,outcov$I,col=4)
lines(outcov$time,outcov$R,col=5)

times <- seq(0,200,by=1)                    #function seq returns a sequence
params <- c(beta=7.5,gamma=1/6,sigma=1/6,nu=1/5,ve=0.95)       
xstart <- c(S=9999/10000,V=0,E=0,I=1/10000,R=0)     #initial conditions

outcv<- as.data.frame(lsoda(xstart,times,seir.model.vac,params))  #result stored in dataframe

plot(outcv$time,outcv$S,xlim=c(0,200),ylim=c(0,1),type='l')
lines(outcv$time,outcv$V,col=2)
lines(outcv$time,outcv$E,col=3)
lines(outcv$time,outcv$I,col=4)
lines(outcv$time,outcv$R,col=5)

