#############################################
# Week 3, Day 2 Modeling Workshop
# Fitting Curves - Estimates from Models
#############################################

#we are going to fit a model to another model, and then to data
#we need to set up some functions first!

#####################################################stochastic SIR

#here we have a function that creates a stochastic SIR
#it takes 6 arguments
#this is different than the functions we have used in past classes
#some of the parameters are now included as arguments in the function
#and in previous classes they were outside of the function
#both types work fine!
#the beta and gamma parameters are included
#initial_cond is the number of people in each compartment at the start
#max_time is the amount of time we will run the model for
#time_step is the units of time
#freq_dependent is an option that gives results in number of people 
#instead of proportions

#because this model stores the model results at each time step
#within the model function, the model can make changes at each time
#step  - this is called a discrete time model
#the model function also has to use a loop to work through the vlues
#here we are using this set up to apply a distribution (stochasticity)
#at each step to determine if people get infected or recover
#this is how the stochasticity is represented in the model
run_sir_model_stochastic <- function(beta, gamma, initial_cond, max_time, time_step, 
                                     freq_dependent){
    
    # setting up times vector + number of time steps
    times = seq(0, max_time, time_step)
    nsteps = length(times)
    
    # setting up storage objects for each class
    # this is where the model stores results from each time step
    # populating objects with the initial conditions (0 for incidence)
    S <- rep(NA, nsteps); S[1] = initial_cond['S']
    I <- rep(NA, nsteps); I[1] = initial_cond['I']
    R <- rep(NA, nsteps); R[1] = initial_cond['R']
    incidI <- rep(NA, nsteps); incidI[1] = 0
    N = S[1] + I[1] + R[1] 
    
    # divide beta by N if frequency dependent; otherwise divide by 1
    # this adds an 'N' to allow the results to be number of people
    beta_divisor <- ifelse(freq_dependent == TRUE, N, 1)
    
    # looping across all time steps except t=0
    for(ii in 2:nsteps){
        
        #here is where stochasticity is included
        # calculating per-person probability of infection, where rate = beta*I*dt
        pr_new_inf = 1 - exp(-time_step*beta/beta_divisor*I[ii-1])
        
        # calculating per-person probability of recovery, where rate = gamma*dt
        pr_new_rec = 1 - exp(-time_step*gamma)
        
        # randomly drawing actual number of infections + recoveries from 
        # calculated probabilities
        new_inf = rbinom(1, S[ii-1], pr_new_inf)
        new_rec = rbinom(1, I[ii-1], pr_new_rec)
        
        # updating classes: 
        # removing infections from S
        S[ii] = S[(ii-1)] - new_inf
        
        # adding infections, removing recoveries from I
        I[ii] = I[(ii-1)] + new_inf - new_rec
        
        # adding recoveries to R
        R[ii] = R[(ii-1)] + new_rec
        
        # tracking new infections in incidI
        incidI[ii] = new_inf
    }
    
    # creating output object
    out <- data.frame(cbind(times, S, I, R, incidI))
    
    return(out)
}

#here we run the stochastic model with the specified conditions:
epidemic1 <- run_sir_model_stochastic(beta=0.5, gamma=0.2, 
                                      initial_cond=c(S=2999, I=1, R=0), 
                                      max_time=90, time_step=0.25, freq_dependent=TRUE)

N = epidemic1$S[1] + epidemic1$I[1] + epidemic1$R[1] ## total population size

#here is a plot of all the compartments over time

plot(NA,NA,xlim=c(0,max(epidemic1$times)),ylim=c(0,N),xlab='Time',ylab='Number of People')
lines(epidemic1$time, epidemic1$S, col = 'blue', lty = 1)
lines(epidemic1$time, epidemic1$I, col = 'red', lty = 1)
lines(epidemic1$time, epidemic1$R, col = 'orange', lty = 1)
legend('topright', legend = c('S', 'I', 'R'), col = c('blue', 'red', 'orange'), pch = 16)
#it looks very similar to the plots we've made in the past except
#now there is noise

#we can count the number of new cases each day, which is the same
#as the number of people who leave the S class each day
#here we use a function called diff() to do this
tmp <- -diff(epidemic1[,"S"])
incidence1 <- cbind(epidemic1[,"times"], c(0,tmp))

