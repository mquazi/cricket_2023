##################################################
###########   Cricket Paper Plots  ###############
##################################################

library(tidyverse)
library(ggplot2)
#setwd("/Users/quazi/Desktop/cric/IPL/1kruns")
setwd("/Users/jcliff/Documents/StatsAnalyses/Cricket_Sim/cricket_2020/IPL_tables_plots")
prob_dist <- read_csv("IPLtable.csv")

# Format data
prob_dist <- prob_dist %>%
  # Name variables
  rename(
    team = X1,
    most_likely_position = `Aggregate standing`
  ) %>%
  # Long data format
  pivot_longer(
    cols = `1`:`8`,
    names_to = "position",
    values_to = "probability"
  )

# Actual finishing positions to note on plot
final_IPL_standings <- tibble(
  team = unique(prob_dist$team),
  position = c(7, 2, 6, 5, 1, 8, 4, 3)
)

# Produce plot
prob_dist %>%
  ggplot() +
  # Main tiles
  geom_tile(
    aes(x = as.numeric(position), 
        y = fct_reorder(team, -most_likely_position), 
        fill = probability)
  ) +
  # Outlines with final standings
  geom_tile(
    data = final_IPL_standings, 
    aes(x = position, y = team), 
    color = "black", fill = NA, size = 0.6
  ) +
  # Text labels with simulation probabilities
  geom_text(
    data = filter(prob_dist, probability > 0), 
    aes(x = as.numeric(position), 
        y = fct_reorder(team, -most_likely_position), 
        label = probability)
  ) +
  # Plot formatting
  scale_fill_gradient(low = "white", high = "springgreen3") +
  scale_x_continuous(
    breaks = 1:8,
    expand = c(0, 0)
  ) +
  scale_y_discrete(expand = c(0, 0)) +
  theme(text=element_text(size=18,family="Times")) +
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5)) +
  xlab("Table Position") +
  ylab("Team") +
  labs(fill = "Percent \nLikelihood")


