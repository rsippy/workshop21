# Plot timeseries of covid-19 confirmed cases, deaths and key events
# Yacob Haddou & Katie Hampson - 10 August 2021

#########################################################################

### 1. LOAD LIBRARIES, GET THE DATA

## Load libraries
# devtools::install_github("RamiKrispin/coronavirus")
library(tidyverse)
library(coronavirus); #update_dataset()
library(zoo)
library(ggthemes)
library(lubridate)

## Pull data from John Hopkins repository - using installed package
data("coronavirus")
covid19_df <- refresh_coronavirus_jhu() # Takes time because this is GLOBAL data!

#########################################################################

### 2. PREPARING DATA FOR THE PLOTTING

## Edit dataframe
data <- covid19_df %>%
    filter(location == "Bangladesh") %>% # Select Bangladesh
    # For now the column 'data_type' contains values that can function as variable names, 
    # with 'value' column holding corresponding values
    spread(data_type, value) %>% # Reorganising data
    arrange(date) %>% 
    rename(deaths = deaths_new, cases = cases_new) %>% # rename variables
    # Calculate 7-day rolling means for cases and deaths
    mutate(cases_07 = floor(rollmean(cases, k = 7, fill=NA, align="right")), 
           deaths_07 = floor(rollmean(deaths, k = 7, fill=NA, align="right"))) %>%
    ungroup()

data[is.na(data)] <- 0 # Assign NAs as zeros

# Check the data is ok by looking at the number of dimensions and the first few rows
dim(data) 
head(data)

# Save the up-to-date case and death data (incl.rolling avgs)
fname = paste0(git.path, "outputs/BGD_summary_", Sys.Date(), ".csv") # filename
write.csv(data, fname, row.names = FALSE)

# Fix date range
data <- data %>% filter(date > ymd("2020-01-21")) 

#########################################################################

### 3. PLOTTING

## Use a theme (from ggthemes library) to make plots prettier and standardized:
theme <- theme_clean() + 
    theme(axis.title=element_text(size=15), axis.text=element_text(size=13), 
          legend.text=element_text(size=15), legend.title=element_text(size=15), 
          legend.background = element_rect(color = NA),
          plot.background = element_rect(color = "white"), 
          strip.text=element_text(size=15))

# set up start and end dates for the plots
startdate = ymd("2020-01-01")
enddate = Sys.Date()

# Make progressively more complex plots!

## 1. Plain plot of daily cases 
p1 <- ggplot(data, aes(x=date)) +     
    geom_line(aes(y = cases), color="black") +
    scale_x_date(limits=c(startdate, enddate), date_breaks="2 month", date_labels = "%m/%Y") + 
    labs(x="", y="Cases (7-day avg)") + theme 
p1
# Make a file name... 
fname <- paste0(git.path, "figs/ts1_", Sys.Date(),".png")
# ...and then write to a file
ggsave(p1, file = fname, units = "cm", dpi = "retina", width = 35, height = 20)


## 2. Reduce colour of daily cases and add 7-day rolling mean
p2 <- ggplot(data, aes(x=date)) +     
    geom_line(aes(y = cases), color="black", alpha=0.2) +
    geom_line(aes(y = cases_07), color="black", alpha=1, size=1) +
    scale_x_date(limits=c(startdate, enddate), date_breaks="2 month", date_labels = "%m/%Y") + 
    labs(x="", y="Cases (7-day avg)") + theme 
p2

fname <- paste0(git.path, "figs/ts2_", Sys.Date(),".png")
ggsave(p2, file = fname, units = "cm", dpi = "retina", width = 35, height = 20)


## 3. Add deaths on a new x-axis - THERE ARE A LOT MORE CASES THAN DEATHS!
p3 <- ggplot(data, aes(x=date)) +     
    geom_line(aes(y = cases), color="black", alpha=0.2) +
    geom_line(aes(y = cases_07), color="black", alpha=1, size=1) +
    geom_line(aes(y = deaths), color="darkred", alpha=0.2) +
    geom_line(aes(y = deaths_07), color="darkred", alpha=1, size=1) +  
    scale_x_date(limits=c(startdate, enddate), date_breaks="2 month", date_labels = "%m/%Y") + 
    scale_y_continuous(sec.axis = sec_axis(~ ., name = "Deaths (7-day avg)")) + 
    labs(x="", y="Cases (7-day avg)") + theme 
p3
fname <- paste0(git.path, "figs/ts3_", Sys.Date(),".png")
ggsave(p3, file = fname, units = "cm", dpi = "retina", width = 35, height = 20)


# 4. Adjust the deaths (x30) and re-scale the x-axis for better readability
p4 <- ggplot(data, aes(x=date)) +     
    geom_line(aes(y = cases), color="black", alpha=0.2) +
    geom_line(aes(y = cases_07), color="black", alpha=1, size=1) +
    geom_line(aes(y = deaths*30), color="darkred", alpha=0.2) + # Times 30 for better proportion, 
    geom_line(aes(y = deaths_07*30), color="darkred", alpha=1, size=1) + # Deaths will be on a separate scale  
    scale_x_date(limits=c(startdate, enddate), date_breaks="2 month", date_labels = "%m/%Y") + 
    scale_y_continuous(sec.axis = sec_axis(~ ./30, name = "Deaths (7-day avg)")) + 
    labs(x="", y="Cases (7-day avg)") + theme 
p4
fname <- paste0(git.path, "figs/ts4_", Sys.Date(),".png")
ggsave(p4, file = fname, units = "cm", dpi = "retina", width = 35, height = 20)

# 5. Annotate with useful events!
p5 <- ggplot(data, aes(x=date)) +     
    geom_line(aes(y = cases), color="black", alpha=0.2) +
    geom_line(aes(y = cases_07), color="black", alpha=1, size=1) +
    geom_line(aes(y = deaths*30), color="darkred", alpha=0.2) +
    geom_line(aes(y = deaths_07*30), color="darkred", alpha=1, size=1) +  
    
    geom_segment(aes(x = ymd("2020-03-08"), y = 15000, xend = ymd("2020-03-08"), yend = 0, color="SARS-CoV-2 detected (08/03/2020)"), size=0.6, linetype = "solid") +
    geom_segment(aes(x = ymd("2020-12-31"), y = 15000, xend = ymd("2020-12-31"), yend = 0, color="Alpha detected (31/12/2020)"), size=0.7, linetype = "solid") +
    geom_segment(aes(x = ymd("2021-01-24"), y = 15000, xend = ymd("2021-01-24"), yend = 0, color="Beta detected (24/01/2021)"), size=0.7, linetype = "solid") +
    geom_segment(aes(x = ymd("2021-04-24"), y = 15000, xend = ymd("2021-04-28"), yend = 0, color="Delta detected (28/04/2021)"), size=0.7, linetype = "solid") +
    
    scale_x_date(limits=c(startdate, enddate), date_breaks="2 month", date_labels = "%m/%Y") + 
    scale_y_continuous(sec.axis = sec_axis(~ ./30, name = "Deaths (7-day avg)")) + 
    ggthemes::scale_color_few() + 
    labs(x="", y="Cases (7-day avg)", color="Key events") + theme 
p5

fname <- paste0(git.path, "figs/ts5_", Sys.Date(),".png")
ggsave(p2, file = fname, units = "cm", dpi = "retina", width = 35, height = 20)


