#############################################################################
#' Data Handling Exercise 5
#' 
#' Version 1: Andrea Burro, 25.06.2025
#' 
#############################################################################

# Load packages
library(tidyverse)

gdp <- data.frame(
  "date" = seq(as.Date("2013-01-01"), as.Date("2017-10-01"), by = "quarter"),
  "gdp" = c(16648.189, 16728.687, 16953.838, 17192.019,
            17197.738, 17518.508, 17804.228, 17912.079,
            18063.529, 18279.784, 18401.626, 18435.137,
            18525.933, 18711.702, 18892.639, 19089.379,
            19280.084, 19438.643, 19692.595, 20037.088)
)


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

## B.1 - Unemployment rate
df <- df |>
  mutate(
    unemployment_rate = unemploy / pop
  )

## B.2 - Filter Observations
library(lubridate)

df <- df |>
  mutate(
    year = year(date)
  )

df_reduced <- df |>
  filter(
    year >= 2000
  ) |>
  select(-year)


## B.3 - Select Observations

df_reduced <- df_reduced |>
  select(
    date, pce, pop
  )

## B.4 - Create Indicator Variable

df_reduced <- df_reduced |> 
  mutate(
    after_2000 = 1
  )


# Exercise C ----------------------------------------------------------------

## C.2 - Left Join

# Problem: gdp data is quarterly, economics data is monthly. gdp covers only 2013-2017.
df_merged <- df |>
  left_join(
    gdp,
    by = "date"
  )

## C.3 - Handle Missing Values

df_merged <- df_merged |> 
  filter(!is.na(gdp))


## C.4 - Inner Join

df_merged_inner <- df |>
  inner_join(
    gdp,
    by = "date"
  )


## C.5 - Summary statistics

summary_stats <- df_merged |> 
  group_by(year) |> 
  summarise(
    mean_pop = mean(unemployment_rate, na.rm = TRUE),
    median_pop = median(unemployment_rate, na.rm = TRUE),
    sd_pop = sd(unemployment_rate, na.rm = TRUE),
    mean_uempmed = mean(gdp, na.rm = TRUE),
    median_uempmed = median(gdp, na.rm = TRUE),
    sd_uempmed = sd(gdp, na.rm = TRUE)
  )

### C.5 - Arrange your Summary statistics
summary_stats <- summary_stats |> 
  arrange(desc(year))


# Exercise D ---------------------------------
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes", NA, 10,
  "no", 20, 12
)

pivot_longer(preg, c("male", "female"), names_to = "gender", values_to = "count")


# Exercise E ---------------------------------
df <- data.frame("Country" = c("US", "DE", "CH", "FR"),
                 "Covid_2020" = runif(4, 0, 1),
                 "AntiCovidExpenses_2020" = runif(4, 500, 1000))
df <- cbind(df, 
            "Covid_2021" = df$Covid_2020 + rnorm(4, 0, 0.1),
            "AntiCovidExpenses_2021" = df$AntiCovidExpenses_2020 + rnorm(4, 0, 100))

# Convert data to long
df_long <- pivot_longer(df, cols = 2:5, 
                        names_to = c(".value", "Year"),
                        values_to = c("n"),
                        names_sep = "_")

# Compute correlation
cor(df_long$Covid, df_long$AntiCovidExpenses)
