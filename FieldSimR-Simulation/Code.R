# Install FieldSimR from CRAN (if needed)
# install.packages("")
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}

# Load the library
library(FieldSimR)
library(writexl)

## 1. SET BASIC EXPERIMENT PARAMETERS ----
n_gen <- 20    # Number of genotypes to simulate
n_env <- 15    # Number of different environments 
n_rep <- 3     # Number of replicates per GxE combination

## 2. DEFINE VARIANCE COMPONENTS ----
var_G <- 1.5   # Genotypic variance (differences between genotypes)
var_E <- 0.8   # Environmental variance (differences between environments)
var_GE <- 0.5  # GxE interaction variance
var_e <- 0.3   # Residual variance (experimental error)

## 3. SIMULATE RANDOM EFFECTS ----
set.seed(123)  # Set random seed for reproducibility

# Genotypic effects ~ N(0, var_G)
G_effects <- rnorm(n_gen, mean = 0, sd = sqrt(var_G))

# Environmental effects ~ N(0, var_E)
E_effects <- rnorm(n_env, mean = 0, sd = sqrt(var_E))

# GxE interaction effects ~ N(0, var_GE)
# Matrix with n_gen rows (genotypes) and n_env columns (environments)
GE_effects <- matrix(rnorm(n_gen * n_env, mean = 0, sd = sqrt(var_GE)),
                     nrow = n_gen, ncol = n_env)

## 4. CREATE EXPERIMENTAL DESIGN STRUCTURE ----
# Genotype vector (each genotype appears n_env * n_rep times)
geno <- rep(paste0("G", 1:n_gen), each = n_env * n_rep)

# Environment vector (each environment appears n_rep times, repeated for all genotypes)
env <- rep(rep(paste0("E", 1:n_env), each = n_rep), times = n_gen)

# Replicate vector (sequence 1:n_rep repeated for all GxE combinations)
rep <- rep(1:n_rep, times = n_gen * n_env)

## 5. CALCULATE EXPECTED VALUES ----
mu <- 10  # Overall experiment mean

# Calculate expected value for each observation:
expected_value <- mu +
  G_effects[as.numeric(gsub("G", "", geno))] +  # Genotype effect
  E_effects[as.numeric(gsub("E", "", env))] +   # Environment effect
  GE_effects[cbind(as.numeric(gsub("G", "", geno)),  # Interaction effect
                   as.numeric(gsub("E", "", env)))]

## 6. ADD EXPERIMENTAL ERROR ----
y <- expected_value + rnorm(length(expected_value), 0, sqrt(var_e))

## 7. CREATE FINAL DATA FRAME ----
field_data <- data.frame(
  Genotype = factor(geno, levels = paste0("G", 1:n_gen)),  # As ordered factor
  Environment = factor(env, levels = paste0("E", 1:n_env)), # As ordered factor
  Rep = rep,
  Yield = y
)

# View first rows of simulated data
head(field_data)

# Export to Excel
write_xlsx(field_data, path = "field_data.xlsx")
