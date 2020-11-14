#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE) 
# The above grabs command line args for later use

####################################################################
#############   Cricket Simulation Functions/Runs  #################
####################################################################
#
# This script runs from a command line argument that takes inputs: 
#    base_path for the folder holding the Git repo 
#    selected_country for the country to run simulations for 
#    n_iter for the number of simulations to run
#
# It automatically reads in the csv, preprocesses the data,
# and runs the simulation, which includes stratified sampling of
# players selected for the game roster and estimating distributions
# of runs scored by individual players for each team in the match.
# Finally, it outputs a csv of simulation results for the runs
# scored against each team in a head-to-head matchup.
#

library(tidyverse)
library(stringr)
library(sampling)

### Helper functions ---------------------------------------------

f <- function(xave, yhs){
  # Function to sample from Gamma distribution to estimate runs
  # scored by a player. Takes inputs:
  #   xave represents a player's average score
  #   yhs represents a player's highest score
  
  beta <- seq(0.01, 5000, 0.01)
  alpha <- xave / (beta)
  gg <- pgamma(yhs, alpha, scale = beta)
  gg <- trunc(gg*10^2) / 10^2
  
  # Assume player has 95% chance of matching highest 
  # number of runs against a particular team
  beta <- beta[which(gg==0.95 | gg==0.96 | gg==0.97 | gg==0.98 | gg==0.99)[1]]
  alpha <- xave / beta
  kk <- rgamma(1, alpha, scale = beta)
  list(kk)
}

run_sim <- function(sim_data, strata_sizes, n, m){
  # Function to run a single iteration of the cricket simulation. Takes inputs:
  #   sim_data is preprocessed dataframe
  #   strata_sizes is a vector of player type counts to sample from team roster
  #   n is the size of the roster (always 11)
  #   m is the number of teams the country played against
  
  # Subset data into high scores and average scores
  select <- strata(sim_data, stratanames = c("myfactor"), size = strata_sizes, method = "srswor")
  hs <- getdata(sim_data, select)[,1:m]
  ave <- getdata(sim_data, select)[,(m+1):(m+m)]
  
  l2 <- NULL
  for (i in 1:n){
    # Pull highest and average scores for selected
    r1 <- hs[i,]
    r2 <- ave[i,]
    # Do not allow avg to be >= to highest score
    l1 <- ifelse((r1 < r2) | (r1 == r2), max(r1, r2+15), r1)
    l2[i] <- list(l1)
  }
  l3 <- data.frame(matrix(unlist(l2), nrow=n, byrow=T))
  
  # Estimate runs for each chosen player against each team
  l4 <- NULL
  l5 <- NULL
  for(i in 1:n){
    for (j in 1:m){
      a <- l3[i,j]
      b <- ave[i,j]
      score <- f(b, a)
      l4[j] <- (score)
    }
    l5[i] <- list(l4)
  }
  
  # Get final scores
  score <- data.frame(matrix(unlist(l5), nrow=n, byrow=T))
  score <- ceiling(score)
  scores <- colSums(score)
  list(scores = scores)
}

# Function to replace
NA2mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))

### Full simulation function ------------------------------------------

