#######################################################
##### Logistic Regression Simulation Validation #######
#######################################################

library(tidyverse)

### Read in data
setwd("/Users/jcliff/Documents/StatsAnalyses/Cricket_Sim/cricket_2020/Logistic_reg")
an<-read.csv("anval.csv",header=T)[,-1]
aa<-read.csv("aaval.csv",header=T)[,-1]
bh<-read.csv("bhval.csv",header=T)[,-1]
ed<-read.csv("edval.csv",header=T)[,-1]
ia<-read.csv("iaval.csv",header=T)[,-1]
id<-read.csv("idval.csv",header=T)[,-1]
nd<-read.csv("ndval.csv",header=T)[,-1]
pn<-read.csv("pnval.csv",header=T)[,-1]
sa<-read.csv("saval.csv",header=T)[,-1]
ska<-read.csv("skaval.csv",header=T)[,-1]
ws<-read.csv("wsval.csv",header=T)[,-1]
ze<-read.csv("zeval.csv",header=T)[,-1]
head(an[,])
# Put all data frames in a list
all <- list(an,aa,bh,ed,ia,id,nd,pn,sa,ska,ws,ze)
rm(an,aa,bh,ed,ia,id,nd,pn,sa,ska,ws,ze) # drop individual objects
head(all[[5]]) # india (corresponds to order of list above)

### Construct all GLMs
jj<-NULL # for teams played against
kk<-NULL # for each team
for (i in 1:12){ 
  g2<-all[[i]]
  for (j in 1:11){
    # Predicting wins by runs scored for and against
    fit1<-glm(g2[,j+22]~g2[,j]+g2[,j+11],family="gaussian")
    # Save coefficients
    hh<-as.data.frame(coef(fit1))
    hh
    jj[j]<-list(hh)
  }
  kk[i]<-list(jj)
}
rm(jj, i, j, hh, g2, fit1) # Drop unneeded variables

# Example of investigating results
kk[[4]][[5]] # india vs. england example
c<-(kk[[5]][[4]])
indmean<-mean(all[[5]][,4]) # mean ind v. eng score from simulation
engmean<-mean(all[[5]][,15]) # mean eng v. ind
meanengvind<-mean(all[[5]][,26])
meanengvind # prop won by india
dd<-c[1,1]+c[2,1]*indmean+c[3,1]*engmean     
exp(dd)/(1+exp(dd)) # average probability for win



### Get full results for each team vs. all others

# List of teams to connect to results
teams <- c("Afghanistan", "Australia", "Bangladesh", "England", "India", "Ireland", 
           "New Zealand", "Pakistan", "South Africa", "Sri Lanka", "West Indies", "Zimbabwe")

# Function to calculate average probability for win from simulation
average_probability_calc <- function(sim_team, team_against){
  # Get list number values to point to
  team_number <- which(teams == sim_team)
  opponent_number <- which((teams[-team_number]) == team_against)
  # Pull model coefficients
  coefs <- kk[[team_number]][[opponent_number]] %>% pull(`coef(fit1)`)
  # Get mean scores for team and opponent
  mean_team_score <- mean(all[[team_number]][, opponent_number])
  mean_opponent_score <- mean(all[[team_number]][, opponent_number + 11])
  # Calculate probability from model
  linear_equation <- coefs[1] + coefs[2] * mean_team_score + coefs[3] * mean_opponent_score
  probability <- exp(linear_equation) / (1 + exp(linear_equation))
  return(probability)
}
average_probability_calc("Australia", "Afghanistan")

# Get all combinations of teams and calculate probabilities
prob_results <- expand.grid(teams, teams) %>%
  rename(simTeam = Var1, opponent = Var2) %>%
  filter(simTeam != opponent) %>%
  rowwise() %>%
  mutate(prob = average_probability_calc(simTeam, opponent))

# Prob distributions
ggplot(prob_results, aes(prob, simTeam)) + geom_boxplot() # all over 50%


# Going for win percentage instead 
# Function to calculate average probability for win from simulation
win_percentage_calc <- function(sim_team, team_against){
  # Get list number values to point to
  team_number <- which(teams == sim_team)
  opponent_number <- which((teams[-team_number]) == team_against)
  # Get win percentage of team
  sim_win_percent <- mean(all[[team_number]][, opponent_number + 22])
  return(sim_win_percent)
}
win_percentage_calc("India", "England")

# Get all win results for each team combination
win_results <- expand.grid(teams, teams) %>%
  rename(simTeam = Var1, opponent = Var2) %>%
  filter(simTeam != opponent) %>%
  rowwise() %>%
  mutate(prob = win_percentage_calc(simTeam, opponent)) 

# Check compliments of one team v another
win_results %>%
  # Get combo of teams (alphabetical to match)
  mutate(simTeam = as.character(simTeam), opponent = as.character(opponent)) %>%
  mutate(teams = paste(min(simTeam, opponent), max(simTeam, opponent))) %>%
  # Calculate if they add up to 1
  group_by(teams) %>%
  summarise(total_prob = sum(prob)) %>%
  # Plot
  ggplot(aes(x = total_prob)) + geom_histogram() # Looks great!

# Read in real result table & add to win_results
real_results <- read_csv("resultssince1999.csv")
# Remove draws/rainouts from match count
real_results <- real_results %>%
  rowwise() %>%
  # Get combo of teams (alphabetical to match)
  mutate(teams = paste(min(Team, Opponent), max(Team, Opponent))) %>%
  ungroup %>%
  group_by(teams) %>%
  mutate(
    Matches = ifelse(
      sum(Won) != mean(Matches),
      sum(Won),
      mean(Matches)
    )
  ) %>%
  ungroup() %>%
  select(-teams)

# Test proportions of recent wins versus predicted by simulation
win_results %>%
  # Join real results
  left_join(
    real_results,
    by = c("simTeam" = "Team", "opponent" = "Opponent")
  ) %>%
  # Fix probabilities of 0 or 1 from simulation for prop test
  mutate(
    prob = case_when(
      prob == 1 ~ 0.9999999,
      prob == 0 ~ 0.0000001,
      T ~ prob
    )
  ) %>%
  # Do prop tests
  rowwise() %>%
  mutate(
    proptest_p = prop.test(Won, Matches, prob)$p.value,
    proptest_int = list(prop.test(Won, Matches, prob)$conf.int)
  ) %>%
  # Plot results with conf_int
  mutate(
    real_win_perc = Won / Matches,
    CI_min = proptest_int[1],
    CI_max = proptest_int[2]
  ) %>%
  #filter(simTeam == "India") %>%
  ggplot(aes(x = opponent, y = real_win_perc)) + 
  geom_point() +
  geom_errorbar(
    aes(ymin = CI_min, ymax = CI_max), 
    width=.2,
    position=position_dodge(.9)
  ) +
  # Add sim percentages
  geom_point(aes(y = prob), shape = 4, color = "blue") +
  facet_wrap(~ simTeam) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  xlab("Opponent") + ylab("Win Percentage")
