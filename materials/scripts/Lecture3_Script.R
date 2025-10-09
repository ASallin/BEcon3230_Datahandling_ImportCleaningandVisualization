################################################################
# Data Handling: Import, Cleaning and Visualisation
# Lecture 3: Students' notebook
# Dr. Aurélien Sallin
################################################################



# Encoding matters -----------------------------------------

# Create a text file using bash
# echo "Hello World!" > helloworld.txt

# Inspect using bash
# cat helloworld.txt; echo

# Inspect in R
readLines("helloworld.txt")

# Hex dump in bash
# xxd -b helloworld.txt

# Hex dump in bash: hex
# xxd  data/helloworld.txt



# Encoding issues ---------------------------------------------------------

# Read
# cat hastamanana.txt; echo

# Check hex dump
# file -b hastamanana.txt

# 
# iconv -f iso-8859-1 -t utf-8 hastamanana.txt | cat




# Text files --------------------------------------------------------------

library(httr)
library(pryr)

economist <- GET("https://www.economist.com/")

pryr::object_size(economist)

economistRaw <- content(economist, as = "raw")
head(economistRaw, 20)

economistText <- content(economist, as = "text")
head(economistText)

# Save it
writeLines(economistText, "economistText.html")
