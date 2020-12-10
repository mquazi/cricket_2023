##################################################
###########   Cricket Player Plots  ##############
##################################################

# This file creates plots for individual player runs distributions
# scored against different teams in the simulation framework.
# One plot for 3 CWC players, and another for one IPL player.

library(tidyverse)

setwd("/Users/jcliff/Documents/StatsAnalyses/Cricket_Sim/cricket_2020/individual_plots")

#### CWC Players ####

kohli <- read_csv("kohli.csv")
maxwell <- read_csv("maxwell.csv")
williamson <- read_csv("williamson.csv")

# Reshape data to long format, combine dataframes
cwc_players <- kohli %>%
  rename(sim_iter = X1) %>%
  pivot_longer(
    contains("v"),
    names_to = "Opponent",
    values_to = "Runs"
  ) %>%
  select(-sim_iter) %>%
  mutate(
    Player = "Kohli",
    Opponent = str_replace(Opponent, "v ", "")
  ) %>%
  bind_rows(
    maxwell %>%
      rename(sim_iter = X1) %>%
      pivot_longer(
        contains("v"),
        names_to = "Opponent",
        values_to = "Runs"
      ) %>%
      select(-sim_iter) %>%
      mutate(
        Player = "Maxwell",
        Opponent = str_replace(Opponent, "v ", "")
      ),
    williamson %>%
      rename(sim_iter = X1) %>%
      pivot_longer(
        contains("v"),
        names_to = "Opponent",
        values_to = "Runs"
      ) %>%
      select(-sim_iter) %>%
      mutate(
        Player = "Williamson",
        Opponent = str_replace(Opponent, "v ", "")
      )
  )
rm(kohli, maxwell, williamson)

# Construct density plots for players
plot_labels <- cwc_players %>%
  bind_rows(
    tibble(Opponent = "Australia", Runs = NA, Player = "Maxwell"),
    tibble(Opponent = "India", Runs = NA, Player = "Kohli"),
    tibble(Opponent = "New Zealand", Runs = NA, Player = "Williamson")
  ) %>%
  arrange(Opponent, Player) %>%
  mutate(labels = paste(Player, "v", Opponent)) %>%
  pull(labels) %>%
  unique()

cwc_players %>%
  # Add row for blank graph by each player
  bind_rows(
    tibble(Opponent = "Australia", Runs = NA, Player = "Maxwell"),
    tibble(Opponent = "India", Runs = NA, Player = "Kohli"),
    tibble(Opponent = "New Zealand", Runs = NA, Player = "Williamson")
  ) %>%
  ggplot(aes(x = Runs)) +
  geom_density() +
  facet_wrap(
   Opponent ~ Player,
   scales = "free_y",
   nrow = 16, ncol = 3,
   labeller = label_wrap_gen(multi_line = FALSE)
  ) +
  geom_hline(yintercept=0, colour="white", size=0.5) +
  theme_bw() +
  ylab(element_blank())

ggsave("CWC_players.png", width = 7, height = 13, units = "in", dpi = 320)


#### IPL Player ####

villiers <- read_csv("villiers.csv")

# Reshape data to long format, combine dataframes
villiers %>%
  select(-X1) %>%
  pivot_longer(
    contains("v"),
    names_to = "Opponent",
    values_to = "Runs"
  ) %>%
  mutate(
    Opponent = str_replace(Opponent, "v ", ""),
    Opponent = case_when(
      Opponent == "csk" ~ "Chennai Super Kings",
      Opponent == "dc" ~ "Delhi Capitals",
      Opponent == "kxip" ~ "Kings XI Punjab",
      Opponent == "kkr" ~ "Kolkata Knight Riders",
      Opponent == "mi" ~ "Mumbai Indians",
      Opponent == "rr" ~ "Rajasthan Royals",
      Opponent == "srh" ~ "Sunrisers Hyderabad"
    )
  ) %>%
  # Density Plots
  ggplot(aes(x = Runs)) +
  geom_density() +
  facet_wrap(
    Opponent ~ .,
    scales = "free_y"
  ) +
  geom_hline(yintercept=0, colour="white", size=0.5) +
  theme_bw() +
  ylab(element_blank())
