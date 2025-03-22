``` R
#read files
setwd("/share/crsp/lab/seyedam/share/bridge_dRNA")
casfm6a<- read.table("bedMethyl/castr2.m6a.filtered-4-5.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
castfm5c <- read.table("bedMethyl/castr2.m5c.filtered-4-5.bed", header= FALSE, sep= "\t", stringsAsFactors = FALSE)
colnames(casfm6a)= c('chrom', 'start', 'end', 'name', 'score', 'strand'
,'start1','end1','color','Nvc','Nm/Nvc', 'Nm','Nc','Nother','Ndel','Nfail','Ndiff','Nnocall')
colnames(castfm5c)= c('chrom', 'start', 'end', 'name', 'score', 'strand'
                     ,'start1','end1','color','Nvc','Nm/Nvc', 'Nm','Nc','Nother','Ndel','Nfail','Ndiff','Nnocall')
casm6amod <- casfm6a[,c("chrom","Nm")]
casm5cmod <- castfm5c[,c("chrom","Nm")]

b6m6a<- read.table("bedMethyl/b6r2.m6a.filtered-4-5.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
b6fm5c <- read.table("bedMethyl/b6r2.m5c.filtered-4-5.bed", header= FALSE, sep= "\t", stringsAsFactors = FALSE)
colnames(b6m6a)= c('chrom', 'start', 'end', 'name', 'score', 'strand'
                     ,'start1','end1','color','Nvc','Nm/Nvc', 'Nm','Nc','Nother','Ndel','Nfail','Ndiff','Nnocall')

colnames(b6fm5c)= c('chrom', 'start', 'end', 'name', 'score', 'strand'
                      ,'start1','end1','color','Nvc','Nm/Nvc', 'Nm','Nc','Nother','Ndel','Nfail','Ndiff','Nnocall')
b6m6amod<- b6m6a[,c("chrom","Nm")]
b6fm5cmod<- b6fm5c[,c("chrom","Nm")]

#add numerical order to chromosomes
chrom_mapping <- c(
  "chr1" = 1, "chr2" = 2, "chr3" = 3, "chr4" = 4, "chr5" = 5,
  "chr6" = 6, "chr7" = 7, "chr8" = 8, "chr9" = 9, "chr10" = 10,
  "chr11" = 11, "chr12" = 12, "chr13" = 13, "chr14" = 14, "chr15" = 15,
  "chr16" = 16, "chr17" = 17, "chr18" = 18, "chr19" = 19, "chr20" = 20,
  "chr21" = 21, "chr22" = 22, "chrX" = 23, "chrY" = 24
)
casm6a_summary$chrom_numeric <- chrom_mapping[casm6a_summary$chrom]
b6m6a_summary$chrom_numeric <- chrom_mapping[b6m6a_summary$chrom]

casm5c_summary$chrom_numeric <- chrom_mapping[casm5c_summary$chrom]
b6m5c_summary$chrom_numeric <- chrom_mapping[b6m5c_summary$chrom]
#summerize modifications into one row per chromosome and 
library(dplyr)
install.packages(dplyr)
casm6a_summary <- casm6amod %>%
  group_by(chrom) %>%
  summarise(total_modifications = sum(Nm, na.rm = TRUE))
casm6a_summary<- casm6a_summary[-c(15,21:24,26),] #eliminate unwanted chr
casm6a_sorted <- casm6a_summary[order(casm6a_summary$chrom_numeric),]

b6m6a_summary <- b6m6amod %>%
  group_by(chrom) %>%
  summarise(total_modifications = sum(Nm, na.rm = TRUE))
b6m6a_summary<- b6m6a_summary[-c(15,21:24,26),] #eliminate unwanted chr
b6m6a_sorted <- b6m6a_summary[order(b6m6a_summary$chrom_numeric),]

casm5c_summary <- casm5cmod %>%
  group_by(chrom) %>%
  summarise(total_modifications = sum(Nm, na.rm = TRUE))
casm5c_summary<- casm5c_summary[-c(15,21:24,26),] #eliminate unwanted chr
casm5c_sorted <- casm5c_summary[order(casm5c_summary$chrom_numeric),]

b6m5c_summary<- b6fm5cmod %>%
  group_by(chrom) %>%
  summarise(total_modifications = sum(Nm, na.rm = TRUE))
b6m5c_summary<- b6m5c_summary[-c(15,21:24,26),] #eliminate unwanted chr
b6m5c_sorted <- b6m5c_summary[order(b6m5c_summary$chrom_numeric),]
#create scatter plot of modifications
library(ggplot2)
#m6a plot
casm6a_sorted$dataset <- "CAST/EiJ"
b6m6a_sorted$dataset <- "C57BL/6J"
casm6acombined <- rbind(casm6a_sorted,b6m6a_sorted)
ggplot(casm6acombined, aes(x = chrom, y = total_modifications, color = dataset)) + 
  geom_point() +  # Scatter plot
  geom_smooth(method = "lm", se = FALSE, position="dodge") +  
  labs(title = "m6A modification comparison", 
       x = "Chromosome", 
       y = "number of Modifications") + 
  scale_color_manual(values = c("light green", "dark green")) +
  theme_minimal()+ theme(
    axis.text.x = element_text(angle = 90, hjust = 1))
#m5c plot
casm5c_sorted$dataset <- "CAST/EiJ"
b6m5c_sorted$dataset <- "C57BL/6J"
casm5ccombined <- rbind(casm5c_sorted,b6m5c_sorted)
ggplot(casm5ccombined, aes(x = chrom, y = total_modifications, color = dataset)) + 
  geom_point() +  # Scatter plot
  geom_smooth(method = "lm", se = FALSE, position="dodge") +  
  labs(title = "m5c modification comparison", 
       x = "Chromosome", 
       y = "number of Modifications") + 
  scale_color_manual(values = c("light green", "dark green")) +
  theme_minimal()+ theme(
    axis.text.x = element_text(angle = 90, hjust = 1))
```

