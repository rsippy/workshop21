# Workshop Materials
### Modelling for Public Health

## Instructors
- Rachel Sippy<sup>1</sup>, PhD, MPH (rachel.sippy@gmail.com)
- Henrik Salje<sup>2</sup>, PhD 

<sup>1</sup> Division of Statistics, University of St Andrews, St Andrews UK

<sup>2</sup> Department of Genetics, University of Cambridge, Cambridge UK

## About the Course
This course provides a broad overview of modeling for public health purposes and a more intensive focus on mathematical/mechanistic modeling. We will define modeling and important modeling-related terms, learn about the major categories of modeling, discuss modeling goals, and practice interpreting the models we see in public health-related scientific papers. During the sessions focusing on mathematical models, we will mix lectures with practical sessions (using R). During the sessions, we will review examples of literature using these types of models, learn what parts of an epidemic we can model, examine modeling structures and how to adapt them to different epidemic scenarios, learn the advantages of using serological data, practice building a model, and discuss methods to evaluate model quality. The course will introduce R and demonstrate building/running models in R. 

Zoom sessions will be recorded and shared after each class. Please email/WhatsApp Rachel between sessions if you have questions or want to set up extra time to meet & review!

## Content

There is an introductory session followed by a series of sessions for more in-depth discussion of public health surveillance. We will start with traditional surveillance methods followed by additional surveillance strategies. The following schedule may be revised depending on availability of instructors and modifications to improve learning/provide additional practice. If there are updates to the schedule, they will be announced and sent via email. 

* [Introduction to Modeling for Public Health](Slides/ModelingPHResearch_Student.pdf {[paper1](References/MathMod_Explained_Bjørnstad.pdf)} {[paper2](References/Statistics_Explained_Kirkwood.pdf)}
* [Mathematical Models Overview & History](Slides/W1OverviewHistory.pdf) {[paper1](References/Leek&Peng.pdf)} {[paper2](References/viru-4-295.pdf)}
* [Epidemic Growth](Slides/W1EpidemicParameters.pdf)
* [SIR Models](Slides/W1SIRModelsStudent.pdf)
* [SIR Models & Epidemic Growth](Slides/W2SIRModelsEpidemicParameters.pdf)
* [Expanding SIR Models](Slides/W2MoreCompartmentalModels.pdf) 
* [Guest Lecture: Models of Vaccination](Slides/Trotter_3Aug2021.pdf)
* [Using Serology & Adding Interventions](Slides/W2SerologyInterventionModelsStudent.pdf) 
* [Guest Lecture: Age-specific Models](Slides/AgeSpecificCOVID-BangladeshTalk.pdf) 
* [Stochasticity](Slides/W3Stochasticity.pdf)
* [Model Building](Slides/W3ModelBuilding.pdf) {[paper1](References/Eggo2021.pdf)} {[paper2](References/Holmdahl2020.pdf)}
* [Guest Lecture: COVID-19 in Bangladesh](Slides/COVID-19Situational_Analysis.pdf)
* [Model Assessment](Slides/W3ModelAssessment.pdf)

We expect that participants will have some experience in statistical programming. We will start with a slow introduction to R, and build useful skills for exploration and analysis of public health surveillance data. This will include two assignments for self-guided practice with R. Topics will include:

* Introduction to R {[code](R_Sessions/Code/practice_day1.R)}
* Basic Commands in R {[code_1](R_Sessions/Code/practice.R)} {[code_2](R_Sessions/Code/practice_day2.R)}
* Data Preparation (self-guided {[pdf](R_Sessions/worksheet1.pdf)} {[html](R_Sessions/worksheet1.html)} {[solutions](R_Sessions/worksheet1_sol.html)})
* Exploratory Analysis (self-guided {[pdf](R_Sessions/worksheet2.pdf)} {[html](R_Sessions/worksheet2.html)} {[solutions](R_Sessions/worksheet2_sol.html)})
* Tidyverse {[code](R_Sessions/Code/tidyverse.R)}
* Visualization & Plotting with ggplot2 {[code](R_Sessions/Code/plots.R)}
* Mapping {[code](R_Sessions/Code/mapping.R)}
* Time Series & Forecasting {[code](R_Sessions/Code/forecasting.R)}

## Pre-course preparation
- Install or update **R program** (R version 3.5.2) and **RStudio** (1.2.5033). A brief guide to installing R, RStudio, and packages can be found [here](R_Sessions/Installation_guide_R.pdf).
- Install the necessary R packages:
   - colorist, RColorBrewer, haven, xlsx, tidyverse, reshape2, ggplot2, datasets, sf, maps, data.table, viridis, scales, forecast, slider, feasts
   - *install.packages(c("colorist", "RColorBrewer", "haven", "xlsx", "tidyverse", "reshape2", "ggplot2", "datasets", "sf", "maps", "data.table", "viridis", "scales", "forecast", "slider", "feasts"))*
- Download the course material
   - [Datasets](R_Sessions/Data)
   - [R code](R_Sessions/Code)
