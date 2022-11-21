# Ville Vaara
# 21.11.2022
# Merging script for data downloaded from https://archive.ics.uci.edu/ml/machine-learning-databases/00320/

library(readr)
library(dplyr)

# read data
smat <- read_delim(file = 'data/student-mat.csv', delim = ";")
spor <- read_delim('data/student-por.csv', delim = ";")

str(smat)
str(spor)
dim(smat)
dim(spor)

# join tables
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")
join_cols <- setdiff(colnames(spor), free_cols)
math_por <- inner_join(smat, spor, by = join_cols, suffix=c('.math', '.por'))

colnames(math_por)
glimpse(math_por)

# discard duplicated data
alc <- select(math_por, all_of(join_cols))

for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

glimpse(alc)

# add mean alc_use statistics and boolean high_use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

write_csv(alc, 'data/alc.csv')