#here is a plot of the incidence, where the noise is much more apparent
plot(incidence1, type="l", col="red", lwd=2, xlab="Time",
     ylab="Daily Incidence")

#because there is randomness included when we run a stochastic model, 
#we will get a different result every time we run the model, 
#even though the parameters haven't changed
#this illustrates the randomness of infections in real life
#here we run the stochastic model two more times
epidemic2 <- run_sir_model_stochastic(beta=0.5, gamma=0.2, 
                                      initial_cond=c(S=2999, I=1, R=0), 
                                      max_time=90, time_step=0.25, freq_dependent=TRUE)

epidemic3 <- run_sir_model_stochastic(beta=0.5, gamma=0.2, 
                                      initial_cond=c(S=2999, I=1, R=0), 
                                      max_time=90, time_step=0.25, freq_dependent=TRUE)

#and calculate the incidence for these two times
incidence2 <- cbind(epidemic2[,"times"], c(0,-diff(epidemic2[,"S"])))
incidence3 <- cbind(epidemic3[,"times"], c(0,-diff(epidemic3[,"S"])))

#here is a discrete sir model, set up in the same way as the
#function above (a discrete time model)
#again there are more arguments and the results of each time step
#are included in the model function
run_sir_model_discrete <- function(beta, gamma, initial_cond, max_time, time_step,
                                   freq_dependent){
    
    # setting up times vector + number of time steps
    times = seq(0, max_time, time_step)
    nsteps = length(times)
    
    # setting up storage objects for each class
    # populating objects with the initial conditions (0 for incidence)
    S <- rep(NA, nsteps); S[1] = initial_cond['S']
    I <- rep(NA, nsteps); I[1] = initial_cond['I']
    R <- rep(NA, nsteps); R[1] = initial_cond['R']
    incidI <- rep(NA, nsteps); incidI[1] = 0
    N = S[1] + I[1] + R[1] # population size
    
    # divide beta by N if frequency dependent; otherwise divide by 1
    beta_divisor <- ifelse(freq_dependent == TRUE, N, 1)
    
    # looping across all time steps except t=0
    for(ii in 2:nsteps){
        
        #there is no stochasticity here; the number infected
        #or recovered at each step is simply based on beta and gamma
        # calculating new infections in time step: beta*S*I*dt
        new_inf = time_step*beta/beta_divisor*S[ii-1]*I[ii-1]
        
        # calculating new recoveries in time step: gamma*I*dt
        new_rec = time_step*gamma*I[ii-1]
        
        # updating classes: 
        # removing infections from S
        S[ii] = S[(ii-1)] - new_inf
        
        # adding infections, removing recoveries from I
        I[ii] = I[(ii-1)] + new_inf - new_rec
        
        # adding recoveries to R
        R[ii] = R[(ii-1)] + new_rec
        
        # tracking new infections in incidI
        incidI[ii] = new_inf
    }
    
    # creating output object
    out <- data.frame(cbind(times, S, I, R, incidI))
    
    return(out)
}

#here we run the deterministic SIR model with the same starting 
#parameters as the stochastic model
epidemic1d<- run_sir_model_discrete(beta=0.5, gamma=0.2,initial_cond=c(S=2999,I=1,R=0),
                                    time_step=0.25, freq_dependent=TRUE, 
                                    max_time=max(epidemic1[,"times"]))

#we calculate incidence (number of new cases/day)
incidence1d <- cbind(epidemic1d[,"times"], c(0,-diff(epidemic1d[,"S"])))

#make a plot with the incidence from the three runs of
#the stochastic model and the deterministic model
plot(incidence1, type="l", col="red", lwd=2, xlab="Time",ylab="Daily Incidence")
lines(incidence1d, col="blue", lwd=2)
lines(incidence2, col="green")
lines(incidence3, col="purple")

#why do these plots look so different?