cricket_sim <- function(team, input_file, output_file, n_runs, strata_sizes){
  # Function to prep cricket data and run simulation:
  #   team is which team to run
  #   input_file takes file name (+ path) of original data
  #   output_file specifies file name (+path) to save final simulation data
  #   n_runs specifies number of simulations to run
  #   strata_sizes is a vector of player type counts to sample from team roster
  
  # Read in data 
  inddat <- read.csv(input_file, header = T)
  
  # Add type variable to column names 
  # (new for IPL simulation, not in CWC simulation)
  type <- as.character(inddat$roles)
  type <- type[nchar(type) > 1 | nchar(type) == 1]
  inddat$roles <- NULL 
  ff <- colnames(inddat[-c(1,2)])
  kk <- paste0(ff,type)
  colnames(inddat)[3:ncol(inddat)] <- kk
  # Drop rows without team name
  inddat <- filter(inddat, t != "")
  
  # Set variables
  ttt <- nrow(inddat) / 2 # total teams in data
  m <- (ttt - 1)   # number of teams faced
  n <- 11    # always 11
  
  ### Preprocess data
  
  # Splits data into average and highest scores
  i1 <- inddat[1:ttt,]
  i2 <- inddat[(ttt+1):(ttt+ttt),]
  
  # Replace missing vales with average of rest 
  # (for if player didn't play in a game)
  i1 <- replace(i1[,3:ncol(i1)], TRUE, lapply(i1[,3:ncol(i1)], NA2mean))
  i2 <- replace(i2[,3:ncol(i2)], TRUE, lapply(i2[,3:ncol(i2)], NA2mean))
  
  # Add first two columns from original dataset back
  i1 <- cbind(inddat[1:ttt,2],i1)
  i2 <- cbind(inddat[1:ttt,2],i2)
  
  # Drop row of selected team
  i1 <- i1[-which(str_detect(i1[,1], team)),]
  i2 <- i2[-which(str_detect(i2[,1], team)),]
  
  # Combine & transpose data
  ie <- rbind(i1[1:m,],i2[1:m,])
  g <- as.data.frame(t(ie[,-1]))
  
  # Formatting stratification variable & final data set
  g$myfactor <- factor(row.names(g))
  g$myfactor <- str_remove_all(g$myfactor, "[V0123456789]")
  k <- as.numeric(factor(g$myfactor))
  g <- cbind(g,k)
  g$myfactor <- factor(g$myfactor)
  g2 <- g[order(g$myfactor),]
  g2[g2 == 0] <- 1
  
  # Run simulation
  sim_runs <- replicate(n_runs, run_sim(g2, strata_sizes, n, m))
  
  # Final formatting
  result <- data.frame(matrix(unlist(sim_runs), nrow=length(sim_runs), byrow=T))
  # Name columns by matchup
  colnames(result) <- as.vector(unique(i1[,1]))
  
  # Save result
  write.csv(result, output_file)
}

### Running IPL simulation ---------------------------------------------

# Get command line arguments (base_path, selected_team, n_iter, sim_number)
base_path <- args[1] 
selected_team <- args[2]
n_iter <- args[3]
sim_number <- args[4]

# Country-specific variables needed for simulation function
variables <- tibble(
  team = c(
    "Chennai Super Kings", "Delhi Capitals", "Kings XI Punjab", "Kolkata Knight Riders", 
    "Mumbai Indians", "Rajasthan Royals", "Royal Challengers Bangalore", "Sunrisers Hyderabad"
  ),
  input_filename = c(
    "csk.csv", "dc.csv", "kxip.csv", "kkr.csv",
    "mi.csv", "rr.csv", "rcb.csv", "srh.csv"
  ),
  # Counts of player types to sample from each team for game rosters
  strata_count = list(
    c(1,1,2,3,3,1), c(1,2,1,3,3,1), c(1,1,1,4,3,1), c(1,1,2,2,3,2),
    c(1,2,3,3,1,1), c(2,2,2,1,3,1), c(1,1,1,2,3,3), c(1,1,2,1,2,3,1)
  )
) %>% 
  mutate(
    # Add folder structure to input file
    input_filepath = paste0(
      base_path,
      "IPL/",
      input_filename
    ),
    # Construct output filepath
    output_filename = paste0(
      base_path,
      "simulation_results_IPL/",
      str_replace(input_filename, ".csv", "_result"),
      sim_number,
      ".csv"
    )
  )

# Pull variables for specific team
variables <- filter(variables, team == selected_team)

# Run simulation through function
cricket_sim(
  team = selected_team, 
  input_file = variables$input_filepath, 
  output_file = variables$output_filename, 
  n_runs = n_iter, 
  strata_sizes = unlist(variables$strata_count)
)
