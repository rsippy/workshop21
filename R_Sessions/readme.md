# R Lessons

The datasets used can be found [here](Data/). The code for each session is as follows:

* Introduction to R {[slides](R_Sessions/Rsession_Day2_3.pdf)} {[code](R_Sessions/Code/practice_day1.R)}
* Basic Commands in R {[code](R_Sessions/Code/practice_day2.R)}
* Closed SIR Models in R {[code](R_Sessions/Code/practice_day3.R)} 
* Estimating Parameters & Open SIR Models Analysis {[code](R_Sessions/Code/week2_day1.R)}
* Closed SEIR & Open SEIR {[code](R_Sessions/Code/week2_day2.R)}
* Adding Interventions {[slides](R_Sessions/SVEIRModelDiagram.pdf} {[code](R_Sessions/Code/week2_day3.R)}
* Adding Stochasticity I {[code](R_Sessions/Code/Bangladesh_DelayDistributionTutorial.R)}
* Adding Stochasticity II {[code](R_Sessions/Code/week3_day1.R)}
* Fitting Curves {[code](R_Sessions/Code/week3_day2.R)}
* Tidyverse Introduction {[slides](R_Sessions/Tutorial.pdf)}
* COVID-19 Model {[code](R_Sessions/Code/class_covid_model.R)}
* Time Series Plots {[code](R_Sessions/Code/1.0_timeseries_using_public_data_teaching.R)}

## Pre-course preparation
- Install or update **R program** (R version 3.5.2) and **RStudio** (1.2.5033). A brief guide to installing R, RStudio, and packages can be found [here](R_Sessions/Installation_guide_R.pdf).
- Install the necessary R packages:
   - deSolve, colorist, RColorBrewer, haven, tidyverse, coronavirus, zoo, ggthemes, lubridate
   - *install.packages(c("deSolve", "colorist", "RColorBrewer", "haven" "tidyverse", "coronavirus", "zoo", "ggthemes", "lubridate"))*

# R References

R can be a challenge to learn, especially if you've never worked in any programming languages in the past. I've placed some references [here](References/) and below to help you practice and some cheat sheets to help you remember bits of code.

## Visualization

* [Tips for Data Visualization](References): general principles
* [Color Names in R](References/Rcolor.pdf): referencing colors in R
* [From Data to Viz](https://www.data-to-viz.com/): choosing the correct visualization
* [R Graph Gallery](https://r-graph-gallery.com/): compendium of figures and accompanying code
* [ggplot Reference Guide](https://ggplot2.tidyverse.org/): nice cheatsheets on opening page

## Handbooks & Texts

* [The Epidemiologist R Handbook](https://appliedepi.org/epirhandbook/): nearly everything an epidemiologist might want to do in R
* [Forecasting Principles & Practice](https://otexts.com/fpp2/intro.html): an excellent resource to learn more about forecasting theory with code
* [R for Data Science](https://r4ds.had.co.nz/): data manipulation, simple models, and visualization in tidyverse
