#----- Megan O'Driscoll
#----- email: mo487@cam.ac.uk

####################################################
##===== Mini tutorial on delay distributions =====##
####################################################




# lets clear our environment first
rm(list=ls())

# read in death time series data from Johns Hopkins dashboard
setwd('') # set your working directory to where the data are stored
deathsAll <- read.csv('time_series_covid19_deaths_global.csv')

# lets extract the data for Bangladesh
deathsB <- as.numeric(deathsAll[deathsAll$Country.Region=='Bangladesh',5:ncol(deathsAll)])

# and look at the data
dates <- seq.Date(from=as.Date('2020/01/22'), to=as.Date('2021/08/07'), by=1)
plot(dates, deathsB)


# lets transform the cumulative data to daily counts
dailydeathsB <- vector()
for(i in 2:length(deathsB)){    # here we are looping through each day to calculate the newly reported deaths per day
  dailydeathsB[i] <- deathsB[i] - deathsB[i-1]
}
dailydeathsB[is.na(dailydeathsB)] <- 0
dailydeathsB<-dailydeathsB*1.5


# now plot the daily time series
plot(dates, dailydeathsB, type='l')




#==== Now that we have our data ready we can create our first delay distribution! ====#

# we are going to use gamma distributions
# these are commonly parameterized in terms of their shape and scale
# where the shape = (mean / standard devation)^2    
# and the rate = mean / standard deviation^2


# first lets define a delay between onset and death
# we will set a mean (mu) of 20 days
# and a standard deviation (sd) of 10 days
mu <- 20
sd <- 10
onset_death <- rgamma(10000, shape=(mu/sd)^2, rate=mu/sd^2) # randomly draw 10,000 samples from our distribution

# lets plot the distribution
hist(onset_death, breaks=50)
hist(onset_death)
?hist

# now lets define a delay between infection and onset
# with a mean (mu2) of 6.5 days
# and standard deviation (sd2) of 2.6 days
mu2 <- 6.5
sd2 <- 2.6
infection_onset <- rgamma(10000, shape=(mu2/sd2)^2, rate=mu2/(sd2^2))

# and plot the distribution
hist(infection_onset, breaks=50)


# adding these 2 distributions together will give us delays between infection and death
infection_death <- infection_onset + onset_death
hist(infection_death, breaks=50)

# the mean of our new distribution should be somewhere around 26 days (mu + mu2 = 26.5)
mean(infection_death) #26 days

# what does this show us?
# this means we think that, on average, most people who die were infected ~26 days ago
# therefore the probability density of this distribution is highest at about 26 days
# but delays of 10 days or 30 days are also very possible
# and delays of 1 day or 80 days are possible too, but much much less likely!





#==== Now lets take our reported death data and distribute it backwards to timing of infection ====#

# create a vector for the timing of infections
t_infections <- rep(0,length(dailydeathsB))


for(i in 1:length(dailydeathsB)){ # loop through each day
  
  if(dailydeathsB[i]>0){ # if any deaths are reported
    
    for(d in 1:dailydeathsB[i]){ # for each reported death on day i
      
      delay <- sample(infection_death, 1) # draw a random sample from the delay distribution
      
      if((i-delay)<1){ # if the delay is before the start of our time series add the timing to day1
        t_infections[1] <- t_infections[1] + 1 
      }else{ # otherwise we add 1 to the estimated time of infection
        t_infections[i-delay] <- t_infections[i-delay] + 1
      }
    }
  }
}

# lets plot and compare the 2 time series (beware we need to be very careful when we interpret this!)
plot(dates, dailydeathsB, type='l')
lines(dates, t_infections, col='red')
      
# we now have a time series of daily deaths shifted backwards to inferred time of infection (shown in red)
# however, you might notice a difference in the 2 lines at the end of the time series
# this is because we can't see any future deaths from the people infected most recently 
# we should therefore remove these inaccurate segments of the time series


# lets remove the most recent 60 days and plot again
t_infections[(length(t_infections)-60):length(t_infections)] <- NA
plot(dates, dailydeathsB, type='l')
lines(dates, t_infections, col='red') # much more sensible!





#==== If we have time, lets now use the IFR to infer the number of infections from the number of deaths =====#


# lets make an assumption for the infection fatality ratio (IFR), maybe 0.8% = 0.008 as for many countries
IFR <- 0.008 
IFR <- 0.003 #bangladesh is young, maybe IFR is much lower


# create a vector for the timing and number of infections
N_infections <- rep(0,length(dailydeathsB))


# we will use the exact same loop as before but now we are accounting for the ratio of deaths to infections

for(i in 1:length(dailydeathsB)){ # loop through each day
  
  if(dailydeathsB[i]>0){ # if any deaths are reported
    
    for(d in 1:dailydeathsB[i]){ # for each reported death on day i
      
      delay <- sample(infection_death, 1) # draw a random sample from the delay distribution
      
      if((i-delay)<1){ # if the delay is before the start of our time series add the timing to day1
        N_infections[1] <- N_infections[1] + (1/IFR) 
      }else{ # otherwise we add 1 to the estimated time of infection
        N_infections[i-delay] <- N_infections[i-delay] + (1/IFR)
      }
    }
  }
}

# lets remove the most recent 60 days again due to unobserved future deaths and plot
N_infections[(length(N_infections)-60):length(N_infections)] <- NA
plot(dates, N_infections, type='l', col='purple')


# for this value of the IFR how many would be infected by 8th June 2021?
sum(N_infections, na.rm=TRUE) #1,917,625
#under-reported deaths 2,864,000
#actual reported infections 1.3 million

# what does this say about the proportion of the population infected?

# population of Bangladesh
pop <- 163000000

# Percentage infected by 8th June 2021 under the above assumptions
(sum(N_infections, na.rm=T)/pop) * 100 #1.17%
#1.75% infected when underreporting deaths

# feel free at this point to go back and change the values of IFR, mu, sd, mu2 and sd2 
# to see how the time series and number of infections changes with these parameters

#reporting rate - seems high!
1350000/(sum(N_infections, na.rm=T)) * 100 #94%
