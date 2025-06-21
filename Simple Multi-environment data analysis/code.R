# Install and load required packages
required_packages <- c(
  "readxl", "tidyverse", "ggpubr", "agricolae",
  "broom", "ggplot2", "metan", "ggcorrplot", "corrplot"
)

# Install missing packages
install_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

# Load all packages quietly
invisible(sapply(required_packages, install_missing))

# Load core packages
library(dplyr)
library(ggplot2)

# Data Preparation
field_data <- readxl::read_excel("field_data.xlsx") |>
  dplyr::mutate(
    Genotype = as.factor(Genotype),
    Environment = as.factor(Environment),
    Rep = as.factor(Rep)
  )

# Data Overview Functions
show_data_structure <- function(data) {
  # Basic dataset info
  cat("=== DATA OVERVIEW ===\n\n")
  cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n\n")
  
  # Variable structure
  cat("Variable Structure:\n")
  print(utils::str(data))
  
  # Missing values
  cat("\nMissing Values:\n")
  print(colSums(is.na(data)))
}

# Show data overview
show_data_structure(field_data)


# Perform ANOVA for each environment (RCBD Design)
run_environment_anovas <- function(data) {
  environments <- unique(data$Environment)
  results <- list()
  
  for(env in environments) {
    env_data <- data[data$Environment == env, ]
    model <- aov(Yield ~ Genotype + Rep, data = env_data)
    
    # Extract and simplify results
    anova_table <- broom::tidy(model) |>
      dplyr::filter(term != "Residuals") |>
      dplyr::mutate(
        Source = dplyr::case_when(
          term == "Genotype" ~ "Genotype",
          term == "Rep" ~ "Block",
          TRUE ~ term
        ),
        p.value = ifelse(p.value < 0.001, "<0.001", round(p.value, 3))
      ) |>
      dplyr::select(Source, df, sumsq, meansq, statistic, p.value)
    
    # Store results
    results[[as.character(env)]] <- anova_table
    
    # Print simple output
    cat("\n=== Environment:", env, "===\n")
    print(anova_table)
    cat("\n")
  }
  
  return(invisible(results))
}

# Run the analysis
anova_results <- run_environment_anovas(field_data)

# Joint ANOVA for Multi-Environment Trial (RCBD Design)
model <- aov(Yield ~ Environment + Genotype + Environment:Rep + Environment:Genotype,
             data = field_data)

# Get and print ANOVA table
anova_table <- broom::tidy(model) |>
  dplyr::filter(term != "Residuals") |>
  dplyr::mutate(
    Source = dplyr::case_when(
      term == "Environment" ~ "Environment",
      term == "Genotype" ~ "Genotype",
      term == "Environment:Genotype" ~ "GxE Interaction", 
      term == "Environment:Rep" ~ "Block(Environment)",
      TRUE ~ term
    ),
    p.value = ifelse(p.value < 0.001, "<0.001", round(p.value, 3))
  ) |>
  dplyr::select(Source, df, sumsq, meansq, statistic, p.value)

print(anova_table)

# LSD Test
lsd_test <- agricolae::LSD.test(
  y = field_data$Yield,
  trt = field_data$Genotype,
  DFerror = model$df.residual,
  MSerror = deviance(model)/model$df.residual,
  alpha = 0.05,
  group = TRUE,
  console = FALSE
)

# Prepare and print LSD results
lsd_results <- data.frame(
  Genotype = rownames(lsd_test$groups),
  Mean = lsd_test$groups[,1],
  Group = lsd_test$groups[,2]
) |>
  dplyr::arrange(dplyr::desc(Mean))

print(lsd_results)

# plot of LSD results
ggplot(lsd_results, aes(x = reorder(Genotype, Mean), y = Mean, fill = Group)) +
  geom_col() +
  geom_text(aes(label = Group), vjust = -0.5) +
  labs(x = "Genotype", y = "Mean Yield", 
       title = "Genotype Performance") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

# Variance Components and Genetic Parameters
ms_gen <- summary(model)[[1]]["Genotype", "Mean Sq"]
ms_gxe <- summary(model)[[1]]["Environment:Genotype", "Mean Sq"] 
ms_res <- summary(model)[[1]]["Residuals", "Mean Sq"]

n_rep <- length(unique(field_data$Rep))
n_env <- length(unique(field_data$Environment))
grand_mean <- mean(field_data$Yield)

