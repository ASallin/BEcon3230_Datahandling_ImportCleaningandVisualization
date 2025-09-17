#######################################################################
# Project Lecture 7: Data Preparation, Reshaping, and Stacking
#
# This script is the main script for lecture 7 of Data Handling.
# In the first part, it prepares a messy data frame for analysis (analytical
# data frame). In the second part, the ideas of reshaping and stacking
# are illustrated with an example.
# 
# A. Sallin, St. Gallen, 2023
#######################################################################


# Set up ------------------------------------------------------------------

# Load packages (install if needed)
library(tidyverse) # tidyverse contains dplyr, readr, tibble, and all other packages from the tidyverse universe. 

# Set fix variables for PATH (for each student different)
INPUT_PATH <- "YourPath"
OUTPUT_FILE <- "YourOutputPath"



# Create messy data frame -------------------------------------------------

# We create a fake, messy dataframe for exercise purposes
messy_df <- data.frame(last_name = c("Wayne", "Trump", "Karl Marx"),
                       first_name = c("John", "Melania", ""),
                       gender = c("male", "female", "Man"),
                       date = c("2018-11-15", "2018.11.01", "2018/11/02"),
                       income = c("150,000", "250000", "10000"), stringsAsFactors = FALSE)






################################################################
# BREAK --------------------------
################################################################



# Reshaping datasets: introductory example/concept -----------------------------

# load example data

# If you are on Nuvolos: the file is in the folder "data"
rawdata <- read.csv("data/treatments.csv")

# If you are on your own machine, insert your Input Path
rawdata <- read.csv(paste0(YourPath, "/treatments.csv"))

# inspect data
rawdata



# Reshape: wide to long ---------------------------------------------------

# reshape from wide to long
tidydata <- pivot_longer(data = rawdata, 
                         cols = c("treatmenta", "treatmentb"),
                         names_to = "treatment",
                         names_prefix = "treatment",
                         values_to = "result")

# inspect result
tidydata

## initialize and inspect a wide example data-frame
wide_df <- data.frame(last_name = c("Wayne", "Trump", "Marx"),
                      first_name = c("John", "Melania", "Karl"),
                      gender = c("male", "female", "male"),
                      income.2018 = c("150000", "250000", "10000"),
                      income.2017 = c( "140000", "230000", "15000"),stringsAsFactors = FALSE)
wide_df

# transform from wide to long
long_df <- pivot_longer(wide_df, 
                        c(income.2018, income.2017),
                        names_to = "year",
                        names_prefix = "income.",
                        values_to = "income")
# inspect the result
long_df




# Reshape: long to wide ---------------------------------------------------

# initiate a weird long data.frame
weird_df <- data.frame(last_name = c("Wayne", "Trump", "Marx",
                                     "Wayne", "Trump", "Marx",
                                     "Wayne", "Trump", "Marx"),
                       first_name = c("John", "Melania", "Karl",
                                      "John", "Melania", "Karl",
                                      "John", "Melania", "Karl"),
                       gender = c("male", "female", "male",
                                  "male", "female", "male",
                                  "male", "female", "male"),
                       value = c("150000", "250000", "10000",
                                 "2000000", "5000000", "NA",
                                 "50", "25", "NA"),
                       variable = c("income", "income", "income",
                                    "assets", "assets", "assets",
                                    "age", "age", "age"),
                       stringsAsFactors = FALSE)


# inspect it, where are the problems?
weird_df


# transform from long to wide
tidy_df <- pivot_wider(weird_df,
                       names_from = "variable",
                       values_from = "value")

# inspect result
tidy_df


# Stacking/Row binding -------------------------------------------

# initialize and inspect sample subsets
# initialize
subset1 <- data.frame(ID=c(1,2),
                      X=c("a", "b"),
                      Y=c(50,10))

subset2 <- data.frame(ID=c(3,4),
                      Z=c("M", "O"))

subset3 <- data.frame(ID= c(5),
                      X=c("c"),
                      Z="P")

# inspect
str(subset1)
str(subset2)
str(subset3)


# combine/stack

# stack data frames
combined_df <- bind_rows(subset1, subset2, subset3)

# inspect the result
combined_df


