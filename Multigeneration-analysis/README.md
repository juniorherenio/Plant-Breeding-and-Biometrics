# Multi-Generation Common Bean Breeding Analysis

![Field Research](https://img.shields.io/badge/Field-Phenotyping-green)
![Statistical Analysis](https://img.shields.io/badge/Analysis-Mixed_Models-blue)
![Programming](https://img.shields.io/badge/language-R-red)
![DOI](https://img.shields.io/badge/DOI-10.1002%2Fagj2.70042-blue)

## 📌 Study Overview
This comprehensive analysis evaluates selection efficiency in common bean breeding by connecting sequential trials under different experimental designs. The study addresses key challenges in breeding programs, particularly genetic and statistical unbalanced data across generations.

## 🎯 Research Objectives
- Assess the impact of grain yield data (kg ha⁻¹) on selection accuracy
- Compare statistical models for analyzing multi-generation breeding data
- Improve genetic gain estimation in unbalanced data breeding trials
- Develop a robust framework for multi-generation breeding analysis

## 🔬 Experimental Design
### Trial Phases
1. **Initial Evaluation (F4:6 Generation)**:
   - 400 progenies
   - 20 trials using randomized complete block design (RCBD)
   - Conducted during 2019 dry season

2. **Advanced Evaluation**:
   - 95 selected progenies
   - Triple 10 × 10 lattice design
   - Three growing seasons:
     - Rainy season 2019
     - Winter 2020
     - Rainy season 2020

## 📊 Statistical Approach
Five mixed models were compared using ASReml-R, differing in their (co)variance structures for:
- Residual variances
- Genetic components across generations

### Model Specifications:
| Model | Genetic Structure | Residual Structure | Description |
|-------|-------------------|--------------------|-------------|
| M1    | ID                | ID                 | Identity structure |
| M2    | ID                | DIAG               | Heterogeneous residuals |
| M3    | DIAG              | DIAG               | Diagonal structure |
| M4    | CORGH             | DIAG               | General correlation |
| M5    | FA1               | DIAG               | Factor analytic |

## 🔑 Key Findings
- **Optimal Model**: First-order factor analytic structure (FA1) for progenies with heterogeneous residual variances
- **Genetic Gain**: 68% higher than traditional models
- **Heritability**: Significant improvement in estimation accuracy
- **Classification**: Notable changes in progeny rankings across seasons

## 💻 Code Implementation
The analysis was implemented in R using ASReml-R for mixed model analysis. Key functionalities include:

## 📚 Complete Publication
The full article detailing this research is available at:

**"Application of linear mixed models to overcome challenges of unbalanced data in common bean breeding"**  
Agronomy Journal (2025)  
🔗 [Full Article Available Here](https://acsess.onlinelibrary.wiley.com/doi/10.1002/agj2.70042)  
DOI: 10.1002/agj2.70042

[![DOI](https://img.shields.io/badge/DOI-10.1002%2Fagj2.70042-blue)](https://doi.org/10.1002/agj2.70042)


```r
# Main analysis workflow
1. Data preparation and quality control
2. Model specification and fitting
3. Model comparison using AIC/BIC
4. Genetic parameter estimation
5. Visualization of results

# Key packages
- asreml: Advanced mixed models
- ggplot2: Data visualization
- ComplexHeatmap: Correlation visualization
