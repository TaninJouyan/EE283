install.packages('tidyverse')
library(tidyverse)

	
setwd('/home/jovyan/pub/ee283/data')
mal = read_tsv("allhaps.malathion.200kb.txt.gz")

library(dplyr)
library(stringr)
library(broom)
library(purrr)

# Assuming 'mal' is your original dataset
mal2 <- mal %>% filter(chr == "chrX" & pos == 316075)
print(mal2)

# Check levels of factors
print(levels(factor(mal2$pool)))
print(levels(factor(mal2$founder)))

# Create 'treat' column
mal2 <- mal2 %>% mutate(treat = str_sub(pool, 2, 2))

# ANOVA model
out <- anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data = mal2))
print(out)

# Calculate myF
myF <- -pf(out[1, 4], out[1, 1], out[4, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
print(paste("myF:", myF))

# Define mylog10pmodel function
mylog10pmodel <- function(df) {
  out <- anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data = df))
  -pf(out[1, 4], out[1, 1], out[4, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
}

# Create malathion dataset
malathion <- do.call(rbind, replicate(4, mal2, simplify = FALSE))
malathion$chr <- rep("X", nrow(malathion))
malathion$pos <- rep(1:4, each = nrow(mal2))

# Group and nest data
myresult <- malathion %>%
  group_by(chr, pos) %>%
  nest() %>%
  mutate(logp = map_dbl(data, mylog10pmodel)) %>%
  select(-data)

print(myresult)
_________________________________________
#Net effect of treatment==0

# Assuming 'mal' is your original dataset
mal2_2 <- mal %>% filter(chr == "chrX" & pos == 316075)
print(mal2_2)

# Check levels of factors
print(levels(factor(mal2_2$pool)))
print(levels(factor(mal2_2$founder)))

# Create 'treat' column
mal2_2 <- mal2_2 %>% mutate(treat = str_sub(pool, 2, 2))

# ANOVA model with the new formula
out_2 <- anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data = mal2_2))
print(out_2)

# Calculate myF_2
myF_2 <- -pf(out_2[2, 4], out_2[2, 1], out_2[3, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
print(paste("myF_2:", myF_2))

# Define mylog10pmodel_2 function
mylog10pmodel_2 <- function(df) {
  out <- anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data = df))
  -pf(out[2, 4], out[2, 1], out[3, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
}

# Create malathion_2 dataset
malathion_2 <- do.call(rbind, replicate(4, mal2_2, simplify = FALSE))
malathion_2$chr <- rep("X", nrow(malathion_2))
malathion_2$pos <- rep(1:4, each = nrow(mal2_2))

# Group and nest data
myresult_2 <- malathion_2 %>%
  group_by(chr, pos) %>%
  nest() %>%
  mutate(logp = map_dbl(data, mylog10pmodel_2)) %>%
  select(-data)

print(myresult_2)

#Merge result dataframes
join1= full_join(myresult, myresult_2, by=c('chr','pos'))
join1
