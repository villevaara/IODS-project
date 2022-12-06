# Ville Vaara
# 4.12.2022
# Script to create HDI dataset

library(stringr)

data_url <- "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt"

# Load the ‘human’ data into R. Explore the structure and the dimensions of the data and describe the dataset briefly, assuming the reader has no previous knowledge of it (this is now close to the reality, since you have named the variables yourself). (0-1 point)
data <- read.table(data_url, sep=",", header=TRUE)

str(data)
dim(data)

# The data has 195 rows with 19 values. It is based on UN human developemnt index dataset described at
# https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

# Mutate the data: transform the Gross National Income (GNI) variable to numeric (using string manipulation). Note that the mutation of 'human' was NOT done in the Exercise Set. (1 point)
data$GNI <- data$GNI %>% str_replace(",", "") %>% as.numeric()

# Exclude unneeded variables: keep only the columns matching the following variable names (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)
data <- data[c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")]

# Remove all rows with missing values (1 point).
data <- data[complete.cases(data),]

# Remove the observations which relate to regions instead of countries. (1 point)
data <- data[!(data$Country %in% c("Arab States", "East Asia and the Pacific", "Europe and Central Asia", "Latin America and the Caribbean", "South Asia", "Sub-Saharan Africa", "World")),]
# Dunno if there was a neater way to do that- There doesn't seem to be a variable for Region.

# Define the row names of the data by the country names and remove the country name column from the data. The data should now have 155 observations and 8 variables. Save the human data in your data folder including the row names. You can overwrite your old ‘human’ data. (1 point)
row.names(data) <- data$Country
data <- data[colnames(data)[colnames(data) != "Country"]]

write.csv(data, "data/human.csv", col.names = FALSE)
