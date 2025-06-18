# Multigeneration Common Bean Breeding Analysis
# ASReml-R Mixed Models Approach

# Load required packages
library(readxl)
library(dplyr)
library(ggplot2)
library(asreml)
library(ComplexHeatmap)
library(RColorBrewer)
library(gridExtra)

asreml.options(ai.sing = TRUE)
source("https://raw.githubusercontent.com/saulo-chaves/May_b_useful/main/update_asreml.R") # update model

# Data preparation --------------------------------------------------------
setwd("~/GitHub/Multigeneration-analysis")
dataset_nodba <- read_excel("data.xlsx") %>% 
  mutate(across(-ncol(.), factor),
         Yield = as.numeric(Yield)) %>%
  rename(Genotype = 1, Block = 2, Generation = 5, Yield = 6) %>%
  mutate(across(everything(), ~na_if(., 0)))

# Model 1: ID for G and R, DIAG for B -------------------------------------
M1 <- asreml(
  fixed = Yield ~ Generation + Rep:Generation + Pop:at(Generation, "F4:6"),
  random = ~ Genotype:idv(Generation) + Block:at(Generation, c("F4:7", "F4:8", "F4:9")),
  residual = ~ units,
  data = dataset_nodba
)

# Model diagnostics
sum.m1 <- summary(M1)$varcomp
blup.m1 <- predict(M1, classify = "Genotype:Generation")$pvals

# Model evaluation metrics
m1_metrics <- data.frame(
  Model = "M1 (ID-ID)",
  AIC = summary(M1)$aic,
  BIC = summary(M1)$bic,
  Heritability = 1 - (mean((predict(M1, sed=TRUE)$sed^2)) / 
                      (2*sum.m1["Genotype","component"])),
  GeneticGain = (mean(head(blup.m1[order(-blup.m1$predicted.value), "predicted.value"], 20)) - 
                 mean(dataset_nodba$Yield, na.rm=T)) / 
                mean(dataset_nodba$Yield, na.rm=T) * 100
)

# Model 2: ID for G, DIAG for B and R -------------------------------------
M2 <- asreml(
  fixed = Yield ~ Generation + Rep:Generation + Pop:at(Generation, "F4:6"),
  random = ~ Genotype:idv(Generation) + Block:at(Generation, c("F4:7", "F4:8", "F4:9")),
  residual = ~ dsum(~units|Generation),
  data = dataset_nodba
)

# Model diagnostics
sum.m2 <- summary(M2)$varcomp
blup.m2 <- predict(M2, classify = "Genotype:Generation")$pvals

