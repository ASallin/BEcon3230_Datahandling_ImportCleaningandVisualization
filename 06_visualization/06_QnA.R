# Functions ----------------------

# basic structure
myfunction <- function(x) { }




# simple example
myfunction <- function(x, y) {
  
  z <- x + y
  
  return(z)
  
  } 

# try it out
myfunction(5,7)

myfunction(x = 5, y = 7)


# change it
myfunction <- function(x, y) {
  
  z <- (x + y)*5
  
  return(z)
  
} 

# try it out
myfunction(5,7)



# Exercise E: T-test ---------------
# Sample Solution

my_ttest <- function(x, mu) {
  x_bar <- mean(x) # or use my_mean(x) here
  s <-  sd(x) # or use my_sd(x) here
  n <- length(x)
  se <- s / sqrt(n) 
  
  t <- (x_bar - mu) / se
  
  return(t)
}


# test it !!
numeric_vector <- c(1,5,4,3)

my_ttest(x = numeric_vector, mu = 3 )

# compare it with the built-in function 
t.test(x = numeric_vector, mu = 3 )
