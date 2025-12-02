
####################################
#Guest lecture: Data handling
#Andrew Li
#27Nov, 2025
####################################

# Download the relevant library
install.packages("fredr")
install.packages("ggplot2")
# Load the relevant library
library(fredr)
library(ggplot2)

# Set your FRED API key to access the Federal Reserve Economic Data (FRED) API
fredr_set_key("XXX")

##### Task 1: Real yield relative high compared to historical period
##Real yield from 2000 (DFII10) -> Show the current real yield percentile

# Import US 10y real yield
data <- fredr(
  series_id = "DFII10",   # Market Yield on U.S. Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis
  observation_start = as.Date("2000-01-01"),  # Start date
  observation_end = as.Date("2025-11-17")     # End date - Let's fix on 17Nov, 2025 for consistency
)

# Check the summary of data
summary(data) 
#Earliest: 2003-01-02
#Latest: 2025-11-17
#How many NA's? 245

# Remove rows with NA values
data <- na.omit(data)
summary(data) 

# Get the latest row
latest_row <- data[which.max(data$date), ]  # Get the row with the latest date
latest_date <- latest_row$date              # Extract the date column
latest_value <- latest_row$value            # Extract the value column
# Display the latest value and corresponding date
cat("The latest value is:", latest_value, "on", as.character(latest_date), "\n")
#Ans: The latest value is: 1.85 on 2025-11-17 

# Check the percentile
# Calculate the percentile using ecdf
help(ecdf) # Check what the function does
ecdf_func <- ecdf(data$value)       # Create ECDF for the 'value' column
percentile <- ecdf_func(latest_value) * 100  # Calculate the percentile of the latest value
# Output the result
cat("The latest value is in the", percentile, "percentile of the dataset.\n")
#Ans: The latest value is in the 75.51983 percentile of the dataset.

# Plot the empirical cdf to confirm
# Plot the ECDF
plot(ecdf_func, main = "Empirical Cumulative Distribution Function",
     xlab = "Value", ylab = "Cumulative Probability",
     col = "blue", lwd = 2)

# Plot a boxplot to confirm
boxplot(data$value, 
        main = "Boxplot of US 10y Real Yield (since 2003)", 
        ylab = "Values", 
        col = "lightblue")

# Add the latest value as a red dot
latest_value <- data$value[which.max(data$date)]  # Extract the latest value
points(1, latest_value, col = "red", pch = 19, cex = 1.5)  # Add the latest value as a red dot

##### Task 2:  Risks: Rising US inflation
## US recent CPI numbers (CPIAUCSL) -> Show inflation (yoy,%) from 2024

# Remove all variables from the environment
rm(list = ls())
# Check the environment (should be empty now)
ls()

# Import US CPI
data <- fredr(
  series_id = "CPIAUCSL",   # Consumer Price Index for All Urban Consumers: All Items in U.S. City Average (CPIAUCSL)
  observation_start = as.Date("2023-01-01"),  # Start date (Why we need 2023 data?)
  observation_end = as.Date("2025-11-23")     # End date - Let's fix on 23Nov, 2025 for consistency
)

# Check the summary of data
summary(data) #It's a monthly data, latest: Sep2025 and should be no NA.

# Calculate inflation (yoy,%) from 2024
# year-on-year changes of CPI = Inflation (yoy, %)
data$inflation_yoy <- c(rep(NA, 12), 100 * ((data$value[13:nrow(data)] - data$value[1:(nrow(data) - 12)]) / data$value[1:(nrow(data) - 12)]))

# Filter data to include only from 2024 onwards
data_filtered <- subset(data, date >= as.Date("2024-01-01"))

# Check the resulting data
head(data_filtered$inflation_yoy)

# Plot inflation (yoy,%) from 2024
ggplot(data_filtered, aes(x = date, y = inflation_yoy)) +
  geom_line(color = "blue", size = 1) + # Line plot for inflation
  labs(
    title = "Year-on-Year Inflation (%)",
    x = "Date",
    y = "Inflation (YoY, %)"
  ) +
  scale_x_date(
    date_breaks = "3 months", # Breaks every 3 months
    date_labels = "%b %Y"    # Format as "Month Year" (e.g., Jan 2024)
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), # Center the title
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotate x-axis labels
  )

##### Task 3:  Risks: increasing debt-to-GDP ratio
## US public debt-to-GDP ratio (GFDEGDQ188S) -> Show line chart from 2015

# Remove all variables from the environment
rm(list = ls())
# Check the environment (should be empty now)
ls()

# Import US debt-to-GDP ratio
data <- fredr(
  series_id = "GFDEGDQ188S",   # Federal Debt: Total Public Debt as Percent of Gross Domestic Product
  observation_start = as.Date("2015-01-01"),  # Start date 
  observation_end = as.Date("2025-11-23")     # End date - Let's fix on 23Nov, 2025 for consistency
)

# Check the summary of data
summary(data) #It's a quarterly data, latest: 1Q 2025 and should be no NA.

# Plot US debt-to-GDP ratio with quarterly labels
ggplot(data, aes(x = date, y = value)) +
  geom_line(color = "blue", size = 1) +  # Line plot for debt-to-GDP ratio
  labs(
    title = "US Debt-to-GDP Ratio (Quarterly)",
    x = "Date",
    y = "Debt-to-GDP Ratio (%)"
  ) +
  scale_x_date(
    date_breaks = "6 months", # Breaks every 6 months (2 quarters)
    date_labels = "%b %Y"    # Display as Quarter and Year (e.g., Q1 2015)
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), # Center the title
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotate x-axis labels
  )

#######BONUS Question########
#1)Show the market mid- to long-term inflation expectation still stable/ decline recently.
#Possible indicator: 5-Year, 5-Year Forward Inflation Expectation Rate (T5YIFR)
#2)Show the consumer short-term inflation expectation decline from recent high.
#Possible indicator: University of Michigan: Inflation Expectation (MICH)
#3)Show Fed still on track to cut rate
#Possible indicator: FOMC Summary of Economic Projections for the Fed Funds Rate, Median (FEDTARMD)