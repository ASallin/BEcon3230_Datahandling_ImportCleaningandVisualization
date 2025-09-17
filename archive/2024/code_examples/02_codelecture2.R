# Variables
2+2 # CTRL AND ENTER
my_variable <- 10
class(my_variable)

my_integer <- 9L
class(my_integer)

my_character <- "aurelien"
class(my_character)

my_logical <- TRUE
class(my_logical)


# Vectors
vector_numeric <- c(1,2,3)
vector_numeric * 5
vector_numeric -10
length(vector_numeric)
vector_numeric[1]
vector_numeric[3]
vector_numeric[c(1,2)]

#Matrices
v1 <- c(1,2,3,4)
v2 <- c(10, 9, 8, 7)

m1 <- cbind(v1, v2) 
print(m1)
m1

m2 <- rbind(v1, v2)
m2

v3 <- c(2, 4, 6)
v4 <- c(10, 7)
cbind(v3, v4)

store_value1 <- 1
store_value2 <- 7

store_value1 == store_value2


# For-loops
n <- 20

for (i in c(2,4,6,8)){print(i)}

vector_loop <- c("brian", "mark", "sophia")

for(i in vector_loop){
  
  sentence <- paste(i, "likes icecream.")
  print(sentence)
}


# While loops
x <- 1

while(x <= 10){
  print("88")
  x <- x + 1
}

# Functionals

# Set a user-defined function
triple <- function(x) {
  y <- x * 3
  return(y)
}

triple(1)
triple(2)
triple(3)
triple(4)

# With lapply
t1 <- lapply(1:4, triple)
t1

library(purrr)
map_dbl(1:4, triple)
map(1:4, triple)

# apply
# Empty matrix with 2 rows and 4 columns
mymatrix <- matrix(c(1,2,3,11,12,13,1,10), 
                   nrow = 2, 
                   ncol = 4)
mymatrix

for (i in 1:2){
  s <- sum(mymatrix[i, ])
  print(s)
}

apply(mymatrix, MARGIN = 1, sum)

