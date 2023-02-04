# Workshop Materials
### Public Health Surveillance

## Instructors
- Rachel Sippy<sup>1</sup>, PhD, MPH (rachel.sippy@gmail.com)
- Henrik Salje<sup>2</sup>, PhD 

<sup>1</sup> Division of Statistics, University of St Andrews, St Andrews UK

<sup>2</sup> Department of Genetics, University of Cambridge, Cambridge UK

## About the Course
This course provides a broad overview of surveillance methods for public health, primarily focusing on infectious diseases. We will define terminology, learn about the major types of surveillance, discuss surveillance goals, and practice evaluation of surveillance systems. We will mix lectures with practical sessions (using R). During the sessions, we will cover surveillance goals, molecular surveillance, serological surveillance, genetic surveillance, wildlife/veterinary surveillance, vaccination coverage, and practice assessment of programs. The course will continue to build R skills.

Zoom sessions will be recorded and shared after each class. Please email/WhatsApp Rachel between sessions if you have questions or want to set up extra time to meet & review!

## Content

There is an introductory session followed by a series of sessions for more in-depth discussion of public health surveillance. We will start with traditional surveillance methods followed by additional surveillance strategies. The following schedule may be revised depending on availability of instructors and modifications to improve learning/provide additional practice. If there are updates to the schedule, they will be announced and sent via email. 

* [Review of 2021 Modeling Workshop](Slides/Modeling_for_Public_Health_Review_student.pdf)
* [Introduction & Surveillance Goals](Slides/Intro_Surveillance_student.pdf) {[paper1](References/Intro_Climate.pdf)}
* [Case-based Surveillance Methods](Slides/Surveillance_Types_student.pdf)
* [Serological Surveillance](Slides/Serosurveillance.pdf)
* [Wildlife/Veterinary Surveillance](Slides/Animal_Surveillance_student.pdf)
* [Molecular & Genomic Surveillance](Slides/MolGen_Surveillance_student.pdf) {[paper1](References/MolGen_Campylobacter.pdf)} {[paper2](References/MolGen_H5N1.pdf)}
* [Tracking Vaccination & Vaccine-Preventable Disease](Slides/Vaccine_Surveillance_student.pdf)
* [Surveillance Assessment & Evaluation](Slides/Surveillance_Assessment_student.pdf) [paper1](References/Assess_Sensitivity.pdf)
* [Assessment Case Studies](Slides/Assessment_Examples_student.pdf) {[paper1](References/Assess_CS_EWARS.pdf)} {[paper2](References/Assess_CS_USData.pdf)}
* [Practice Assessment of Cholera Surveillance in Bangladesh](Slides/Bangladesh_Assessment_student.pdf)

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
