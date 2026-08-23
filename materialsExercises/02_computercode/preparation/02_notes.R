
# str()
# The str() function in R is used to give a compact display of the internal 
# structure of an R object. It tells you the type of data you're working with,
# the number of elements, and a preview of its contents.

# Why is this useful? Understanding the structure helps you know whether numbers
# and numbers2 are vectors, lists, data frames, or some other type of data. 
# It’s a quick way to check how your data is organised


# classes()

# The class() function in R returns the type (or "class") of an object.
# Classes in R define how an object behaves and what operations you can perform on it.
# Common classes include numeric, character, matrix, data frame, etc.

# This checks the class of the numbers object and stores it in the variable class_numbers.
# This does the same for numbers2 and stores the result in class_numbers

# str() helps you quickly understand the structure of your data. can also be used a substitution to summary()
# class() tells you the type of object you're working with (like numeric, character, data frame, etc.).


# On the apply family
# https://www.r-bloggers.com/2021/05/apply-family-in-r-apply-lapply-sapply-mapply-and-tapply/


# Tibble 
# A tibble is a modern version of a data frame in R, provided by the tibble
# package (part of the tidyverse collection of packages). It is designed to make
# data manipulation easier and more intuitive. Like data frames, tibbles can 
# store different types of data in each column, making them a great alternative 
# when you need to work with mixed data types.