# Exercise A -------------------


# install and load packages
# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)


# Inspect the dataset
flights
str(flights)


# select data
boston_flights <- filter(flights, origin == "BOS" | dest == "BOS")

# summarize data
bf_by_months <- group_by(boston_flights, month)
bf_sum <- summarise(bf_by_months,
                    mean_air_time= mean(air_time, na.rm = TRUE),
                    median_air_time = median(air_time, na.rm = TRUE),
                    sd_air_time=sd(air_time, na.rm = TRUE),
                    min_air_time = min(air_time, na.rm = TRUE),
                    max_air_time = max(air_time, na.rm = TRUE)
)

# format data
bf_sum[,2:ncol(bf_sum)] <- round(bf_sum[,2:ncol(bf_sum)], digits = 2)

# improve data display
# show month names
library(lubridate)
bf_sum$month <- months(parse_date_time(bf_sum$month, "m"))
# Improve column headers
names(bf_sum) <- c("Month", "Mean", "Median", "Std. Deviation", "Min. Value", "Max. Value")


# output as markdown table
library(knitr)
kable(bf_sum,
      row.names = FALSE,
      digits = 2,
      caption = "Summary Statistics: Air time (in minutes) for flights between NYC and BOS (2013)" )










# Exercise B -------------------------------

# select subset
plotdata <- select(flights, month, Destination = dest, arr_delay, dep_delay)
plotdata <- na.omit(filter(plotdata,
                           month == 6 | month == 12,
                           Destination %in% c("BOS", "ORD", "LAX")))

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
