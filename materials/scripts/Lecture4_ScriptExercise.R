#######################################################################
# Data Handling Course: Example Script for Data Gathering and Import
#
# Imports data from ...
# Input: import c to data sources (data comes in ... format)
# Output: cleaned data as CSV
# 
# A. Sallin, St. Gallen, 2024
#######################################################################

# SET UP --------------
# load packages
library(readr)
library(stringi)


# SET PATH ------------------
# path <- "C:/Users/aurel/Downloads"
path <- "data/"


# IMPORT RAW DATA FROM CSVs -------------
financial_data <- read.csv(paste0(path, "financial_data.txt"))
financial_data


financial_data <- read.csv(paste0(path, "financial_data.txt"), sep = ":")



# Guess encoding ----------------------------------------------------------

stringi::stri_enc_detect("\xF6")

financial_data <- read.csv(paste0(path, "financial_data.txt"), 
                           sep = ":",
                           fileEncoding = "ISO-8859-1")


# Clean -------------------------------------------------------------------

# Explore
head(financial_data, 10)
str(financial_data)

# Remove special character
financial_data[10, 3] <- 1933

# Coerce to numeric
financial_data$Revenue <- as.numeric(financial_data$Revenue)

# Another way of writing the column selection
financial_data[10, "Revenue"]
financial_data[10, "Revenue"] <- 1933

financial_data[, "Revenue"] <- as.numeric(financial_data[, "Revenue"])



# Or with read_delim() ----------------------------------------------------

financial_data <- read_delim(paste0(path, "financial_data.txt"), delim = ":")
financial_data[10, 3] <- "1933"
financial_data$Revenue <- as.numeric(financial_data$Revenue)




# Summary stats -----------------------------------------------------------

summary(financial_data)



# Variable creation -------------------------------------------------------

financial_data$costs <- financial_data$Revenue - financial_data$Profit



# Factor ------------------------------------------------------------------

financial_data$Category <- as.factor(financial_data$Category)
levels(financial_data$Category)




# Nested lists ------------------------------------------------------------

list_financial_data <- split(financial_data, financial_data$Category)

for (i in 1:length(list_financial_data)){
  print(mean(list_financial_data[[i]]$Profit))
}

# Or, using lapply 
lapply(list_financial_data, function(x) mean(x$Profit))




# Using map ---------------------------------------------------------------

# Or (advanced!) with a nested tibble and map 
library(tidyr)
library(dplyr)
library(purrr)

tibble_financial_data <- financial_data |>
  group_by(Category) |>
  nest()

map(tibble_financial_data$data, ~mean(.$Profit))




# End -------------