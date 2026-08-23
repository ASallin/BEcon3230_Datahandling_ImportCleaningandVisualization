# Exercise on missing values
# Lecture 9 - Data Handling
# Author: Aurélien Sallin, 2024

data <- data.frame(
  Gender = c("Male", "Female", "Male", "Female", "Male", "Female"),
  Participation = c(1, 0, 1, NA, 0, 1),
  Age = c(30, NA, 35, 28, 40, NA)
)

data

# Complete case analysis
complete_case <- na.omit(data)

# Mean imputation for missing Age
mean_impute <- data |> 
  mutate(Age = ifelse(is.na(Age), mean(Age, na.rm = TRUE), Age)) |> 
  mutate(Participation = ifelse(is.na(Participation), mean(Participation, na.rm = TRUE), Participation)) 

# Analyze mean age by gender
data %>%
  group_by(Gender) %>%
  summarize(
    Mean_Age = mean(Age, na.rm = TRUE),
    Participation_Rate = mean(Participation, na.rm = TRUE)
  )

complete_case %>%
  group_by(Gender) %>%
  summarize(
    Mean_Age = mean(Age, na.rm = TRUE),
    Participation_Rate = mean(Participation, na.rm = TRUE)
  )

mean_impute %>%
  group_by(Gender) %>%
  summarize(
    Mean_Age = mean(Age, na.rm = TRUE),
    Participation_Rate = mean(Participation, na.rm = TRUE)
  )