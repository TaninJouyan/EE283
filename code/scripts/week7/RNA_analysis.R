library(tidyverse)

#Import the metadata
RNAtab=read_tsv('/home/jovyan/pub/ee283/data/raw/RNAseq_samplecode.txt')
colnames(RNAtab)=c('SampleNumber','Multiplexi5index', 'Lane', 'i7index', 'PlateName', 'PlateRow', 'PlateColumn', 'PlateWell', 'RILcode', 'TissueCode', 'Replicate', 'FullSampleName')

RNAtab2 <- RNAtab %>%
  select(RILcode, TissueCode, Replicate, FullSampleName)	
table(RNAtab2$RILcode)
table(RNAtab2$TissueCode)
table(RNAtab2$Replicate)
# Check if both RILcode = 21148 and TissueCode = "b" are present
any(RNAtab$RILcode == 21148 & RNAtab2$TissueCode == "B")

#Subset the needed columns
RNAtab2 <- RNAtab %>%
  select(RILcode, TissueCode, Replicate) %>%
  filter(RILcode %in% c(21148, 21286, 22162, 21297, 21029, 22052, 22031, 21293, 22378, 22390)) %>%
  filter(TissueCode %in% c("B", "E")) %>%
  filter(Replicate == "0")
RNAtab2
missing_row<- data.frame(RILcode = 21148, 
                            TissueCode = "B", 
                            Replicate = "0")
RNAtab2<- rbind(RNAtab2,missing_row)
for(i in 1:nrow(RNAtab2)){
  cat("RNAseq/bam/",RNAtab2$RILcode[i],"_",RNAtab2$TissueCode[i],".sort.bam\n",file="shortRNAseq.names.txt",append=TRUE,sep='')
}
write_tsv(RNAtab2,"shortRNAseq.txt")

#if (!require("BiocManager", quietly = TRUE))
  #install.packages("BiocManager")

#BiocManager::install("DESeq2")
library('DESeq2')
#sampleInfo=read.table('shortRNAseq.txt',header=TRUE)
sampleInfo = RNAtab2
sampleInfo<- sampleInfo %>% mutate(BamFile=paste('X',RILcode,'_',TissueCode,'.sort.bam',sep=''))
sampleInfo$BamFile = as.character(sampleInfo$BamFile)
sampleInfo <- sampleInfo %>% select(order(names(sampleInfo)))
#Import the FeatureCount Data
countdata = read.table("/home/jovyan/pub/ee283/data/processed/RNAseq/bams/fly_counts.txt", header=TRUE, row.names=1)
# Remove first five columns (chr, start, end, strand, length)
countdata = countdata[ ,6:ncol(countdata)]


temp = colnames(countdata)
temp = gsub("RNAseq.bam.","",temp)
temp = gsub(".bam","",temp)
colnames(countdata) = temp

##  does everything match up...
cbind(temp,sampleInfo$BamFile,temp == sampleInfo$BamFile)

# create DEseq2 object & run DEseq
dds = DESeqDataSetFromMatrix(countData=countdata, colData=sampleInfo, design=~TissueCode)
dds <- DESeq(dds)
res <- results( dds )
res
#Create MA plot
ma_data <- as.data.frame(res)
ma_data$Gene <- rownames(ma_data)
MAplot<-ggplot(ma_data, aes(x = log2FoldChange, y = -log10(pvalue))) +
  geom_point(alpha = 0.5, size = 1) +  # Scatter plot
  geom_hline(yintercept = -log10(0.05), color = "red", linetype = "dashed") +  # p-value threshold line
  labs(title = "MA Plot of Differential Expression",
       x = "Log2 Fold Change",
       y = "-Log10 p-value") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  coord_cartesian(ylim = c(0, 1))
print(MAplot)
MAplot<-plotMA( res, ylim = c(-1, 1), main = "MA Plot of Differential Expression" )

#Create Dispersion Plot
dispersion<-plotDispEsts( dds,  main = "Dispersion Estimates" )
#Create p-value histogram
pvalues <- res$pvalue  # Extract p-values from the results

