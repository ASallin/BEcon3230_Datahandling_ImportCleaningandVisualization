#===============================================================================#
#===============================================================================#
# #
# Real data exercises
# #
# Autor: Aurélien Sallin
# Datum: XX.XX.XX #
# #
#===============================================================================#
#===============================================================================#

# Import packages
library(tidyverse)
library(jsonlite)


# Explore both data set
kons <- fromJSON("H:/Blog_KongressBerlin/KONS.json")  %>% 
    as_tibble()  %>% 
    mutate(B003_ALTERSG = AGE_GROUP)
stamm <- read_delim(file = "H:/Blog_KongressBerlin/stamm_data.csv" )  %>% 
    mutate(age_group = SWICAtoolsVFO::aggregate_agegroups(age_group))  %>% 
    as_tibble()

count(stamm, age_group)
count(kons, AGE_GROUP)


# 1. Import the datasets. Tell a story about each data. 

# These data are SWICA Patients for years 2020 to 2021 in the mandatory health insurance. It is 
# standard that one dataframe contains the number of clients, and other dataset contains 
# clients with claims, i.e. patients who went to the doctor. 

# 1. Explore the dataset with the clients "stamm". Explain the JAHRESFRANCHISE variable. Recode accordingly.
stamm

# Since those are real data, check the distribution of franchise. Check for adults
stamm <- stamm  %>% 
    mutate(JAHRESFRANCHISE = ifelse(age_group %in% "0-18", JAHRESFRANCHISE_K, JAHRESFRANCHISE_E))

stamm  %>% 
    filter(age_group != "0-18")  %>% 
    ggplot(aes(x = as.factor(JAHRESFRANCHISE))) +
        geom_histogram(stat = "count") +
        facet_wrap(JAHR_STA ~. )

stamm  %>% 
    filter(age_group != "0-18")  %>%
    mutate(ageP = as.numeric(str_sub(age_group, 1, 2)))  %>% 
    group_by(JAHRESFRANCHISE, JAHR_STA)  %>% 
    summarise(meanA = mean(ageP))  %>% 
    ggplot(aes(x = as.factor(JAHRESFRANCHISE), y = meanA, 
                color = as.factor(JAHR_STA),
                group = as.factor(JAHR_STA))) +
        geom_point() +
        geom_line() +
        facet_wrap(JAHR_STA ~. ) +
        theme_classic()


# Kons: number of consultations and costs
# Get some summary statistics about your dataset. What is the relationship 
# between age and costs, and gender and costs? 
# What is the most frequent provider of consultations

kons  %>% 
    group_by(JAHR, AGE_GROUP)  %>% 
    summarise(min = min(PLE_KOSTEN),
              mean = mean(PLE_KOSTEN),
              max = max(PLE_KOSTEN))  %>% 
    ggplot(aes(x = AGE_GROUP, y = mean)) +
    geom_point()



# Merge
stamm  %>% count(age_group)
kons  %>% count(AGE_GROUP)

kons <- kons  %>% 
    mutate(AGE_GROUP = ageAggregate(AGE_GROUP))


# Create a function for group age 
ageAggregate <- function(age_variable) {
    age_variable <- case_when(age_variable == "0-18" ~ "0-18", 
                                age_variable == "19-25" ~ "19-25", 
                                age_variable == "26-30" | age_variable == "31-35" ~ "26-35", 
                                age_variable == "36-40" | age_variable == "41-45" ~ "36-45", 
                                age_variable == "46-50" | age_variable == "51-55" ~ "46-55", 
                                age_variable == "56-60" | age_variable == "61-65" ~ "56-65", 
                                age_variable == "66-70" | age_variable == "71-75" ~ "66-75", 
                                TRUE ~ "76-")
    age_variable <- factor(age_variable, levels = c("0-18", "19-25", "26-35", "36-45", "46-55", "56-65", "66-75", "76-"))
    return(age_variable)
}

count(kons, AA_TYPE)
stamm <- stamm  %>% 
    group_by(JAHR_STA, KANTON, B003_GESCHLECHT_KBEZ, age_group)  %>% 
    summarise(ANZAHL_VERS_MONATE = sum(ANZAHL_VERS_MONATE),
              ANZAHL_VERS = sum(ANZAHL_VERS, na.rm = T))

kons <- kons  |>
    filter(AA_TYPE == "Psychiatrie und Psychotherapie") 
    
df <- left_join(stamm, kons, by = c("JAHR_STA" = "JAHR",
                              "KANTON" = "KANTON_PAT",
                              "B003_GESCHLECHT_KBEZ",
                              "age_group" = "AGE_GROUP"))   

# Compute the number of consultations adjusted by the number of months
df <- df  %>% 
    mutate(KONS_MONAT = ANZAHL_KONS / ANZAHL_VERS_MONATE) 

# Give some summary stats per year
df  %>% 
    group_by(JAHR_STA)  %>% 
    summarise(mean(KONS_MONAT, na.rm = T),
              min(KONS_MONAT, na.rm = T),
              max(KONS_MONAT, na.rm = T))   

# Give some summary stats per age group. Where is the group with the most increase in number of consultations?
df  %>% 
    group_by(JAHR_STA, age_group)  %>% 
    summarise(mean(KONS_MONAT, na.rm = T),
              min(KONS_MONAT, na.rm = T),
              max(KONS_MONAT, na.rm = T))                               

df  %>% 
    group_by(JAHR_STA, age_group)  %>% 
    summarise(mean = mean(KONS_MONAT, na.rm = T),
              min(KONS_MONAT, na.rm = T),
              max(KONS_MONAT, na.rm = T))   %>% 
    ggplot(aes(x = age_group, y = mean, fill = JAHR_STA)) +
        geom_bar(stat="identity")                             

# Does this vary also with gender?

# For the canton of Zürich, estimate the costs 

# Check changes across years