# Genotype by Environment (G×E) Interaction Dataset

This repository contains tools for simulating for genotype by environment interaction (G×E) data for plant breeding trials, using R with FieldSimR.

## Contents

1. [Simulation Code](https://github.com/juniorherenio/Plant-Breeding-and-Biometrics/blob/main/FieldSimR-Simulation/Code.R)
2. [Exploratory Analysis Report](https://github.com/juniorherenio/Plant-Breeding-and-Biometrics/blob/main/FieldSimR-Simulation/EDA-analysis.pdf)
3. [Key Features](#key-features) 
4. [Requirements](#requirements)
5. [Usage](#usage)
6. [Methodology](#methodology)
7. [Output Examples](#output-examples)

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
