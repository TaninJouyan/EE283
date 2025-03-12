#install.packages('tidyverse')
library(tidyverse)


setwd('/home/jovyan/pub/ee283/data')
mal = read_tsv("allhaps.malathion.200kb.txt.gz")

# Assuming 'mal' is your original dataset
mal2 <- mal %>% filter(chr == "chrX" & pos == 316075)
print(mal2)


# Check levels of factors
print(levels(factor(mal2$pool)))
print(levels(factor(mal2$founder)))

# Create 'treat' column 
mal2 <- mal %>% mutate(treat = str_sub(pool, 2, 2)) 

print(mal2)
library(dplyr)

# ANOVA model
#out <- anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data = mal2))
#print(out)

# Calculate F distribution
#myF <- -pf(out[1, 4], out[1, 1], out[4, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
#print(paste("myF:", myF))

# Define mylog10pmodel function
mylog10pmodel <- function(df) {
  if (any(is.na(df$freq))) {
    return(0)
  }
  out <- anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data = df))
  -pf(out[1, 4], out[1, 1], out[4, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
}

#Define mylog10model_2 (ANOVA model absed on net effect of treatment ==0)
mylog10pmodel_2 <- function(df) {
    if (any(is.na(df$freq))) {
      return(0)
    }
    out2 <- anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data = df))
  -pf(out2[1, 3], out2[1, 1], out2[3, 1], lower.tail = FALSE, log.p = TRUE) / log(10)
  }

# Group and nest data for both models
result <- mal2 %>%
  group_by(chr, pos) %>%
  nest() %>%
  mutate(logp = map_dbl(data, mylog10pmodel)) %>%
  select(-data)
print(result)
write_tsv(result,'anova_model1_result')
result_2 <- mal2 %>%
  group_by(chr, pos) %>%
  nest() %>%
  mutate(logp = map_dbl(data, mylog10pmodel_2)) %>%
  select(-data)


print(result_2)
write_tsv(result_2,'anova_model2_result')
________________________________________

#Merge result dataframes
merged_result= merge(result, result_2, suffix=c('chr','pos'))
join
