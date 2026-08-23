##########################################################################
# Mean Function:
# Computes the mean, given a
# numeric vector.
# x, a numeric vector
# returns the arithmetic mean of x (a numeric scalar)
#
# Example:
# a integer vector, for which we want to compute the mean
# a <- c(5.5, 7.5)
# desired functionality and output:
# my_mean(a)
# 6.5
#
##########################################################################


my_mean <- function(x) {

  if (!is.numeric(x)) {

    warning("x is not numeric! Force x to numeric.\n")

    x <- as.numeric(x)
  }
  
  N <- length(x)
  meanx <- (1/N) * sum(x)
  
  # Return function
  return(meanx)
}
