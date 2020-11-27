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
0.9553 * (0.0669 * 0.2626) * (0.0212 * 0.7224) * 2

### CSK ###
# The paths are similar to SRH
# P = P(beat SRH) * [P(beat M) * P(D beats M)] * [P(beat D) * P(M beats D)]
0.0437 * (0.0212 * 0.2626) * (0.9848 * 0.7224) * 2


#### MI / DC (Starting in Qualifier 1 Game) ######

# These are more complicated, with two basic paths.
# (1) win Q1, win F against team faced (conditional on Q2 winner)
# (2) lose Q1, win Q2 (conditional on E winner), win F

### MI ###

## Path 1: win Q1, win F against D
# P = P(win Q1) * [P(win F against D | D win Q2) * P(D win Q2)] = P(beat D)^2 * P(D win Q2)

# P(D win Q2) = [P(D beat C | C beats S) * P(C beats S)] + [P(D beat S | S beats C) * P(S beats C)]
#             = [P(D beat C) * P(C beats S)] + [P(D beat S) * P(S beats C)]

(0.7224 ^ 2) * (0.0128 * 0.0437 + 0.978 * 0.9553) +

## Path 2: win Q1, win F against S
# P = P(beat D) * P(beat S) * P(S win Q2)
# P(S win Q2) = P(S beat C) * P(S beat D)

0.7224 * 0.93 * (0.9553 * 0.0212) +

## Path 3: win Q1, win F against C
# P = P(beat D) * P(beat C) * P(C win Q2)
# P(C win Q2) = P(C beat S) * P(C beat D)

0.7224 * 0.969 * (0.0437 * 0.9848) +

## Path 4: lose Q1, beat S in Q2, win F against D
# P = P(D beats M) * [P(beat S | S beats C) * P(S beats C)] * P(beat D in F)

0.2626 * (0.93 * 0.9553) * 0.7224 +

## Path 5: lose Q1, beat C in Q2, win F against D
# P = P(D beats M) * [P(beat C | C beats S) * P(C beats S)] * P(beat D in F)

0.2626 * (0.969 * 0.0437) * 0.7224

### DC ###

# Similar paths to MI

## Path 1: win Q1, win F against M
# P = P(beat M)^2 * P(M win Q2)
# P(M win Q2) = [P(M beat C) * P(C beats S)] + [P(M beat S) * P(S beats C)]

(0.2626 ^ 2) * (0.969 * 0.0437 + 0.93 * 0.9553) +

## Path 2: win Q1, win F against S
# P = P(beat M) * P(beat S) * P(S win Q2)
# P(S win Q2) = P(S beat C) * P(S beat M)

0.2626 * 0.978 * (0.9553 * 0.0669) +

## Path 3: win Q1, win F against C
# P = P(beat M) * P(beat C) * P(C win Q2)
# P(C win Q2) = P(C beat S) * P(C beat M)

0.2626 * 0.0128 * (0.0437 * 0.0284) +

## Path 4: lose Q1, beat S in Q2, win F against M
# P = P(M beats D) * [P(beat S | S beats C) * P(S beats C)] * P(beat M in F)

0.7224 * (0.978 * 0.9553) * 0.2626 +

## Path 5: lose Q1, beat C in Q2, win F against D
# P = P(M beats D) * [P(beat C | C beats S) * P(C beats S)] * P(beat D in F)

0.7224 * (0.0128 * 0.0437) * 0.2626
