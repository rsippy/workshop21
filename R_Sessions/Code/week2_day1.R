#############################################
# Week 2, Day 1 Modeling Workshop
# Estimating Parameters, Open SIR 
#############################################


##################estimating R0 from the final epidemic size
#first we need to create a function to calculate R0
calc_R0 <- function(r_inf){
    return(-log(1-r_inf)/r_inf) #returns R0 for a given r_inf
}


#let's estimate R0 for an H1N1 influenza outbreak where 
#24% of the total population were infected by the end



#now estimate R0 for an outbreak of measles where 77% 
#of the total population were infected by the end



#sometimes we don't have a precise measure for the total 
#infected, and we must take this uncertainty into account 
#when estimating R0
#rom a serological survey, the proportion of the population 
#infected with measles was 0.65, with a standard deviation 
#of 0.2

#we can create a distribution to represent this variation 
final_size<-rnorm(1000,mean=0.65,sd=0.2)

#we have to limit these values between 0 and 1, since 
#they represent a proportion
final_size<-subset(final_size,final_size>=0 & final_size<=1)

#we can run our R0 function on this range


#create a histogram of the resulting R0 values




#########################estimate final epidemic size from R0
#remember this is a special type of equation because the 
#final epidemic size ends up on both sides of the equation, 
#and must be solved iteratively
#we want both sides of the equation to be equal 
objective_function <- function(r_inf, R0){
    right_side <- 1 - exp(-R0*r_inf)
    left_side <- r_inf
    return(abs(right_side - left_side))
}

#iterative solutions mean we just test a lot of values to 
#find one that's close 
#let's say that our epidemic had an R0=1.1
#input three test values of final size (proportions)
r_inf_test_1 = 
r_inf_test_2 = 
r_inf_test_3 = 

#my fixed R0 = 1.1
fixed_R0 = 1.1

#how close is our test value of r_infty? are both sides 
#equal with any of these test values? which test value is 
#the closest?
objective_function(r_inf_test_1, fixed_R0)

#we can actually test many values for r_inf with a single 
#function in R called:
?optimize
#is the default option to maximize or minimize the function?
#which do we want?

optimize(f=objective_function,interval=c(0,1),R0=1.1)







###############################################open SIR model
library(deSolve)

#here is a function to represent an open SIR model
#it is called "sir.model.open" and it takes 3 arguments

sir.model.open <- function (t, x, params) { #here we begin a function with three arguments
    S <- x[1]                               #create local variable S, the first element of x
    I <- x[2]                               #create local variable I
    R <- x[3]                               #create local variable R
    with(                                   #we can simplify code using "with"
        as.list(params),                    #this argument to "with" lets us use the variable names
        {                                   #the system of rate equations
            dS <- mu*(S+I+R)-beta*S*I-mu*S
            dI <- beta*S*I-gamma*I-mu*I
            dR <- gamma*I-mu*R
            dx <- c(dS,dI,dR)                #combine results into a single vector dx
            list(dx)                         #return result as a list
        }
    )
}
#R will remember the function and apply it when we call it
sir.model.open

#sir model function wants 3 arguments (t,x,params)
#t is time points/units
#params are parameters
#x is starting values

#this model is identical to our closed model, except we
#have added a parameter to represent births and deaths
#this parameter is called "mu"
times <- seq(0,120,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7,mu=1/365)    #1 birth/yr, 1 death/yr    
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions

#we run our SIR model function
#we will simulate an epidemic trajectory
#here we save the model output as a dataframe
out <- as.data.frame(lsoda(xstart,times,sir.model.open,params))  #result stored in dataframe

#this plot shows the infecteds and the phase plot for S & I
op <- par(fig=c(0,0.5,0,1),mar=c(4,4,1,1))                  #set graphical parameters
plot(I~time,data=out,type='b')                              #plot the I variable against time
par(fig=c(0.5,1,0,1),mar=c(4,1,1,1),new=T)                  #re-set graphical parameters
plot(I~S,data=out,type='b',yaxt='n',xlab='S')               #plot phase portrait
par(op) 
dev.off()

#let's look at all the compartments
#plot all the lines together
plot(NA,NA,xlab="Time",ylab="Proportion",main="Open SIR Epidemic, beta=0.3, gamma=1/7, mu=1/365",
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

#what if the birth rate is much higher?
times <- seq(0,120,by=5)                    #function seq returns a sequence
params <- c(beta=0.3,gamma=1/7,mu=1/30)    #1 birth/month, 1 death/month    
xstart <- c(S=9999/10000,I=1/10000,R=0)     #initial conditions

#we run our SIR model function
#we will simulate an epidemic trajectory
#here we save the model output as a dataframe
out2 <- as.data.frame(lsoda(xstart,times,sir.model.open,params))  #result stored in dataframe

#plot all the lines together
plot(NA,NA,xlab="Time",ylab="Proportion",main="Open SIR Epidemic, beta=0.3, gamma=1/7, mu=1/30",
     ylim=c(0,1),xlim=c(0,120))
lines(out2$time,out2$S,col="red",lwd=2)
lines(out2$time,out2$I,col="blue",lwd=2)
lines(out2$time,out2$R,col="gold",lwd=2)
legend("topright",pch=19,c("S","I","R"),col=c("red","blue","gold"))

#what is different between the epidemic dynamics in
#these two situations?

#add the original epidemic lines to compare:
lines(out$time,out$S,col="red",lwd=2,lty=2)
lines(out$time,out$I,col="blue",lwd=2,lty=2)
lines(out$time,out$R,col="gold",lwd=2,lty=2)

