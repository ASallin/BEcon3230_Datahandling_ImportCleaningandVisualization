# Exercise on EDA
# Lecture 9 - Data Handling
# Author: Aurélien Sallin, 2024



# Set-up ------------------------------------------------------------------

library(datasets) # for the swiss dataset
library(tidyverse)
library(summarytools)
library(skimr)



# Load data and make some manual changes ----------------------------------

# Load the built-in 'swiss' dataset from the package "datasets"
data("swiss")

swiss <- rownames_to_column(swiss, var = "municipality")

# Add an outlier in Lausanne
swiss[swiss$municipality == "Lausanne", "Infant.Mortality"] <- 100

# Add a NA for Agriculture in Gruyere
swiss[swiss$municipality == "Gruyere", "Agriculture"] <- NA



# Exploration with EDA tools ----------------------------------------------

summary(swiss)

# Use skimr
skim(swiss)

# use summarytools
summarytools::descr(swiss)
summarytools::freq(swiss)
summarytools::dfSummary(swiss)




# Exploration per group ---------------------------------------------------

swiss |> 
  group_by(Catholic > 50) |> 
  summarize(mean(Fertility))

swiss |> 
  group_by(Catholic > 50) |> 
  summarize(across(.cols = c(Fertility, Education),
                   .fns = list("min" = min, "mean" = mean, "max" = max))) 