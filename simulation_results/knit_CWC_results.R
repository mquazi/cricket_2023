####################################################################
############   Knitting CWC Results Files Together  ################
####################################################################

library(tidyverse)

setwd("/Users/jcliff/Documents/StatsAnalyses/Cricket_Sim/cricket_2020/simulation_results")

# Team abbreviations
team_abbrevs <- c("afg", "australia", "bangla", "eng", 
                   "india", "irl", "nzl", "pak",
                   "saf", "sri", "wi", "zim")

# Function to read in and write full csv for each pattern
read_in_CWC_runs <- function(team_abbrev){
  
  # File pattern for reading in all csvs for team
  file_pattern_to_read <- paste0("*", team_abbrev, "_.*.csv")
  
  # Name of file to save
  final_file_name <- paste0(team_abbrev, "_full.csv")
  
  # Read files into single df and save full csv
  list.files(pattern = file_pattern_to_read) %>% 
    map_df(~read_csv(.)) %>%
    write_csv(final_file_name)
}

# Run function for all teams
for(i in seq_along(team_abbrevs)){
  read_in_CWC_runs(team_abbrevs[i])
}