# Calculate components
var_g <- (ms_gen - ms_gxe)/(n_rep*n_env)
var_gxe <- (ms_gxe - ms_res)/n_rep
var_e <- ms_res/n_rep
var_p <- var_g + var_gxe/n_env + var_e/(n_rep*n_env)
h2 <- (var_g/var_p)*100
cv <- (sqrt(var_p)/grand_mean)*100

# Create and print results table
results <- data.frame(
  Component = c("Genotypic (σ²g)",
                "GxE Interaction (σ²gxe)", 
                "Environmental (σ²e)",
                "Phenotypic (σ²p)",
                "Heritability (H²%)",
                "Phenotypic CV (%)"),
  Value = round(c(var_g, var_gxe, var_e, var_p, h2, cv), 4)
)

print(results)

## Phenotypic (Based on observed averages)
# Phenotypic means matrix
pheno_matrix <- field_data %>%
  group_by(Genotype, Environment) %>%
  summarise(Yield_Mean = mean(Yield, na.rm = TRUE), .groups = 'drop') %>%
  pivot_wider(names_from = Environment, values_from = Yield_Mean) %>%
  column_to_rownames("Genotype")

# Correlation matrix with improved visualization
cor_pheno <- cor(pheno_matrix, use = "complete.obs")

ggcorrplot(cor_pheno, 
           hc.order = TRUE, 
           type = "lower",
           lab = TRUE,
           lab_size = 4,
           digits = 2,
           tl.cex = 10,
           colors = c("#6D9EC1", "white", "#E46726"),
           outline.color = "gray",
           ggtheme = theme_minimal()) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.text.y = element_text(size = 10),
        legend.position = "right") +
  labs(title = "Phenotypic Correlation Between Environments",
       subtitle = "Pearson correlation coefficients of genotype means")

# Genetic (Based on adjusted genotypic effects)
# Calculate genotype means per environment
env_means <- field_data %>%
  group_by(Genotype, Environment) %>%
  summarise(Mean_Yield = mean(Yield, na.rm = TRUE), .groups = 'drop')

# Convert to wide format
env_matrix <- env_means %>% 
  pivot_wider(names_from = Environment, values_from = Mean_Yield) %>%
  as.data.frame()

# Set genotypes as row names
rownames(env_matrix) <- env_matrix$Genotype
env_matrix <- env_matrix[-1]  # Remove Genotype column

# Calculate correlation matrix
env_cor_matrix <- cor(env_matrix, use = "complete.obs")

# Visualize correlations with identical formatting
corrplot(env_cor_matrix,
         method = "number",    # Show correlation coefficients as numbers
         type = "upper",      # Display only upper triangle
         tl.col = "black",    # Black text for environment names
         tl.cex = 0.8,       # Text label size
         number.cex = 0.7,    # Correlation number size
         mar = c(0, 0, 0, 0), # Margins (bottom, left, top, right)
         diag = FALSE)        # Hide diagonal (1's)

# Environmental (Based on non-genetic effects)
# Calculate genotype means per environment
env_means <- field_data %>%
  group_by(Genotype, Environment) %>%
  summarise(Mean_Yield = mean(Yield, na.rm = TRUE), .groups = 'drop')

# Convert to wide format (genotypes as rows, environments as columns)
env_matrix <- env_means %>% 
  pivot_wider(names_from = Environment, values_from = Mean_Yield) %>%
  as.data.frame()

# Set genotypes as row names and remove the column
rownames(env_matrix) <- env_matrix$Genotype
env_matrix <- env_matrix[-1]  # Remove Genotype column

# Calculate correlation matrix
env_cor_matrix <- cor(env_matrix, use = "complete.obs")

# Visualize correlations
corrplot(env_cor_matrix,
         method = "number",
         type = "upper",
         tl.col = "black",
         tl.cex = 0.8,
         number.cex = 0.7)

# Environmental effects for each location
# 1. Calculate environmental effects for each location
env_effects <- field_data %>%
  group_by(Environment) %>%
  summarise(Env_Effect = mean(Yield, na.rm = TRUE) - mean(field_data$Yield, na.rm = TRUE))

# 2. Create a bar plot instead of correlation plot (more appropriate for this data)
ggplot(env_effects, aes(x = reorder(Environment, Env_Effect), y = Env_Effect)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Environmental Effects by Location", 
       x = "Environment", 
       y = "Effect (Deviation from Grand Mean)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red")