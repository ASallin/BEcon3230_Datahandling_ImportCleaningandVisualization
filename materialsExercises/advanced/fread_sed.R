# Advanced import problem: define own eol and import with fread

# packages
library(data.table)
library(readr)

# replace eol character via sed
system("sh sed.sh")

# read entire file
test <- read_file("eol_1_short.dat")
test2 <- gsub("\\n", "", test)
test3 <- gsub("|^|", "\n", test2, fixed = TRUE)
