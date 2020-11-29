##################################################
###########   IPL Tournament Calcs  ##############
##################################################

# Notation:
#
# P is probability of event
# Teams = M (MI), D (DC), S (SRH), C (CSK)
# E is eliminator game, Q1 is first qualifier, Q2 is second qualifier, F is final

# See IPL table calculations for probabilities used

# For each path, the probabilities are multiplied, then paths are summed together to give total probability
# Separate games are independent [so conditional probabilities P(A|B) = P(A)]

# Probabilities (proportion of wins out of simulations, including draws)
p_MwD <- 0.7224 # MI beats DC
p_MwS <- 0.93 # MI beats SRH
p_MwC <- 0.969 # MI beats CSK
p_DwM <- 0.2626 # DC beats MI
p_DwS <- 0.978 # DC beats SRH
p_DwC <- 0.0128 # DC beats CSK
p_SwM <- 0.0669 # SRH beats MI
p_SwD <- 0.0212 # SRH beats DC
p_SwC <- 0.9553 # SRH beats CSK
p_CwM <- 0.0284 # CSK beats MI
p_CwD <- 0.9848 # CSK beats DC
p_CwS <- 0.0437 # CSK beats SRH

# Transforming to ignore draws so winning percentage is out of games where a win or loss occurred (like in tournament)
# (convert proportions to add to 1 between team matchups)
p_MwD <- p_MwD / (p_MwD + p_DwM)
p_MwS <- p_MwS / (p_MwS + p_SwM)
p_MwC <- p_MwC / (p_MwC + p_CwM)
p_DwM <- p_DwM / (p_MwD + p_DwM)
p_DwS <- p_DwS / (p_DwS + p_SwD)
p_DwC <- p_DwC / (p_DwC + p_CwD)
p_SwM <- p_SwM / (p_MwS + p_SwM)
p_SwD <- p_SwD / (p_DwS + p_SwD)
p_SwC <- p_SwC / (p_SwC + p_CwS)
p_CwM <- p_CwM / (p_MwC + p_CwM)
p_CwD <- p_CwD / (p_DwC + p_CwD)
p_CwS <- p_CwS / (p_SwC + p_CwS)



#### SRH / CSK (Starting in Eliminator Game) #####

# Basic path is 
# (1) win Elim, 
# (2) win Q2 against team faced (conditional on Q1 loser) 
# (3) Win final (conditional on Q1 winner)

### SRH ###
# Path 1: win E, win Q2 against M, win final against D
# P = P(win E) * [P(win Q2 against M | M lost Q1) * P(M lost Q2)] + [P(win F against D | D win Q1) * P(D win Q1)]
# P = P(beat CSK) * [P(beat M) * P(D beats M)] * [P(beat D) * P(M beats D)]
# The probability will be the same for path 2 since M/D positions will just be reversed (so it can be multiplied by 2)
p_SwC * (p_SwM * p_DwM) * (p_SwD * p_MwD) * 2

### CSK ###
# The paths are similar to SRH
# P = P(beat SRH) * [P(beat M) * P(D beats M)] * [P(beat D) * P(M beats D)]
p_CwS * (p_SwD * p_DwM) * (p_CwD * p_MwD) * 2


#### MI / DC (Starting in Qualifier 1 Game) ######

# These are more complicated, with two basic paths.
# (1) win Q1, win F against team faced (conditional on Q2 winner)
# (2) lose Q1, win Q2 (conditional on E winner), win F

### MI ###

## Path 1: win Q1, win F against D
# P = P(win Q1) * [P(win F against D | D win Q2) * P(D win Q2)] = P(beat D)^2 * P(D win Q2)

# P(D win Q2) = [P(D beat C | C beats S) * P(C beats S)] + [P(D beat S | S beats C) * P(S beats C)]
#             = [P(D beat C) * P(C beats S)] + [P(D beat S) * P(S beats C)]

(p_MwD ^ 2) * (p_DwC * p_CwS + p_DwS * p_SwC) +

## Path 2: win Q1, win F against S
# P = P(beat D) * P(beat S) * P(S win Q2)
# P(S win Q2) = P(S beat C) * P(S beat D)

p_MwD * p_MwS * (p_SwC * p_SwD) +

## Path 3: win Q1, win F against C
# P = P(beat D) * P(beat C) * P(C win Q2)
# P(C win Q2) = P(C beat S) * P(C beat D)

p_MwD * p_MwC * (p_CwS * p_CwD) +

## Path 4: lose Q1, beat S in Q2, win F against D
# P = P(D beats M) * [P(beat S | S beats C) * P(S beats C)] * P(beat D in F)

p_DwM * (p_MwS * p_SwC) * p_MwD +

## Path 5: lose Q1, beat C in Q2, win F against D
# P = P(D beats M) * [P(beat C | C beats S) * P(C beats S)] * P(beat D in F)

p_DwM * (p_MwC * p_CwS) * p_MwD

### DC ###

# Similar paths to MI

## Path 1: win Q1, win F against M
# P = P(beat M)^2 * P(M win Q2)
# P(M win Q2) = [P(M beat C) * P(C beats S)] + [P(M beat S) * P(S beats C)]

(p_DwM ^ 2) * (p_MwC * p_CwS + p_MwS * p_SwC) +

## Path 2: win Q1, win F against S
# P = P(beat M) * P(beat S) * P(S win Q2)
# P(S win Q2) = P(S beat C) * P(S beat M)

p_DwM * p_DwS * (p_SwC * p_SwM) +

## Path 3: win Q1, win F against C
# P = P(beat M) * P(beat C) * P(C win Q2)
# P(C win Q2) = P(C beat S) * P(C beat M)

p_DwM * p_DwC * (p_CwS * p_CwM) +

## Path 4: lose Q1, beat S in Q2, win F against M
# P = P(M beats D) * [P(beat S | S beats C) * P(S beats C)] * P(beat M in F)

p_MwD * (p_DwS * p_SwC) * p_DwM +

## Path 5: lose Q1, beat C in Q2, win F against D
# P = P(M beats D) * [P(beat C | C beats S) * P(C beats S)] * P(beat D in F)

p_MwD * (p_DwC * p_CwS) * p_DwM
