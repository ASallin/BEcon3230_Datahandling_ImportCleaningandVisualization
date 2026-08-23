# Sum function

# 1. Name for the function
# 2. Arguments to be passed (formals())
# 3. Body: the code inside the function (body())


my_sum <- function(x){
  # initialize the total 
  total <- 0  # Here, we create a variable called total, and we set its value to 0.
  # This variable will store the sum of the numbers as we add them up.
  
  # for loop repeat the action for each element in the vector x 
  for (i in x){
    total <- total + i # update the value of total adding i
  }
  return(total)
}

numbers = c(1,2,3)

my_sum(numbers)


# Loop: Calculate the population of two kinds of sloths over time
# Return the first year in which the fast outnumber the first

# The while loop is a structure that keeps running as long as a specific condition is true.
# Condition: The loop will continue as long as there are more (or equal) slow sloths than fast sloths.

# initial population
slow_sloths <- 1000
fast_sloths <- 1

slow_death_rate <- 0.40
fast_death_rate <- 0.30 

# initialize what will be your final results (like total for the sum function)

year <- 1

# Loop until fast outnumber slow
while (slow_sloths >= fast_sloths) {
  # calculate the population after the first year data
  
  slow_sloths <- slow_sloths*2 *(1-slow_death_rate)
  fast_sloths <- fast_sloths*2 *(1-fast_death_rate)
  
  year <- year+1
  
}

# Rechecking the Condition: After updating the populations,
# the loop checks again whether the slow sloths still outnumber the fast sloths.
# If they do, the loop repeats. If not, the loop stops.

# Stopping the Loop: Eventually, because fast sloths have a lower death rate, 
# their population grows faster than the slow sloths. When the fast sloths finally 
# outnumber the slow sloths, the loop stops

print(year)

cat("The fast sloths outnumber the slow sloths in year:",
    year , "\n") # \n means the cursor is moving on the next line

# Alternative
print("The fast sloths outnumber the slow sloths in year:")
print(year)



# Additional example:
# Write it as a function

sloth_simulation <- function(slow_sloths, fast_sloths, slow_death_rate, fast_death_rate) {
  # Initialize year inside the function
  year <- 1
  
  # Loop until fast sloths outnumber slow sloths
  while (slow_sloths >= fast_sloths) {
    # Calculate the new population after births and deaths for slow sloths
    slow_sloths <- slow_sloths * 2 * (1 - slow_death_rate)
    
    # Calculate the new population after births and deaths for fast sloths
    fast_sloths <- fast_sloths * 2 * (1 - fast_death_rate)
    
    # Increment the year
    year <- year + 1
  }
  
  # Return the first year in which fast sloths outnumber slow sloths
  return(year)
}

# Example of calling the function
result <- sloth_simulation(slow_sloths = 1000, fast_sloths = 1, slow_death_rate = 0.4, fast_death_rate = 0.3)
result


# Comment:
# Use return() when you want to return a value from a function for later use.
# Use print() when you just want to display the value temporarily, mainly for debugging or testing purpos

