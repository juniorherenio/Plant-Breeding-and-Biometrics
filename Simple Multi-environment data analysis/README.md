# Simple Multi-environment Data Analysis

![Plant Breeding](https://img.shields.io/badge/Field-Phenotyping-green)
![Biometrics](https://img.shields.io/badge/Analysis-ANOVA-blue)
![R](https://img.shields.io/badge/language-R-red)

This repository contains a comprehensive RMarkdown script for analyzing multi-environment plant breeding trials using simulated data from FieldSimR.

## Features

- **Data Preparation**: Import and structure field trial data
- **Statistical Analysis**:
  - Individual environment ANOVA (RCBD design)
  - Joint ANOVA across environments
  - LSD test for genotype comparisons
- **Genetic Parameter Estimation**:
  - Variance component analysis
  - Broad-sense heritability
  - Phenotypic coefficients of variation
- **Correlation Analysis**:
  - Phenotypic correlations
  - Genetic correlations
  - Environmental correlations
- **Visualization**:
  - Interactive correlation matrices
  - Bar plots for environmental effects
  - Genotype performance comparisons

## Requirements

- R (≥ 4.0.0)
- RStudio (recommended)
- Required R packages (automatically installed by script):
  - `tidyverse`, `agricolae`, `metan`, `ggcorrplot`, `corrplot`, `kableExtra`

## Usage

1. Clone this repository
2. Open `Simple_Multi-environment_data_analysis.Rmd` in RStudio
3. Ensure your data is in `field_data.xlsx` format (see example structure below)
4. Knit the document to generate PDF report

## Data Structure

The script expects an Excel file (`field_data.xlsx`) with columns:
- `Genotype`: Factor (20 levels)
- `Environment`: Factor (15 levels)
- `Rep`: Factor (3 levels)
- `Yield`: Numeric (phenotypic measurements)

Example simulated data is available from [FieldSimR-Simulation](https://github.com/juniorherenio/Plant-Breeding-and-Biometrics/tree/main/FieldSimR-Simulation).

## Key Analyses

```r
# Example code structure:
1. Data preparation and quality checks
2. Individual environment ANOVA (RCBD)
3. Joint ANOVA across environments  
4. Variance component estimation
5. Genetic parameter calculation
6. Correlation analyses
7. Visualization of results
