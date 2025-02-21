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


# > 1.2 Standardize a long list of names (difficult)
# Thomas merged his data with several different other people that
# all have been adding their data inconsistently. The data is too long
# to correct by hand! Find a way to change it programatically!
# Use data data set: EEE_non_standardized_names.csv (on moodle)

# Tipp: search/use "Fuzzy matching".


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


# > 2.2 Removing duplicates (medium)
# In the excel file "EEE_time_series.csv", duplicated time stamps were 
# collected but they have different dissolved oxygen concentration
# values. We decide that we want to average the concentration values,
# since the results works best for our application

# Tipp: we want to group the data by time stamp and calculate the 
#   average for each group.



# ----
# > 3 > Missing data
# > 3.1 Imputate using a forward fill (easy)
# Use the time series data frame from exercise 2.2
# and impute the missing data using a forward fill


# > 3.2 Imputate using a linear interpolation (easy)
# Use the time series data frame from exercise 2.2
# and impute the missing data using linear interpolation


# > 3.3 Imputate using an rolling mean (medium)
# Use the time series data frame from exercise 2.2
# and impute the missing data using a rolling mean


# > 3.4 Plot the data to visualize the different
#   imputation methods
