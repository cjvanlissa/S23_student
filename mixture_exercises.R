# Install packages
remotes::install_github("cjvanlissa/MplusAutomation")

# Load the MplusAutomation library
library(MplusAutomation)
# Read data for the first exercise

data <- read.table("DDS8_1.dat", na.strings = -99)

# Rename the variables
names(data) <- c("ALC1YR1", "ALC1YR2", "ALC1YR3", "ALCPROB5", "AGE1", "GENDER1")

# Exercise 1a -------------------------------------------------------------

# Use the function createMixtures to define the latent class growth model 
# displayed in Figure 1. Then, obtain a summary table.



# Exercise 1b -------------------------------------------------------------

# Increase the number of starts to ensure proper convergence.
# Use the argument `ANALYSIS = "STARTS = .. ..;"`. 
# Then, make a mixture summary table.



# Exercise 1c -------------------------------------------------------------

# Set up the same models as analyzed in the previous exercise,
# but now allow the means and variances of the intercept and slope factors
# to be freely estimated in each class.
# Do this by mentioning the intercept and slope explicitly in the class-specific
# part of the syntax.


# Exercise 1d -------------------------------------------------------------

# Plot the four models you created in exercise *1c* using `plotGrowthMixtures`,
# and interpret what you see.



# Exercise 1e -------------------------------------------------------------

# Pick your final model from 1c, and add both age and gender as auxiliary
# variables in the model.
  


# Exercise 2a -------------------------------------------------------------

# Latent transition analysis with probability parameterization.

# Load the data:
data <- read.table("DatingSex.dat", na.strings = -99)

# Rename variables
names(data) <- c("u11", "u12", "u13", "u14", "u15", 
                 "u21", "u22", "u23", "u24", "u25", 
                 "gender")

# Run a model that restricts the thresholds (and hence response probabilities)
# across the two time points by first repeating the thresholds for each
# Latent Class (2), in both Model C1: and Model C2.
results_2a <-
  createMixtures(
    # Create only one model, with two classes
    classes = 2,
    # Name the generated files "2a"
    filename_stem = "2a",
    # Specify the autoregressive effect
    model_overall = "c2 ON c1;",
    # Specify two class-specific models; one for each categorical latent variable
    model_class_specific = c(
      "[u11$1] (a{C});  [u12$1] (b{C});  [u13$1] (c{C});  [u14$1] (d{C});  [u15$1] (e{C});",
      "[u21$1] (a{C});  [u22$1] (b{C});  [u23$1] (c{C});  [u24$1] (d{C});  [u25$1] (e{C});"
    ),
    rdata = data,
    usevariables = names(data)[-11],
    # Speed up analysis by using 2 processors; increase random starts
    # Use probability parametrerization
    ANALYSIS = "PROCESSORS IS 2;  LRTSTARTS (0 0 40 20);  PARAMETERIZATION = PROBABILITY;",
    # Specify that the items are categorical (binary)
    VARIABLE = "CATEGORICAL = u11-u15 u21-u25;",
    run = 1L
  )


# Inspect the proportions of yes/no answers for each of the indicators.


# Exercise 2b -------------------------------------------------------------

# Examine the proportions of participants in class.
# Note that for each latent variable, the total proportions add up to 1.
# Next, examine the latent transition probabilities.
# What do these probabilities signify?


# Visualize these probabilities using `plotLTA()`.
  

# Exercise 2c -------------------------------------------------------------

# Add gender as a control variable.


# Exercise 2d -------------------------------------------------------------

# Extend the model to a mover-stayer model (optional).
# Prepare the model:
mover_stayer_model <- mplusObject(
  VARIABLE = "CATEGORICAL = u11-u15 u21-u25;
              CLASSES = move(2) c1(2) c2(2);",
  ANALYSIS = "TYPE = mixture;
              PROCESSORS IS 2;
              LRTSTARTS (0 0 40 20);
              PARAMETERIZATION = PROBABILITY;",
  MODEL = "%OVERALL%
           c1 ON move;
           MODEL move:
           %move#1% ! Movers
           c2 on c1;
           %move#2% ! Stayers
           c2#1 ON c1#1@1;
           c2#1 ON c1#2@0; 
           MODEL c1:
           %c1#1%
           [u11$1] (a1);
           [u12$1] (b1);
           [u13$1] (c1);
           [u14$1] (d1);
           [u15$1] (e1);
           %c1#2%
           [u11$1] (a2);
           [u12$1] (b2);
           [u13$1] (c2);
           [u14$1] (d2);
           [u15$1] (e2);
           MODEL c2:
           %c2#1%
           [u21$1] (a1);
           [u22$1] (b1);
           [u23$1] (c1);
           [u24$1] (d1);
           [u25$1] (e1);
           %c2#2%
           [u21$1] (a2);
           [u22$1] (b2);
           [u23$1] (c2);
           [u24$1] (d2);
           [u25$1] (e2);",
  OUTPUT = "tech15;",
  rdata = data,
  usevariables = names(data)[-11])

# Evaluate the model
result <- mplusModeler(object = mover_stayer_model,
                       modelout = "mover_stayer.inp",
                       run = 1L)


# Look in the output for the response probabilities for the latent classes.
# Also, look for the transition table.
# Which classes are the movers and which are the stayers?


# Exercise 2e -------------------------------------------------------------

# Investigate how many classes at each timepoint you would choose.