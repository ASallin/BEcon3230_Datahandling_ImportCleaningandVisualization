
# Integers, numeric
a <- 1.5
b <- 3
c <- 3L

# Use math operators
a + b

typeof(a); class(a)


# Vectors
persons <- c("Andy", "Brian", "Isabelle")

# Concatenate  
paste(persons[1], "+", persons[3])    
paste(persons[1], "+", persons[3] , sep="")  
paste0(persons[1], "+", persons[3] , sep="") 

ages <- c(24, 50, 30)

is.character(persons)

y <- c(a = 1, 2, 3)
names(y)


# Coercion
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)


# Factors
gender <- factor(c("Male", "Male", "Female"))
gender
table(gender)


f1 <- factor(letters)
levels(f1) <- rev(levels(f1))


# Arrays
my_array <- array(c(1:4), dim = c(2,3,4))
my_array2 <- array(c(1:6), dim = c(2,3,4))
dim(my_array)
my_array + my_array2


# Data frames
df <- data.frame(
  person = persons, 
  age = ages, 
  gender = gender,
  stringsAsFactors = FALSE)

names(df)
colnames(df)
str(df)
df

df$gender


# lists
my_list <- list(my_array, 
                matriX = matrix(c(1,2,3,4,5,6), nrow = 3), 
                df
                )
length(my_list)
names(my_list)
my_list[[1]]
my_list$matriX
