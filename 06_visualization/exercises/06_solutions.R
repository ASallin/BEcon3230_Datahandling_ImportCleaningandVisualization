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

# Summary statistics on destination flights
count(flights, dest)
nrow(flights[flights$dest == "BOS", ]) # 15508 flights to Boston

# Filter data: only flight to Boston
boston_flights <- filter(flights, dest == "BOS")

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
bf_sum <- bf_sum %>%
  mutate(month = months(parse_date_time(month, "m")))

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

#' Read the csv directly from the John Hopkins University github page.
#' If you are working from behind a firewall or without admin privileges,
#' you might not be able to load the csv directly. In this case, you 
#' should open the webpage, copy its content, paste it in a text file, and 
#' save it with the .csv extension. 
confirmedraw <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

# This dataset is in WIDE format and is not tidy
dim(confirmedraw)

df_confirmed <- confirmedraw %>%
  pivot_longer( # Make the dataset LONG
    cols = -c(Country.Region, Province.State, Lat, Long),
    names_to = "date", values_to = "confirmed"
  )  %>% 
  group_by(Country.Region, date) %>% # Group the dataset per country and date
  summarize(confirmed = sum(confirmed)) # Get the sum of confirmed cases per country per date.

# The dataset is now LONG:
str(df_confirmed)

# Make some changes in the date format:
df_confirmed <- df_confirmed %>%
  mutate(date = sub("X", "", date))  %>%  # remove the "x" and substitute them with nothing ("")
  mutate(date = as.Date(date, "%m.%d.%y")) # Change the character variable "date" into a date format mm.dd.yy


# Compute the cumulated number of cases
df_confirmed <- df_confirmed %>%
  mutate(confirmed = as.numeric(confirmed))  %>% # See note below
  arrange(Country.Region, date) %>%
  # We need to order the data so that dates are in a chronological order
  # (this is important for the command "cumsum" below)
  group_by(Country.Region) %>% # We want the cumulated number per country, thus group by country
  mutate(
    cumconfirmed = cumsum(confirmed), # Create a variable with cumulated sum
    days = date - min(date) + 1 # Create a variable with number of days since beginning of pandemic
  )

# Note: the variable "confirmed" was an integer before we converted it using "as.numeric"
typeof(df_confirmed$confirmed)
# Integers in R have a limited size ()
.Machine$integer.max
?as.integer
#' From the help: "Note that current implementations of R use 32-bit integers for integer 
#' vectors, so the range of representable integers is restricted to about 
#' ±2×10⁹-
#' Our cumulative sum will go beyond this size. For this reason, we need to transform
#' our integers into numeric values.

# Restrict to the countries of interest
df_countryselection <- df_confirmed %>% 
  filter(Country.Region==c("US", "Italy", "China", "France", "United Kingdom", "Germany", "Switzerland"))

dim(df_countryselection)

ggplot(data = df_countryselection, 
        aes(x=days, y = cumconfirmed, colour = Country.Region)) + 
  geom_line(size=1) +
  theme_classic() +
  labs(title = "Cumulative Covid-19 Confirmed Cases by Country", 
       x = "Days", 
       y = "Confirmed cases (log scale)"
  ) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(trans="log10") # Convert to log scale
