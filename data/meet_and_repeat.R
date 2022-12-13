library(dplyr)
library(tidyr)

#1. Load the data sets (BPRS and RATS) into R using as the source the GitHub repository of MABS, where they are given in the wide form:
  
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
# As before, write the wrangled data sets to files in your IODS-project data-folder.

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)


# Also, take a look at the data sets: check their variable names, view the data contents and structures, and create some brief summaries of the variables , so that you understand the point of the wide form data. (1 point)
str(BPRS)
summary(BPRS)

# 2. Convert the categorical variables of both data sets to factors. (1 point)
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. (1 point)
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks, 5, 6)))
BPRSL <- BPRSL[,c("treatment", "subject", "bprs", "week")] 

str(BPRSL)
dim(BPRSL)
summary(BPRSL)
glimpse(BPRSL)

# RATS
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

str(RATS)
summary(RATS)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)
RATSL <- RATSL[, c("ID", "Group", "weight", "Time")]

str(RATSL)
dim(RATSL)
summary(RATSL)
glimpse(RATSL)

# 4. Now, take a serious look at the new data sets and compare them with their wide form versions: Check the variable names, view the data contents and structures, and create some brief summaries of the variables. Make sure that you understand the point of the long form data and the crucial difference between the wide and the long forms before proceeding the to Analysis exercise. (2 points)

# Summa summarum, the wide (original) format has some data points in variable
# names (week1, week2, etc...) while in the long format all that has been moved
# to the data itself.

write_csv(RATSL, "data/rats.csv")
write_csv(BPRSL, "data/bprs.csv")

