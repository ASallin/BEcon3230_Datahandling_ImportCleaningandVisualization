#############################################################################
#' Data Handling Exercise 4
#' 
#' Version 1: Aurélien Sallin, 23.11.2022
#' - Update: 30.10.2024 (Andrea)
#############################################################################

require(pacman)
p_load(dplyr, ggplot2, tidyr, readr, tidyverse, writexl, readxl)

# Exercise A ----------------------------------------------------------------
#' Read Section 11.-11.4 in https://r4ds.had.co.nz/data-import.html and solve the problem posed in Section
#' 11.4.2 ("Problems") by going step-by-step through the instructions.
#' Hint: You will need to have the `readr` package installed and loaded (should be also installed/loaded
#' with `tidyverse`).

challenge <- read_csv(readr_example("challenge.csv"))
head(challenge)

# The dataset 'challenge' has two variables:
#   x: integer until observation 1000, numeric afterwards
#   y: NA until observation 1000, date afterwards
challenge$x[c(1:50, 1000:1050)]
challenge$y[c(1:50, 1000:1050)]

# This can be seen using 'head(challenge)'
head(challenge)

# Uncorrect: y as logical
challenge <- read_csv(
    readr_example("challenge.csv"),
    col_types = cols(
        x = col_double(),
        y = col_logical()
    )
)
problems(challenge)

# Correct: y as date
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)


# Exercise B ----------------------------------------------------------------
#' 1. Download the file `airquality_data.xlsx` posted on Canvas and save it in your `r_course/data` folder.
#' 2. The file is a dataset that contains the New York air quality measurements. Familiarize with the data using `print`.
#' Do you think the dataset has problems? (Hint: look at the `type` of each column).
#' 3. Fix the problem identified in point 2. Save the new dataset as airquality_data_fixed.xlsx using `write_xlsx` from `tidyverse/writexl`.
#' 4. Write your solution down in an R-Script and document in this script why certain problems occur and how you solved them (using comments).

airquality_data <- read_excel("airquality_data.xlsx")

# Print the data
print(airquality_data)
# The type of column "month" is "character", while it should be "double" 
# (since we are supposed to only have numbers). Let's sort the column.
print(sort(airquality_data$Month))

# We can see that there is a typo. For one observation we have "five" instead
# of 5. Let's fix this.
airquality_data_fixed <- airquality_data
airquality_data_fixed$Month <- ifelse(airquality_data$Month == "five", 5, airquality_data_fixed$Month)
print(airquality_data_fixed)

# We replaced the value but we still have column "Month" as a "character", 
# we need to fix this.
airquality_data_fixed$Month <- as.numeric(airquality_data_fixed$Month)
print(airquality_data_fixed)

# Now we can save the new dataset.
library(writexl)
write_xlsx(airquality_data_fixed, "airquality_data_fixed.xlsx")



# Exercise C ----------------------------------------------------------------
#' 1. Visit the EU Open Data Portal on COVID cases. (Do you remember this website 
#' from Exercise Session 2?)

#' 2. Download the "COVID-19 Cases Worldwide" data in JSON format. However, do not 
#' download these data manually (i.e., do not click-and-save). Instead, load the data 
#' directly into RStudio from the web. 
#' Hint 1: consider the `jsonlite` package. 
#' Hint2: the direct link to the JSON file 
#' (https://opendata.ecdc.europa.eu/covid19/casedistribution/json/) may be helpful.


# Load library and look for help to find out which command to use
library(jsonlite)
?jsonlite

# Save the url as a string
url_covid19_cases <- "https://opendata.ecdc.europa.eu/covid19/casedistribution/json/"

# Import data
data_json <- fromJSON(txt = url_covid19_cases)

#' 3. Reformat the JSON data that you have imported into RStudio to a rectangular format 
#' (such that each record is represented as a row and each field as a column).

# Understand data
str(data_json)   # the dataset is a list with one element, and this element is a 
                 # dataframe. We need to extract this dataset from the list. 
typeof(data_json)

data <- data_json[[1]] # access first element of list by index
names(data_json)
data <- data_json$records #access first element of list by name

# We have the desired results
head(data)
