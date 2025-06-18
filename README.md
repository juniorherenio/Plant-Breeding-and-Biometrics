# Plant Breeding and Biometrics Repository

![Banner](https://www.iaea.org/sites/default/files/styles/2016_landing_page_banner_1140x300/public/images/cn263-plantmutation-banner-1140x300.jpg?itok=VUtHKiPE&timestamp=1516966003) <!-- Consider adding a plant breeding-related banner image -->

## Repository Overview
This repository contains statistical tools and analysis pipelines for plant breeding applications, implementing modern biometric methods for breeding programs.

## Key Features
- **Genetic Analysis**: Mixed models, BLUP/REML, and genetic parameter estimation
- **Experimental Designs**: Analysis of RCBD, lattice, alpha designs
- **Selection Tools**: Index selection, genomic prediction pipelines
- **Data Visualization**: Custom plots for breeding trials
- **Multi-Environment Trials**: Stability and GxE interaction analysis

## Main Analysis Categories

### 1. Genetic Parameter Estimation
- Heritability calculations
- Variance component analysis
- Genetic correlation estimation

### 2. Experimental Designs
```r
# Example: RCBD analysis
library(agricolae)
design.rcbd(treatments = 20, reps = 3)
