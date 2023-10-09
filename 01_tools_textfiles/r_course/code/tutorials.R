#################################################################################################㐂
##### Example solution for tutorials from lecture 2                                           #####
#################################################################################################㐂


##### Part 1 - function for the mean #####

# To set up a function of to compute the mean for a vector x, we just divide the sum by the 
# number of elements
meaN <- function(x){
  
  mean <- (sum(x)/length(x))
  
  return(mean)
  
}

testvector <- c(1,2,3,4) # note: we could also write c(1:4), that would give the same output

meaN(testvector)

# BONUS: what if we have missing elements?
testvector_w_missings <- c(1,2,3,4,NA) # 'NA' denotes a missing value in R

meaN(testvector_w_missings)

# This is a frequent problem, which is why the built-in mean function in R allows for removal of 
# missing elements with the 'na.rm = TRUE' argument

mean(testvector_w_missings)
mean(testvector_w_missings, na.rm = TRUE)

# We could do the same by amending our function:
meaN_NA <- function(x, na.rm = FALSE){
  
  if (na.rm == TRUE) {
    x <- na.omit(x)
  }
  
  mean <- (sum(x)/length(x))
  
  return(mean)
  
}

meaN_NA(testvector_w_missings)
meaN_NA(testvector_w_missings, na.rm = TRUE)


##### Part 2 - slow and fast sloths #####

# Each year, each sloth has one offspring. There are no further mutations, so slow sloths beget slow sloths, 
# and fast sloths beget fast sloths. Also, each year 40% of all slow sloths die each year, while only 30% of 
# the fast sloths do.

# So, at the beginning of year one there are 1000 slow sloths. Another 1000 slow sloths are born. But, 40% of 
# these 2000 slow sloths die, leaving a total of 1200 at the end of year one. Meanwhile, in the same year, we begin 
# with 1 fast sloth, 1 more is born, and 30% of these die, leaving 1.4. 

# Since we are statisticians and not biologists, having 'partial sloths' or the fact that the fast sloth can 
# initially reproduce without a mate (although he/she could fancy a slow one, raising the question of the nature of 
# the offspring...) leaves us completely unfazed.

# For this problem, we first need to define the initial values

i     <- 1    # indicator for year - we start at beginning of year one
Nslow <- 1000 # initial number of fast sloths
Nfast <- 1    # initial number of fast sloths

# We want to find out in which year the number of fast sloths exceeds the number of slow ones, but don't know
# how many years this will take. This is an example where a while loop can come in handy

while(Nslow > Nfast){

  Nslow <- (Nslow * 2) * 0.6  # Each year slow sloths double, but 40% die, hence 60% survive
  Nfast <- (Nfast * 2) * 0.7  # Each year fast sloths double, but 30% die, hence 70% survive
  
  i <- i + 1               # having computed the end-of-year tallies, we increase the year indicator by one and start over
}

print(i) # this is the first year fast sloths outnumber slow ones

# Checking that this is indeed correct by computing the populations for the first 48 years in a for loop
Nslow <- 1000
Nfast <- 1
for (i in 1:48){
  
  Nslow <- c(Nslow, (Nslow[i] * 2) * 0.6)
  Nfast <- c(Nfast, (Nfast[i] * 2) * 0.7)
  
  print(i) 
}

# Year 45
Nslow[45]
Nfast[45]

# Year 46
Nslow[46]
Nfast[46]


##### Part 3 - getting loopier #####

# Create a function that repeatedly appends the sum of the current last three elements of the vector lst to lst. 
# Your function should loop 25 times. 

?append
?tail

appendsums <- function(lst){
  
  for (i in 1:25){ # note that we can iterate over 'i', or any other character for that matter, without it being in the loop
    lst <- append(lst, sum(tail(lst, 3))) # this is a bit complicated to read - we will learn how to improve this later on!
    
    # note that using c() as in 'c(lst, sum(tail(lst, 3)))' instead of append also works in the present case
    
  }
  
  return(lst)
}

sum_three = c(0, 1, 2)
sum_three <- appendsums(sum_three)

sum_three

# Solution for testing - this should yield 125
sum_three[10] == 125 # the '==' performs a logical check, and will return TRUE if the statement holds, and FALSE otherwise

