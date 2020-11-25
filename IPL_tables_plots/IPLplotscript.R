##################################################
###########   Cricket Paper Plots  ###############
##################################################

library(tidyverse)
library(ggplot2)
setwd("/Users/quazi/Desktop/cric/IPL/1kruns")
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
        # Combine 11 & 12 rank into DNQ
        #mutate(
        #        probability = ifelse(
        #                position == 11, 
        #                probability + lead(probability), 
        #                probability
        #        )
        #) %>%
        #filter(position != 12)


# Produce plot
prob_dist %>%
        ggplot(
                aes(x = as.numeric(position), 
                    y = fct_reorder(team, -most_likely_position), 
                    fill = probability)
        ) +
        geom_tile() +
        geom_text(
                data = filter(prob_dist, probability > 0), 
                aes(label = probability)
        ) +
        scale_fill_gradient(low = "white", high = "springgreen3") +
        scale_x_continuous(
                breaks = 1:8,
                #labels = c(1:10, "Did not \n qualify"),
                expand = c(0, 0)
        ) +
        scale_y_discrete(expand = c(0, 0)) +
        theme(text=element_text(size=18,family="Times")) +
      #  theme_classic()    +
        theme(axis.line.x = element_line(color="black", size = 0.5),
              axis.line.y = element_line(color="black", size = 0.5)) +
        xlab("Table Position") +
        ylab("Team") +
        labs(fill = "Percent \nLikelihood")
#        ggtitle("")


