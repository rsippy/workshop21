#######################
#Making Maps
#Practice Session Day
#4 July 2022
#######################

library(ggplot2)
library(tidyverse)
library(datasets)
library(RColorBrewer)
library(sf)
library(maps)
library(data.table)
library(viridis)
library(scales)

##################################loading datasets
# simplified shapefile
district.asis <- read_sf("sitrep_workshop/data/simplified_BGD_districts.shp")
head(district.asis)

#shapefile with modifications
district.shp <- read_sf("sitrep_workshop/data/simplified_BGD_districts.shp") %>%
    transmute(district = DISTNAME) %>% # drop vars, change column name
    st_transform(crs=4326)
head(district.shp)

#shapefile with modifications
district.bng <- read_sf("sitrep_workshop/data/simplified_BGD_districts.shp") %>%
    transmute(district = DISTNAME) %>% # drop vars, change column name
    st_transform(crs=3106) # change projection 3106
head(district.bng)

######################################basic map
# plot a basic map of Bangladesh
ggplot(district.shp) + 
    geom_sf() 

#adjust projection?
ggplot(district.bng) + 
    geom_sf() 

####################################joining data
#case data, renamed as data.weekly
load("data_weekly_a2i.rda"); names(data.weekly)

####data prep
#summarize the data
data.year<-data.weekly %>%
    group_by(district) %>%
    summarize(cases_n=sum(cases, na.rm=TRUE))
head(data.year)

#add it to the map
map.yearly <- st_sf(left_join(data.year, 
                              district.shp, 
                              by="district"))
head(map.yearly)

###################################mapping cases
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") 


#let's clean up the labels
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases")

#let's add a theme - remove plot borders, cleaner
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

#lets fix the scale
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    scale_fill_continuous(trans="log") +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

#breaks = legend_scale, labels = labs
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    scale_fill_continuous(trans="log",
                          breaks=c(1,10000,100000,200000,400000,500000),
                          labels=c("1-10K","10K-100K","100K-200K","200K-400K","400K-500K","500K+")) +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

#let's adjust the colors
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    scale_fill_viridis(trans="log",
                          breaks=c(1,10000,100000,200000,400000,500000),
                          labels=c("1-10K","10K-100K","100K-200K","200K-400K","400K-500K","500K+")) +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

#continuous or block legend?
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="black") +
    scale_fill_viridis(trans="log",
                       breaks=c(1,10000,100000,200000,400000,500000),
                       labels=c("1-10K","10K-100K","100K-200K","200K-400K","400K-500K","500K+"),
                       guide=guide_legend()) +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

#fix district outlines 
ggplot(data=map.yearly, aes(fill = cases_n)) +
    geom_sf(color="lightgrey", size=0.1) +
    scale_fill_viridis(trans="log",
                       breaks=c(1,10000,100000,200000,400000,500000),
                       labels=c("1-10K","10K-100K","100K-200K","200K-400K","400K-500K","500K+"),
                       guide=guide_legend(reverse=TRUE),
                       option="B") +
    labs(x = "", y = "", fill="Total Cases") +
    ggtitle("2021 COVID-19 Cases") +
    theme_void()

##########################what about rates?
####data prep
#summarize the data
data.rate<-data.weekly %>%
    group_by(district, population) %>%
    summarize(case_n=sum(cases, na.rm=TRUE)) %>%
    mutate(case_rate=(case_n/population)*100000)

#add it to the map
map.rate <- st_sf(left_join(data.rate, district.shp, by="district"))

#simple map
ggplot(data=map.rate, aes(fill = case_rate)) +
    geom_sf(color="black") 




