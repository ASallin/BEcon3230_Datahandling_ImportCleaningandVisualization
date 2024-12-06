#############################################################################
#' Data Handling Exercise 5
#' 
#' Version 1: Aurélien Sallin, 02.12.2022
#' - Update: 27.11.2023 (Andrea)
#############################################################################

# Set path
path <- "05_data_analysis/data/"

# Load packages using `pacman`
require(pacman)
pacman::p_load(dplyr, ggplot2, tidyr, readr)


# Exercise A ----------------------------------------------------------------
# Read stocks.csv into RStudio (store it in variable stocks). The dataset is currently in long format. Use
# pivot_wider() to transform it into wide format (separate columns for different years). Store the resulting
# tibble/data.frame in a variable called stocks2. Then, run the following code.

stocks <- read_csv(paste0(path, "stocks.csv"))

dim(stocks)
# This dataset has 4 rows and 3 columns

# Use pivot_wider() to transform it into wide format (separate columns for different years).
stocks2 <- pivot_wider(stocks, names_from = year, values_from = return)

dim(stocks2)
# This dataset has 2 rows and 3 columns

stocks_wide_long = pivot_longer(stocks2,
    cols = `2015`:`2016`,
    names_to = "year", 
    values_to = "return"
)
stocks_wide_long == stocks

str(stocks_wide_long)
str(stocks)


# Exercise B ----------------------------------------------------------------
#' Read `countries.csv` into RStudio (store it in variable `countries`). 
#' Then, run the following code.

countries <- read_csv(paste0(path, "countries.csv"))

pivot_longer(countries, 1999, 2000, names_to = "year", values_to = "cases")

#' Why does this code fail? How can you fix the problem?
#' R reads the numeric value 1999 as the column number. Column names are strings.
pivot_longer(countries, c("1999", "2000"), names_to = "year", values_to = "cases")



# Exercise C ----------------------------------------------------------------

#' Load tidyverse and read people.csv into R (store it in variable people). 
#' Try to spread people. Why does the spreading fail? How could you add a new column 
#' to fix the problem?

# Read the data
people <- read_csv(paste0(path, "people.csv"))

# Look at the dataset
str(people)

# Spread the data ("spread" means pivot wider)
pivot_wider(people, names_from = key, values_from =  value)

#' The issue is that the key-variable – the identifier – contains duplicate 
#' values. There are two times the age for the same person.

#' Fix problem:
#' One solution: assume there are two Phillip Woods and mark them with a 
#' different identifier
people$id <- c(1,1,2,3,3)
pivot_wider(people, names_from = key, values_from = value)

#' Or: remove the unnecessary column
people <- read_csv("05_data_analysis/data/people.csv")
people <- people[-3, ]
pivot_wider(people, names_from = key, values_from = value)

#' Or: Take the mean age and remove the unnecessary column
people <- read_csv(paste0(path, "people.csv"))
people <- people %>%
    group_by(name, key) %>% # group data
    mutate(value = mean(value)) %>% # compute average
    distinct() # remove duplicates
pivot_wider(people, names_from = key, values_from = value)


# Exercise D --------------------------------------------------
#' Read `preg.csv` into RStudio (store it in variable `preg`). 
#' Tidy `preg`. Do you need to use `pivot_wider` or `pivot_longer`? 
#' What are the variables?

# Sample solution
preg <- read_csv(paste0(path, "preg.csv"))

# use common sense ('heuristics') to figure out what information are contained
preg <- pivot_longer(preg, c("male", "female"), names_to = "gender", values_to = "count")

preg <- na.omit(preg)

preg <- preg %>%
    select(gender, pregnant, count)



# Exercise E --------------------------------------------------------------
#' Read the following dataset and transform it to long format.
df <- data.frame("Country" = c("US", "DE", "CH", "FR"),
                 "Covid_2020" = runif(4, 0, 1),
                 "AntiCovidExpenses_2020" = runif(4, 500, 1000))
df <- cbind(df, 
            "Covid_2021" = df$Covid_2020 + rnorm(4, 0, 0.1),
            "AntiCovidExpenses_2021" = df$AntiCovidExpenses_2020 + rnorm(4, 0, 100))

df_long <- pivot_longer(df, cols = 2:5, 
                        names_to = c(".value", "Year"),
                        values_to = c("n"),
                        names_sep = "_")
cor(df_long$Covid, df_long$AntiCovidExpenses)

# End of script.