#############################################################################
#' Data Handling Exercise 5
#' 
#' Version 1: Andrea Burro, 25.06.2025
#' 
#############################################################################

# Load packages
library(tidyverse)

# Exercise A ----------------------------------------------------------------

## A.1 - Convert to Long Format

economics <- economics

df_long <- pivot_longer(
  economics,
  cols = -date,
  names_to = "variable",
  values_to = "value"
)


## A.2 - Convert to Wide Format

df <- pivot_wider(
  df_long,
  names_from = "variable",
  values_from = "value"
)

# Exercise B ----------------------------------------------------------------

## B.1 - Filter Observations

df_reduced <- df %>% mutate(
  year = year(date)
) %>% filter(
  year >= 2000
) %>% select(-year)

## B.2 - Select Observations

df_reduced <- df_reduced %>% select(
    date, pce, pop
  )


## B.3 - Create Indicator Variable

df_reduced <- df_reduced %>% mutate(
  after_2000 = 1
)

# Exercise C ----------------------------------------------------------------

## C.1 - Merge Datasets

df_merged <- df %>% left_join(
  df_reduced
)

## C.2 - Handle Missing Values

df_merged <- df_merged %>% mutate(
  after_2000 = if_else(is.na(after_2000), 0, after_2000)
)
