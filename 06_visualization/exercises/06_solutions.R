#############################################################################
#' Data Handling Exercise 6
#' 
#' Version 1: Aurélien Sallin, 16.12.2022
#' - Update: 
#############################################################################

# install and load packages
# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# Set data formats to English
loc <- Sys.setlocale(locale = "en_US.utf8")


# Exercise A -------------------
# Inspect the dataset. The dataset is not saved as an object in the environment yet
# but it is loaded through the package "nycflight13"
flights
str(flights)

# Filter data: only flight from Boston and to Boston
boston_flights <- filter(flights, origin == "BOS" | dest == "BOS")

# Summarize data by group
bf_by_months <- group_by(boston_flights, month)
bf_sum <- summarise(bf_by_months,
                    mean_air_time= mean(air_time, na.rm = TRUE),
                    median_air_time = median(air_time, na.rm = TRUE),
                    sd_air_time=sd(air_time, na.rm = TRUE),
                    min_air_time = min(air_time, na.rm = TRUE),
                    max_air_time = max(air_time, na.rm = TRUE)
)

# Format data: rounding to 2 decimals
# Using matrix (base-R) notation
bf_sum[, 2:ncol(bf_sum)] <- round(bf_sum[, 2:ncol(bf_sum)], digits = 2)
# Using dplyr notation
bf_sum <- bf_sum %>% 
  mutate(across(.cols = ends_with("_time"), .fns = round, 2))

# Improve data display
# show month names
library(lubridate)
bf_sum$month <- months(parse_date_time(bf_sum$month, "m"))
# Improve column headers
names(bf_sum) <- c("Month", "Mean", "Median", "Std. Deviation", "Min. Value", "Max. Value")

# Output as markdown table
# This step is for cosmetic purposes
library(knitr)
kable(bf_sum,
      row.names = FALSE,
      digits = 2,
      caption = "Summary Statistics: Air time (in minutes) for flights between NYC and BOS (2013)" )






# Exercise B -------------------------------

# select subset
plotdata <- select(flights, month, Destination = dest, arr_delay, dep_delay)
plotdata <- filter(plotdata,
                   month == 6 | month == 12,
                   Destination %in% c("BOS", "ORD", "LAX"))
plotdata <- na.omit(plotdata)

# format months
plotdata$month <- months(parse_date_time(plotdata$month, "m"))

# plot
flights_plot <- 
  ggplot(plotdata, aes(x=dep_delay, y=arr_delay)) +
  geom_point(aes(colour=Destination)) +
  geom_smooth(colour="black") +
  facet_wrap(~month) + 
  theme_minimal() +
  ylab("Arrival Delay (in minutes)") +
  xlab("Departure Delay (in minutes)") +
  theme(legend.position = "top")

flights_plot




# Exercise C: 

# http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html#challenge_solution_:prototype:
