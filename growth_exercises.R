# Load the packages
library(MplusAutomation)
library(tidySEM)

# Read data for the first exercise
data <- read.table("PTSD.dat", na.strings = -999)
names(data) <- c("gender", "tvlo",
                 "W1", "W2", "W3", "W4", "W5", "W6", "W7", "W8",
                 "pain")
# Exercise 1a -------------------------------------------------------------

# Find the best LGM model. Complete this basic syntax:

basic <- mplusObject(
  TITLE = "exercise 1",
  MODEL = "",
  OUTPUT = "standardized;",
  PLOT = "SERIES = w1-w8 (s);
          TYPE = PLOT3;",
  rdata = data,
  usevariables = c("W1", "W2", "W3", "W4", "W5", "W6", "W7", "W8")
)

result <- mplusModeler(basic, modelout = "basic.inp", run = 1L)

# For one model
SummaryTable(result)
# For more models
SummaryTable(list(result1, result2))


# Exercise 1b -------------------------------------------------------------

# Starting with the model above, regress the growth parameters on TVLO and
# regress Pain on the growth parameters (see example from slides).
# Are there gender differences in the regression of the growth parameters
# on TVLO and in the regression of Pain on the growth parameters?



# Exercise 2a -------------------------------------------------------------

# Load the data:
data <- read.table("DDS8_1.dat", na.strings = -99)
names(data) <- c("ALC1YR1", "ALC1YR2", "ALC1YR3", "ALCPROB5", "AGE1", "GENDER1")

# Specify the LGM by completing the syntax below:

m0 <- mplusObject(
  TITLE = "LGA MODEL",
  MODEL = "",
  OUTPUT = "",
  rdata = data,
  usevariables = c("ALC1YR1", "ALC1YR2", "ALC1YR3"))


# Exercise 2b -------------------------------------------------------------
  
# Run several models with different covariates, and decide upon the best
# model.

# Create a vector with three "additional syntaxes" for my three different models
mod = c("!extra syntax;",
        "!goes here;")
# Create a list with the additional usevariables used in the three models above
vars = list("GENDER1",
            c("GENDER1", "AGE1"))
# Make a list of exploratory models, by modifying a copy of the basic model m0
models <- lapply(1:length(mod), function(i){
  m0$MODEL <- paste0(m0$MODEL, mod[i]) # append element i of mod
  m0$usevariables <- c(m0$usevariables, vars[[i]]) # append element i of vars
  m0$modelout = paste0("Model", i, ".inp") # Add unique filename
  m0 # return the modified model
})
# Run all models and store results in a list called results
results <- lapply(models, mplusModeler, run = 1L)
# Get summary table and store it in 'tab'
tab <- SummaryTable(results, keepCols = c("Parameters", "AIC", "BIC", "RMSEA_Estimate", "CFI", "TLI", "SRMR"), sortBy = BIC)
# Add model syntax to the table
tab <- cbind(Model = mod, tab)
tab

# Plot the BICs and annotate with the syntax to see which model is best
library(ggplot2)
qplot(x = 1:length(tab$BIC), y = tab$BIC) + geom_line() + geom_text(label = tab$Model, size = 2)


# Exercise 2c -------------------------------------------------------------

# Include ALCPROB5 in the model as a categorical variable (CATEGORICAL = ALCPROB5). 

  

# Exercise 3 --------------------------------------------------------------

data <- read.table("GPA.dat")
names(data) <- c("STUDENT", "SEX", "HIGHGPA",
                 "GPA1", "GPA2", "GPA3", "GPA4", "GPA5", "GPA6")
				 
# Exercise 3a -------------------------------------------------------------

# Use a parameterization with GPA1@0 and GPA6@1.
# The loadings for the other timepoints should be freely estimated.
# Use the syntax GPA2* etc as shown in the handout.
# Interpret the factor loadings and estimate for S.


# Exercise 3b -------------------------------------------------------------

# Now use a parameterization with GPA1@0 and GPA2@1.
# The other GPA’s should be freely estimated.
# Interpret the factor loadings and estimate for S.


# Exercise 3c -------------------------------------------------------------
 
# Done in Mplus

# Exercise 3d -------------------------------------------------------------

# Use sex as a predictor of the intercept and slope 
# (with 0 = boys, 1 = girls).

# Exercise 4a -------------------------------------------------------------

# Set up a normal latent growth model for GPA for the 6 measurements.
# Obtain the following parameters:
# AIC/BIC, Chi Square, RMSEA, CFI/TLI
# Mean Intercept and Slope
# Variance of the Intercept and Slope


# Exercise 4b -------------------------------------------------------------

# Set up a latent growth model for 3 years where each year is a latent
# variable measured by the GPA of two consecutive semesters.
# Obtain the same parameters as in 4a.