#############################################################################
#' Data Handling Exercise 4
#' 
#' Version 1: Aurélien Sallin, 23.11.2022
#' - Update: 02.12.2022
#############################################################################

require(pacman)
pacman::p_load(dplyr, ggplot2, tidyr, readr)

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

# This can be seen using 'tail(challenge)'
tail(challenge)

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

# Alternative:
challenge2 <- read_csv(
    readr_example("challenge.csv"),
    guess_max = 1001
)



# Exercise B ----------------------------------------------------------------
#' 1. Download the file `tv_ownership.dat` posted on Canvas and save it in your `r_course/data` folder.

#' 2. The file is an excerpt of a dataset provided by the US Federal Communications Commission (FCC) 
#' with detailed data on TV and Radio stations ownership. The excerpt is in the original format as 
#' provided by the FCC. Figure out how to read this dataset into R with the functions provided in the 
#' `tidyverse/readr`-packages.

mydata <- read_csv("04_data_import/tv_ownership.dat")
mydata <- read_delim("04_data_import/tv_ownership.dat", delim = "|", col_names = FALSE)
mydata


# Some problems persist. 
problems(mydata)
# Rows 13 and 14 do not have the expected number of columns.

# Explore row 13 and 14, and problematic variables in the raw file
# End of line 13: no eol |^| ("206425|1464390|GUARANTEE AGREEMENT")
myrawdata <- read_file("04_data_import/tv_ownership.dat")


# The true eols are |^|. We then replace them with \n to make it clear.
# \n is the standard end of line symbol.
# remove eol characters
myrawdata <- gsub("\n", "", myrawdata, fixed = TRUE)
# replace all `|^|` with eol characters
myrawdata <- gsub("|^|", "\n", myrawdata, fixed = TRUE)


mydata <- read_delim(myrawdata, delim = "|", col_names = FALSE)

# Check
mydata[10:24,]

#' 3. Write your solution down in an R-Script and document in this script why certain problems occur and 
#' how you solved them (using comments).



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