# Model evaluation metrics
m2_metrics <- data.frame(
  Model = "M2 (ID-DIAG)",
  AIC = summary(M2)$aic,
  BIC = summary(M2)$bic,
  Heritability = 1 - (mean((predict(M2, sed=TRUE)$sed^2) / 
                      (2*sum.m2["Genotype","component"])),
  GeneticGain = (mean(head(blup.m2[order(-blup.m2$predicted.value), "predicted.value"], 20)) - 
                mean(dataset_nodba$Yield, na.rm=T)) / 
               mean(dataset_nodba$Yield, na.rm=T) * 100
)

# Model 3: DIAG for G, B and R --------------------------------------------
M3 <- asreml(
  fixed = Yield ~ Generation + Rep:Generation + Pop:at(Generation, "F4:6"),
  random = ~ Genotype:at(Generation) + Block:at(Generation, c("F4:7", "F4:8", "F4:9")),
  residual = ~ dsum(~units|Generation),
  data = dataset_nodba
)

# Model diagnostics
sum.m3 <- summary(M3)$varcomp
blup.m3 <- predict(M3, classify = "Genotype:Generation")$pvals

# Model evaluation metrics
m3_metrics <- data.frame(
  Model = "M3 (DIAG-DIAG)",
  AIC = summary(M3)$aic,
  BIC = summary(M3)$bic,
  Heritability = mean(1 - (diag(predict(M3, vcov=TRUE)$vcov) / 
                   sum.m3[grep('Genotype',rownames(sum.m3)), 1]),
  GeneticGain = (mean(head(blup.m3[order(-blup.m3$predicted.value), "predicted.value"], 20)) - 
                mean(dataset_nodba$Yield, na.rm=T)) / 
               mean(dataset_nodba$Yield, na.rm=T) * 100
)

# Model 4: CORGH for G, DIAG for B and R ----------------------------------
M4 <- asreml(
  fixed = Yield ~ Generation + Rep:Generation + Pop:at(Generation, "F4:6"),
  random = ~ Genotype:corgh(Generation) + Block:at(Generation, c("F4:7", "F4:8", "F4:9")),
  residual = ~ dsum(~units|Generation),
  data = dataset_nodba
)

# Model diagnostics
M4.update <- update(M4)
sum.m4 <- summary(M4.update)$varcomp
blup.m4 <- predict(M4.update, classify = "Genotype:Generation")$pvals

# Model evaluation metrics
m4_metrics <- data.frame(
  Model = "M4 (CORGH-DIAG)",
  AIC = summary(M4.update)$aic,
  BIC = summary(M4.update)$bic,
  Heritability = mean(1 - (diag(predict(M4.update, vcov=TRUE)$vcov) / 
                      diag(vcov(M4.update)$Genotype)),
  GeneticGain = (mean(head(blup.m4[order(-blup.m4$predicted.value), "predicted.value"], 20)) - 
                mean(dataset_nodba$Yield, na.rm=T)) / 
               mean(dataset_nodba$Yield, na.rm=T) * 100
)

# Model 5: FA1 for G, DIAG for B and R ------------------------------------
M5 <- asreml(
  fixed = Yield ~ Generation + Rep:Generation + Pop:at(Generation, "F4:6"),
  random = ~ Genotype:fa(Generation,1) + Block:at(Generation, c("F4:7", "F4:8", "F4:9")),
  residual = ~ dsum(~units|Generation),
  data = dataset_nodba,
  predict = predict.asreml(classify = "Genotype:Generation")
)

# Model diagnostics
M5.update <- up.mod(M5)
sum.m5 <- summary(M5.update)$varcomp
blup.m5 <- predict(M5.update, classify = "Genotype")$pvals

# Model evaluation metrics
m5_metrics <- data.frame(
  Model = "M5 (FA1-DIAG)",
  AIC = summary(M5.update)$aic,
  BIC = summary(M5.update)$bic,
  Heritability = mean(1 - (diag(predict(M5.update, vcov=TRUE)$vcov) / 
                      diag(vcov(M5.update)$Genotype)),
  GeneticGain = (mean(head(blup.m5[order(-blup.m5$predicted.value), "predicted.value"], 20)) - 
                mean(dataset_nodba$Yield, na.rm=T)) / 
               mean(dataset_nodba$Yield, na.rm=T) * 100,
  ExpVar = (sum(diag(lambda %*% t(lambda)))/
           sum(diag(lambda %*% t(lambda) + psi)))*100
)

# Combine all model results ------------------------------------------------
model_comparison <- bind_rows(m1_metrics, m2_metrics, m3_metrics, 
                             m4_metrics, m5_metrics)

# Visualizations ----------------------------------------------------------

## Model comparison plot
ggplot(model_comparison, aes(x = Model, y = Heritability)) +
  geom_col(fill = "lightblue", color = "black") +
  labs(title = "Model Comparison by Heritability", y = "Heritability") +
  theme_classic()

## Genetic correlation heatmap (from best model M5)
gencorr <- cov2cor(vcov(M5.update)$Genotype)
Heatmap(
  gencorr,
  name = "Genetic\nCorrelation",
  col = colorRamp2(c(0, 1), c("white", "darkblue")),
  cell_fun = function(j, i, x, y, w, h, fill) {
    grid.text(sprintf("%.2f", gencorr[i, j]), x, y, gp = gpar(fontsize = 10))
  }
)

## BLUPs distribution from best model
ggplot(blup.m5, aes(predicted.value)) +
  geom_histogram(fill = "lightblue", color = "darkblue", bins = 20) +
  labs(x = "Predicted Genetic Value", y = "Count") +
  theme_classic()
