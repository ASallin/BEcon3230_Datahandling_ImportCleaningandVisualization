#######################################
# Data Structures, Classes 
#
#######################################

# vectors
# numeric vector 
numeric_vector <- 10:20
a <- 1:3
names(a) <- c("element1", "b", "c")

# character vector (text strings)
b <- c("a", "z", "y")


# Lists
my_list <- list("a", 1)
my_list2 <- list(b, numeric_vector)
my_list3 <- list(vector_b = c(4,5,6), yx = c("b", "b"))


# Matrices and Data Frames

# matrices
matrix1 <- matrix(c(1,4,5,6), nrow = 2)

# data frames
df <- data.frame(age=c(20, 23, 50), id=c("a", "b", "c"))


# Classes and Data Structure 







# Load the Data (here provided with the basic R distribution)
data("swiss")

# 1) select the column containing the Fertility data

# 2) select the row describing the province of Moutier

# 3) select all observations which have a Fertility greater than 77 (see ?subset)

# 4) select all data on Infant.Mortality from provinces which are predominantly Catholic (see ?subset)



