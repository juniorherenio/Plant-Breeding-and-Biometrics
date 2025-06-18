# Genotype by Environment (G×E) Interaction Analysis

This repository contains R code for simulating and analyzing genotype by environment interaction (G×E) data for agricultural trials.

## Contents

1. [Data Simulation](#data-simulation)
2. [Exploratory Analysis](#exploratory-analysis)
3. [Statistical Methods](#statistical-methods)
4. [Visualization](#visualization)
5. [Quality Control](#quality-control)
6. [Requirements](#requirements)
7. [Usage](#usage)

## Data Simulation

The simulation script generates realistic agricultural trial data with:

- `n_gen` genotypes
- `n_env` environments
- `n_rep` replicates
- Customizable variance components:
  - Genotypic variance (`var_G`)
  - Environmental variance (`var_E`)
  - G×E interaction variance (`var_GE`)
  - Residual variance (`var_e`)

Key features:
- Complete experimental design structure
- Ordered factors for genotypes and environments
- Export to Excel format

## Exploratory Analysis

The analysis script provides:

- Comprehensive data overview:
  - Dataset dimensions
  - Variable structure
  - Missing values check
- Descriptive statistics:
  - Overall summary
  - By genotype performance
  - By environment comparison

## Statistical Methods

- Variance component analysis
- ANOVA for G×E effects
- Shapiro-Wilk normality test
- Outlier detection using z-scores
- Replicate correlation assessment

## Visualization

Professional-quality plots including:

- Yield distribution histogram
- Genotype performance boxplots
- Environment comparison plots
- Interaction visualization

## Quality Control

- Normality assessment
- Outlier detection (z-score > 3)
- Replicate consistency checks