# Create the histogram using ggplot2
histogram<-ggplot(data.frame(pvalue = pvalues), aes(x = pvalue)) +
  geom_histogram(bins = 20, fill = "pink", color = "black") +  # Histogram with pink bars and black borders
  labs(title = "Histogram of p-values", 
       x = "p-value", 
       y = "Frequency") +
  theme_minimal()

print(histogram)
hist( res$pvalue, breaks=20, col="pink",  main="Histogram of p-values",   
      xlab="p-value",  )


###  add external annotation to "gene ids"
# log transform
rld = rlog( dds )
## this is where you could just extract the log transformed normalized data for each sample ID, and then roll your own analysis
head( assay(rld) )
mydata = assay(rld)

sampleDists = dist( t( assay(rld) ) )
# heat map
sampleDistMatrix = as.matrix( sampleDists )
rownames(sampleDistMatrix) = rld$TissueCode
colnames(sampleDistMatrix) = NULL
library( "gplots" )
library( "RColorBrewer" )
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
#Create heatmap from distribution matrix 
heatmap.2( sampleDistMatrix, trace="none", col=colours)

library(ggplot2)
library(reshape2)  # or tidyr

# Example data (replace this with your actual data)
# sampleDistMatrix should be a distance matrix or similar.
sampleDistMatrix <- as.matrix(dist(iris[, -5]))  # Example: using iris dataset

# Convert the distance matrix to a data frame
melted_data <- melt(sampleDistMatrix)

# Create the ggplot heatmap
heatmap<-ggplot(melted_data, aes(Var1, Var2, fill = value)) +
  geom_tile() +  # Create heatmap tiles
  scale_fill_gradient(low = "white", high = "blue") +  # Customize the colors
  labs(x = "Samples", y = "Samples", title = "Heatmap of Sample Distances") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels if necessary

#Create PCA plot 
pca_data<- plotPCA( rld, intgroup = "TissueCode") 
pca_plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = TissueCode)) +
  geom_point(size = 3) +  # Scatter plot of points
  labs(
    title = "PCA Plot of Gene Expression",  # Title of the plot
    x = "Principal Component 1",            # X-axis label
    y = "Principal Component 2"             # Y-axis label
  ) +
  theme_minimal() +  # Clean theme for the plot
  scale_color_manual(values = c("red", "blue", "green", "purple"))
print(pca_plot)

# Create heat map with gene clustering

library( "genefilter" )
topVarGenes <- head( order( rowVars( assay(rld) ), decreasing=TRUE ), 35 )
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 35)

# Extract the expression values for the top variable genes
topVarData <- assay(rld)[topVarGenes, ]

# Convert the data to a long format for ggplot
topVarData_long <- as.data.frame(topVarData)
topVarData_long$Gene <- rownames(topVarData_long)
topVarData_long <- pivot_longer(topVarData_long, 
                                cols = -Gene, 
                                names_to = "Sample", 
                                values_to = "Expression")

# Plot the heatmap using ggplot2
geneCluster<-ggplot(topVarData_long, aes(x = Gene, y = Sample, fill = Expression)) +
  geom_tile() +
  scale_fill_gradientn(colors = rev(brewer.pal(9, "RdBu"))) +  # Custom color palette
  theme_minimal() +
  labs(title = "Heatmap of Top Variable Genes", 
       x = "Samples", 
       y = "Genes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.text.y = element_text(size = 8))
print(geneCluster)

library(patchwork)

PR1<- geneCluster
PR2<- histogram
PR3<- MAplot
PR4<- heatmap

grid1 <- (PR2 / PR3) | (PR1 / PR4) +
  plot_layout(widths = c(1, 2)) +
  plot_annotation(
    title = "RNAseq Analysis",
    tag_levels = 'A',
    tag_suffix = '.',
    theme = theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5)
    )
  )
  

print(grid1)
ggsave("Q2.png", plot =grid1, width = 8, height = 6, dpi = 300)
dev.off()
graphics.off()
