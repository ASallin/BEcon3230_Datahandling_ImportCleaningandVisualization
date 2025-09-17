# 1. Import a package for parsing
library(jsonlite)

# 2. Parse the JSON-document 
json_doc <- fromJSON("../../data/QUIZ_L5.json")

# 3. Explore the structure of the document. Use str() or any other command. 
# Must figure in the answer: json are imported as lists of lists (of lists...)
# In this case, we are lucky to have only one element in the main list, i.e. the
# element "students"
str(json_doc)

# 4. Extract first names
first_names <- json_doc$students$firstName

# 5. Extract grades and compute grades per student
grades <- json_doc$students$grades

gradesMean <- c()
for (i in 1:nrow(grades)){
  gradesMean[i] <- mean(as.numeric(grades[i, ]))
}

# 6. Create a data frame or a tibble
data.frame(first_names, gradesMean)
