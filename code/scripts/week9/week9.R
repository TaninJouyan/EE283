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

test<-png('processed/figures/both_models', width=7, height=6, units='in',res=600)
(manhattan_plot_1)/(manhattan_plot_2)

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

#Adjust the plots to grid in one figure

model1 <- model1 + theme(
  text = element_text(size = 10),  # Adjust overall font size
  axis.title = element_text(size = 9),  # Axis titles font size
  axis.text = element_text(size = 10),   # Axis text font size
  plot.title = element_text(size = 14)   # Title font size
)

model2 <- model2 + theme(
  text = element_text(size = 10),
  axis.title = element_text(size = 9),
  axis.text = element_text(size = 10),
  plot.title = element_text(size = 14)
)

scatter_plot <- scatter_plot + theme(
  text = element_text(size = 14),
  axis.title = element_text(size = 9),
  axis.text = element_text(size = 10),
  plot.title = element_text(size = 14)
)



# Combine the plots using patchwork
combined_plot2 <- (model1 / model2) | scatter_plot
combined_plot2 <- combined_plot2 + plot_layout(
  widths = c(2, 1),  # Adjust relative width of columns (model1/model2 vs scatter_plot)
  heights = c(1, 1)  # Adjust relative height of rows (model1 vs model2)
)

png('processed/figures/combined_plots.png', width = 1200, height = 550, units = 'in', res = 600)
print(combined_plot2)
