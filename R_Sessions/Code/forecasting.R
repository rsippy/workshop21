############################
#Time Series & Forecasting
#Practice session day
#5 July 2022
############################

library(forecast)
library(tidyverse)
library(surveillance)
library(slider)
library(feasts)
#library(tsibble)

####################################load the data
#case data, renamed as data.weekly
load("data_weekly_a2i.rda"); names(data.weekly)

dhaka.weekly<-filter(data.weekly,district == "Dhaka")
head(dhaka.weekly)

####################################basic plot
ggplot(dhaka.weekly, aes(x=date)) +     
    geom_line(aes(y = cases), color="black") +
    scale_x_date(date_breaks="2 month", date_labels = "%m/%Y") + 
    labs(x="", y="Cases") + 
    theme_classic()

########add number of tests
ggplot(dhaka.weekly, aes(x=date)) +     
    geom_line(aes(y = cases), color="black", size=1) +
    geom_line(aes(y = tests), color="red", alpha=1, size=1) +  
    scale_x_date(date_breaks="2 month", date_labels = "%m/%Y") + 
    labs(x="", y="Cases") + 
    theme_classic()

#moving average (smooth)
dhaka.weekly<-dhaka.weekly %>%
    arrange(date) %>%
    mutate(ma_4wk = slider::slide_dbl(cases,
                                      ~mean(.x,na.rm=TRUE),
                                      .before = 4))

ggplot(dhaka.weekly,aes(x=date)) +     
    geom_line(aes(y = cases), color="black") +
    geom_line(aes(y = ma_4wk), color="blue") +       
    scale_x_date(date_breaks="2 month", date_labels = "%m/%Y") + 
    labs(x="", y="Cases") + 
    theme_classic()

#############time series objects
data.ts<-ts(dhaka.weekly$cases,start=2020,
            end=c(2021,34),frequency = 52)
data.ts

#############time series plots
#handles ts data, use in a similar way to ggplot
autoplot(data.ts) +
    ggtitle("Weekly COVID-19 Cases")

#look at how individual years behave
ggseasonplot(data.ts,year.labels = TRUE, year.labels.left = TRUE) +
    ggtitle("Weekly COVID-19 Cases")

#looking for patterns in lags
gglagplot(data.ts)

#autocorrelation plot
acf(data.ts)

#####################################campylobacter
data("campyDE")

campy.ts<-ts(campyDE$case,start=c(2001,52),
             frequency = 52)

#handles ts data, use in a similar way to ggplot
autoplot(campy.ts) +
    ggtitle("Weekly Campylobacter Cases")

#look at how individual years behave
ggseasonplot(campy.ts,year.labels = TRUE, year.labels.left = TRUE) +
    ggtitle("Weekly Campylobacter Cases")

#looking for patterns in lags
gglagplot(campy.ts)

#autocorrelation plot
acf(campy.ts)

##relationship with humidity?
ggplot(campyDE, aes(x=date,y=case)) +
    geom_line() +
    xlab("Time") + ylab("") +
    ggtitle("Campylobacter")

ggplot(campyDE, aes(x=date,y=hum)) +
    geom_line() +
    xlab("Time") + ylab("") +
    ggtitle("Humidity")

#scatterplot 
qplot(hum, case, data=campyDE) +
    ylab("Cases") + xlab("Humidity (%)")

#how correlated? 0.75 (strong)
cor(campyDE$case[1:521], campyDE$hum[1:521])

##########################forecasts
autoplot(campy.ts) +
    autolayer(meanf(campy.ts, h=26),
              series="Mean", PI=FALSE) +
    ggtitle("Forecasts for Campylobacter Cases") +
    xlab("Year") + ylab("Cases") +
    guides(colour=guide_legend(title="Forecast"))

##forecast with prediction interval
autoplot(meanf(campy.ts))

####examine the residuals
res.m <- residuals(meanf(campy.ts))

autoplot(res.m) + xlab("Week") + ylab("") +
    ggtitle("Residuals from Mean Method")

acf(res.m)

######many forecasts at once
autoplot(campy.ts) +
    autolayer(meanf(campy.ts, h=26),
              series="Mean", PI=FALSE) +
    autolayer(naive(campy.ts, h=26),
              series="Naïve", PI=FALSE) +
    autolayer(snaive(campy.ts, h=26),
              series="Seasonal naïve", PI=FALSE) +
    ggtitle("Forecasts for Campylobacter Cases") +
    xlab("Year") + ylab("Cases") +
    guides(colour=guide_legend(title="Forecast"))

####examine the residuals
res.sn <- residuals(snaive(campy.ts))

autoplot(res.sn) + xlab("Week") + ylab("") +
    ggtitle("Residuals from Seasonal Naïve Method")

acf(res.sn[53:522])
#there is still some information in the residuals

#prediction intervals
autoplot(snaive(campy.ts)) + 
    xlab("Week") + 
    ylab("") +
    ggtitle("Uncertainty of Seasonal Naïve Method")


##########################decomposition
#tidyverse ts object
#tscamp<-tsibble(counts = campyDE$case, index = campyDE$date)

#tscamp %>% 
    # using an additive classical decomposition model
#    model(classical_decomposition(case, type = "additive")) %>% 
    ## extract the important information from the model
#    components() %>% 
    ## generate a plot 
#    autoplot()