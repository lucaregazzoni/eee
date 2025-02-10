# ----
# > 1 > Standardization
# > 1.1 Standardize inconsistent "names" (easy)

# Thomas and Peter manually sampled dry-weight from algae samples of the algae reactor
# Peter stuck to adding his name consistently in the same format, however, Thomas did not feel 
# the same way. Fix all entries of Thomas to make them consistent.

# Use this data with inconsinstently recorded names:
data <- data.frame(
  name = c("thomas", "Thomas", "Peter", "Peter", "THOMAS", "thoms", "thomas", "Peter", "Peter", "Tomas"),
  bin = c(10,9.7,9.9,10,10.2,10.3,9.3,9.7,10,9.85) # some random other data
) 


data %>%
    mutate(name_lc = str_to_lower(name),
        name_std = ifelse(grepl("^t", name_lc), "Thomas", name))

# ----
# > 1.2 Standardize a long list of names (difficult)
# Thomas merged his data with several different other people that
# all have been adding their data inconsistently. The data is too long
# to correct by hand! Find a way to change it programatically!

# Tipp: search/use "Fuzzy matching".

# Read in the non standardized names csv file
data <- read.delim("EEE_non_standardized_names.csv", sep=";", dec=".", head=TRUE)
data_st <- data # make a copy

# install.packages("stringdist")
library(stringdist)
library(stringr)
library(tidyverse)

# convert all string to lowercase
data_st$name <- str_to_lower(data_st$name)
# Compute string distance matrix
dist_matrix <- stringdistmatrix(data_st$name, data_st$name, method = "jw")  # Jaro-Winkler distance
# stringdistmatrix calculates how differnet the strings are to eachother
# check 'method = ...' to see all the different algorithms that can be used
# we're using the jaro-winkler distance because they are used to capture 
# phonetic similarity.

# Perform hierarchical clustering
hc <- hclust(as.dist(dist_matrix))

cutree(hc, h = 0.1)

data_st$name_groups <- cutree(hc, h = 0.15)  # 0.2 is an arbitrary threshold; adjust as needed

# Assign a representative name to each cluster
data <- data_st %>%
  group_by(name_groups) %>%
  mutate(name_standardized = first(name)) %>%
  ungroup()

# check if the names were correctly clustered:
data[,1:4]
unique(data$name_standardized)
# not too bad, however if the result is correct or not
# can only be known if we know which people are expected in 
# the list of names (which we dont have). 

# ----
# > 1.3 Standardization (medium)
# Peter and Thomas have recorded their names correctly this time, however 
# they copy and pasted price-values with various wierd formats, that need to be
# corrected. We want correctly parsed numbers, decimal points and 
# thousand seperators the be removed. We know that the correct result
# should be approximately 1234.

# Use this data with inconsistent numeric formats
data <- data.frame(
  name = c("Peter", "Thomas", "Peter", "Peter", "Thomas", "Thomas", "Peter", "Thomas", "Thomas", "Peter"),
  value = c("CHF 1,234.56", "1234,56", "1 234.56", "CHF 1.234,56", "1,234", 
                 "1234", "1234.56", "1 234,56", "1.234,5", "1,234.5")
  # notice that they are strings (or characters), since R wouldn't understand that these
  # are actually numbers
)

# Since we have commas as thousand separators and decimals points
# we need to find a way to change only the 'last' comma in the number
data$value
data$value_cor <- data %>%
  mutate(value = sub(" ", "", value), # remove all spaces
        value = sub("CHF", "", value), # we don't need CHF
        value = sub("1,", "1", value), # we don't need commas after the 1
        value = sub("1\\.", "1", value),
        # we don't need points after the 1 (notice that just writing
        # 1. will match all characters after the 1 with regex,
        # that's why a literal use of . with \\ is required)
        value = sub(",", ".", value), # and finally we can change all ,
        value = as.numeric(value)) %>%
        select(value)

data

# This is not a very beatiful solution (programatically) but it works.
# What would we do when we didn't have such easy
# data like this? E.g. when 1 wouldn't always be 
# the first character? 

# ----
# > 2 > Duplicates
# > 2.1 Removing duplicates in a vector of names (easy)
# Peter has filled out a questionnaire twice. Since,
# this is often unwanted we want to remove his entry from 
# our data. 

# Tipp: look at the distinct() function from the dplyr package

# Data:
data <- data.frame(
  id = c(1,2,3,4,1),
  Name = c("Peter", "John", "Sepp", "Fredi", "Peter"),
  Age = c(25, 30, 25, 35, 25)
)

library(dplyr)
data %>%
  distinct(Name, .keep_all = TRUE)

# > 2.2 Removing duplicates (medium)
# In the following data, duplicated time stamps were 
# collected but they have different dissolved oxygen concentration
# values. We decide that we want to average the concentration values,
# since the results works best for our application

# Tipp: we want to group the data by time stamp and calculate the 
#   average for each group.

# Read in the data
data <- read.delim("EEE_time_series.csv", head=TRUE, sep=";")

length(unique(data$datetime)) # 97 unique data points = 3 duplicates
# we can check which of the data points are duplicates:
duplicates <- data.frame(table(data$datetime))
duplicates[duplicates$Freq > 1,] # which rows are occuring more than once

data %>% 
  group_by(datetime) %>% # group values by timestamp
  summarize(do_m = mean(dissolved_oxygen))

# > 3 > Missing data
# > 3.1 Imputate using a forward fill (easy)
# Use the time series data frame from exercise 2.2
# and impute the missing data using a forward fill

# Read in the data (if not done already)
data <- read.delim("EEE_time_series.csv", head=TRUE, sep=";")

library(zoo)
library(tidyverse)
data$do_forward_fill <- na.locf(data$dissolved_oxygen)

# > 3.2 Imputate using a linear interpolation (easy)
# Use the time series data frame from exercise 2.2
# and impute the missing data using linear interpolation

data$do_lin_interpolation <- na.approx(data$dissolved_oxygen)

# we won't see a big difference between the original data
# and the linear interpolated one, because R/ggplot connects
# adjacent data point of a NA with each other...

# > 3.3 Imputate using an rolling mean (medium)
# Use the time series data frame from exercise 2.2
# and impute the missing data using a rolling mean

# we rollapply over the data with a width if 5 data points
do_roll_mean <- rollapply(data$dissolved_oxygen, width = 5, 
                  FUN = mean, fill = NA, 
                  align = "right", na.rm = TRUE) 

# we substitute NAs from the original data with our
# roll mean data (but only the NAs!)
data$do_roll_mean <- ifelse(is.na(data$dissolved_oxygen), 
    do_roll_mean, data$dissolved_oxygen)

# > 3.4 Plot the data to visualize the different
#   imputation methods

data %>%
  # change the time stamp format to get propper labels
  mutate(datetime = as.POSIXct(datetime, format = "%d.%m.%Y %H:%M")) %>%
  # change data to long format (to have all imputations in one column)
  pivot_longer(cols = dissolved_oxygen:do_roll_mean, 
               names_to = "parameter", values_to = "values") %>%
  na.omit(dissolved_oxygen) %>%
  ggplot(aes(datetime, values, color = parameter, group = parameter)) +
    geom_line(alpha = 0.5) +
    geom_point() + 
    theme_classic()