#it would be nice if we could have a deterministic model that 
#aligns with the stochastic model
#we can use a statistical goodness of fit metric: mean squared error (MSE)
#function to minimize MSE between deterministic model & stochastic model
my.err <- function(params, incidence.data) {
    
    epidemic.d<- run_sir_model_discrete(beta=params[1], gamma=params[2], 
                                        initial_cond = c(S=2999,I=1,R=0), 
                                        time_step=0.25,freq_dependent=TRUE, 
                                        max_time = max(incidence.data[,1]))
    
    incidence.d <- cbind(epidemic.d[,"times"], c(0,-diff(epidemic.d[,"S"])))
    
    err <- mean((incidence.d[,2] - incidence.data[,2])^2)
    
    return(err)
}

#now we use the optimize function to find the parameters that would
#create the best fitting model for the stochastic model data (incidence1)
fit <- optim(c(1,.5), my.err, incidence.data=incidence1)
#what are those parameter values?
print(fit)

#let's run the deterministic model again and tell it to use the
#optimized parameter values
epidemicFit<- run_sir_model_discrete(beta=fit$par[1], gamma=fit$par[2], 
                                     initial_cond = c(S=2999,I=1,R=0), 
                                     time_step=0.25,freq_dependent=TRUE, 
                                     max_time = max(epidemic1[,"times"]))
#caluculate the incidence from the optimized model
incidenceFit <- cbind(epidemicFit[,"times"], c(0,-diff(epidemicFit[,"S"])))

#and here is a plot of the stochastic incidence and the 
#incidence from the optimized model
plot(incidence1, type="l", col="red", lwd=2, xlab="Time",ylab="Daily Incidence")
lines(incidenceFit, col="blue", lwd=2)


######################################################Bangladesh data
#we can do the same thing with real data
#let's load some daily case counts for COVID-19 cases
casesAll <- read.csv('daily_cases_20210809.csv')

# lets extract the data for Bangladesh
casesB <- as.numeric(deathsAll[deathsAll$Country.Region=='Bangladesh',5:ncol(casesAll)])

# and look at the data: these are the cumulative number of reported cases
dates <- seq.Date(from=as.Date('2020/01/22'), to=as.Date('2021/08/08'), by=1)

#here is a plot of the cases
plot(dates, casesB, xlab="Time",ylab="Cumulative Cases")

#let's put the case totals with their date in a dataframe
dat<-data.frame(date=dates,cases=casesB)

#now we add a new variable to count the number of new daily cases (incidence)
dat$new<-c(0,diff(dat$cases))
#we add a variable to count time
dat$times<-seq(1,nrow(dat))

#now we can plot the incidence
plot(dat$date,dat$new,type='l',xlab="Time",ylab="Daily Incidence")

#the full pandemic shows some complexity with waves occurring 
#over time
#let's just take the first 300 days
incidenceB<-dat[1:300,c(4,3)]

#here is the beginning of the pandemic
plot(incidenceB)

#we modify the error function a little 
my.errB <- function(params, incidence.data) {
    
    epidemic.d<- run_sir_model_discrete(beta=params[1], gamma=params[2], 
                                        initial_cond = c(S=160000000,I=1,R=0), 
                                        time_step=1,freq_dependent=TRUE, 
                                        max_time = max(incidence.data[,1]))
    
    incidence.d <- cbind(epidemic.d[,"times"], c(0,-diff(epidemic.d[,"S"])))
    
    err <- mean((incidence.d[,2] - incidence.data[,2])^2)

    return(err)
}

#here we optimize the fit for a deterministic SIR model
fitB <- optim(c(1,1), my.errB, incidence.data=incidenceB)
print(fitB)

#we run a model using the optimized parameter values
epidemicFitB<- run_sir_model_discrete(beta=fitB$par[1], gamma=fitB$par[2], 
                                      initial_cond = c(S=160000000,I=1,R=0), 
                                      time_step=1,freq_dependent=TRUE,
                                      max_time=500)

#we calculate the incidence from that optimized model
incidenceFitB <- cbind(epidemicFitB[,"times"], c(0,-diff(epidemicFitB[,"S"])))

#we can look at the incidence from the real data and from the model
plot(incidenceB,type="l", col="red", lwd=2)
lines(incidenceFitB, col="blue", lwd=2)

#the model is doing its best, but why is it having a hard time 
#fitting the data?
