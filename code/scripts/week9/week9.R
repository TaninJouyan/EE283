
library(nycflights13)
flights
# Load required libraries
library(ggplot2)
library(patchwork)
library(dplyr)


##QUESTION 1
# Scatter Plot with Smoother (P1)
P1 <- ggplot(flights, aes(x = distance, y = arr_delay)) +
  geom_point(alpha = 0.5, color = "orange") +  # Add transparency for better visibility
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Arrival Delay vs Distance", x = "Distance (miles)", y = "Arrival Delay (min)") +
  theme_minimal()

# Bar Chart (P2)
temp_flights <- flights %>%
  group_by(carrier) %>%
  summarize(m_arr_delay = mean(arr_delay, na.rm = TRUE))

P2 <- ggplot(temp_flights, aes(x = carrier, y = m_arr_delay, fill = carrier)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  scale_fill_viridis_d() +
  labs(title = "Mean Arrival Delay by Carrier", x = "Carrier", y = "Mean Arrival Delay (min)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),  # Rotate x-axis labels
        axis.title.y = element_text(size = 10))  # Reduce y-axis label size

# Box Plot (P3)
P3 <- ggplot(flights, aes(x = carrier, y = arr_delay, fill = carrier)) + 
  geom_boxplot(outlier.color = "pink", outlier.shape = 16) +
  scale_fill_viridis_d() +
  labs(title = "Arrival Delay Distribution by Carrier", x = "Carrier", y = "Arrival Delay (min)") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 90, hjust = 1),  # Rotate x-axis labels
        axis.title.y = element_text(size = 10))

# Histogram (P4)
P4 <- ggplot(flights, aes(x = arr_delay)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Arrival Delays", x = "Arrival Delay (min)", y = "Count") +
  theme_minimal()

# Define layout for patchwork
Layout <- "
AAB
AAC
AAD
"
# Create a Custom layout
png("Q1.png", width = 14, height = 12, units = "in", res = 600)
plot <- P1 + P2 + P3 + P4 + 
  plot_layout(design = Layout) + 
  plot_annotation(
    title = "Flight Arrival Delays - Data Visualization",
    subtitle = "Analyzing Delays by Distance, Carrier, and Distribution",
    tag_levels = 'A',
    theme = theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5)
    )
  )
print(plot)  
dev.off()
graphics.off()
ggsave("Q1.png", plot = plot, width = 8, height = 6, dpi = 300)

##QUESTION2

#For this question I have used the plot generated from RNA analysis (week7)
library(grid)
library(png)
library(patchwork)
library(gridExtra)
PR1<- readPNG('processed/figures/RNA_deg_analysis.png')
PR2 <-readPNG('processed/figures/PCAplot.png')
PR3<- readPNG('processed/figures/MAplot.png')
PR4<- readPNG('processed/figures/geneCluster.png')
grid.arrange(PR1,PR2,PR3,PR4, ncol = 2)
Layout2 <- "
ADD
CBB
"
plot2 <- PR1 + PR2 + PR3 + PR4 + 
  plot_layout(design = Layout2) + 
  plot_annotation(
    title = "RNAseq Analysis",
    tag_levels = 'A',
    theme = theme(
      plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5)
    )
  )

print(plot2)  
dev.off()
graphics.off()
ggsave("Q2.png", plot = plot2, width = 8, height = 6, dpi = 300)

##QUESTION 3
library(tidyverse)
library(dplyr)
library(ggplot2)
library(patchwork)
result=read_tsv('anova_model1_result')
result_2=read_tsv('anova_model2_result')

# Manhattan plot for result
manhattan_plot_1 <- ggplot(result, aes(x = pos, y = logp)) +
  geom_point(color = "green", alpha = 0.6) +
  theme_minimal() +
  labs(x = "Position", y = "-log10(p-value)", title = "Manhattan Plot of ANOVA model 1") +
  theme(plot.title = element_text(hjust = 0.5))

# Manhattan plot for result_2
manhattan_plot_2 <- ggplot(result_2, aes(x = pos, y = logp)) +
  geom_point(color = "purple", alpha = 0.6) +
  theme_minimal() +
  labs(x = "Position", y = "-log10(p-value)", title = "Manhattan Plot of ANOVA model 2") +
  theme(plot.title = element_text(hjust = 0.5))

# Display the plots
print(manhattan_plot_1)
print(manhattan_plot_2)

# Save the plots (optional)
ggsave("processed/figures/manhattan_plot_model1.png", manhattan_plot_1, width = 12, height = 6)
ggsave("processed/figures/manhattan_plot_model2.png", manhattan_plot_2, width = 12, height = 6)

combined_plot <- manhattan_plot_1 / manhattan_plot_2  # Stack plots vertically

# Save the combined plot as a PNG file
png('processed/figures/both_models.png', width = 7, height = 6, units = 'in', res = 600)
print(combined_plot)
dev.off()

###QUESTION 4

source("/dfs6/pub/tjouyan/ee283/myManhattan/myManhattanFunction.R")


#Renaming column names to fit the 'myManhattan' script
result <- result %>%
  rename(P=logp, CHR=chr, BP=pos)
result_2<- result_2 %>% 
  rename(P=logp, CHR=chr, BP=pos)

#Using 'myManhattan' package to plot Manhattan plots for both ANOVA models 
model1<-myManhattan(result, graph.title = "Manhattan Plot ANOVA model 1", font.size = 10,
            suggestiveline = 2e-4, suggestivecolor = "pink")
           

print(model1)
model2<-myManhattan(result_2, graph.title = "Manhattan Plot ANOVA model 2", font.size = 10,
            suggestiveline = 2e-4, suggestivecolor = "orange")
print(model2) 
ggsave("processed/figures/myManhattan_model1.png", model1, width = 12, height = 6)
ggsave("processed/figures/myManhattan_model2.png", model2, width = 12, height = 6)

#Preparing df for comparing SNPs model disagree on      
comparison_df <- merge(result, result_2, by = "BP", suffixes = c(".model1", ".model2"))

# Scatter plot of -log10(p) from both models
scatter_plot <- ggplot(comparison_df, aes(x = P.model1, y = P.model2)) +
  geom_point(color = "orange", alpha = 0.6) +
  theme_minimal() +
  labs(x = "-log10(p) Model 1", y = "-log10(p) Model 2", title = "Model Comparison") +
  theme(plot.title = element_text(hjust = 0.5))
scatter_plot

###QUESTION 5

#Adjust the plots to grid in one figure

library(ggplot2)
library(patchwork)

# Adjusting the theme for better readability
model1 <- model1 + theme(
  text = element_text(size = 14),
  axis.title = element_text(size = 12),
  axis.text = element_text(size = 10),
  plot.title = element_text(size = 16)
)

model2 <- model2 + theme(
  text = element_text(size = 14),
  axis.title = element_text(size = 12),
  axis.text = element_text(size = 10),
  plot.title = element_text(size = 16)
)

scatter_plot <- scatter_plot + theme(
  text = element_text(size = 14),
  axis.title = element_text(size = 12),
  axis.text = element_text(size = 10),
  plot.title = element_text(size = 16)
)

# Improve layout by adding spacing between plots
combined_plot2 <- (model1 / model2) | scatter_plot
print(combined_plot2)
# Save plot with wider dimensions
ggsave("processed/figures/combined_plots.png", plot = combined_plot2, 
       width = 20, height = 10, units = 'in', dpi = 300)
