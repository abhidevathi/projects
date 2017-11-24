# Script Name: 1710-351-451-Proj1-modeling-dxd310.R
# Purpose: Running netSEM Models on the big data frame
# Authors: Abhi Devathi 
# License: Creative Commons Attribution-NonCommercial-ShareAlike-4.0 International License.  
# Latest Changelog Entries: v0.00.01 - 1710-351-451-Proj1-modeling-dxd310
# 

library(tidyverse)
library(ggplot2)
library(netSEM)
root <- "/Users/abhidevathi/Desktop/git/17f-dsci351-451-dxd310/1-assignments/proj/proj1/"
setwd(root)
data.all <- read.table("./AcrylicHardcoats/data/completeDataFrame.csv", sep = ",", header = TRUE)


model.YI1x <- data.all %>%
  dplyr::filter(exposure == '1x') %>%
  dplyr::select(c('dose', 'YI', 'ftir.1250', 'ftir.1700', 'ftir.2900', 'ftir.3350')) %>%
  netSEMm()
model.haze1x <- data.all %>%
  dplyr::filter(exposure == '1x') %>%
  dplyr::select(c('dose', 'Haze', 'ftir.1250', 'ftir.1700', 'ftir.2900', 'ftir.3350')) %>%
  netSEMm()
modelplot.YI1x <- plot(model.YI1x, cutoff = 0.1)
modelplot.haze1x <- plot(model.haze1x, cutoff = 0.1)

## We need to figure out which is the most similar to 1x

haze.plot <- data.all %>%
  filter(exposure == c('ASTMG154', 'ASTMG155', 'mASTMG154', '1x')) %>%
  ggplot(aes(dose, Haze/100, color = exposure)) + 
  geom_jitter(size = 3) + 
  geom_smooth(lwd = 1, se = FALSE) +
  labs(title = "Haze against Dose all samples") + 
  xlab("Dose (MJ/m^2)") + ylab("Haze Percentage (%)")
haze.plot
YI.plot <- data.all %>%
  filter(exposure == c('ASTMG154', 'ASTMG155', 'mASTMG154', '1x')) %>%
  ggplot(aes(dose, YI, color = exposure)) + 
  geom_jitter(size = 3) + 
  geom_smooth(lwd = 1, se = FALSE) +
  labs(title = "Yellowness Index against Dose all samples") + 
  xlab("Dose (MJ/m^2)") + ylab("YI (ASTM E313)")
YI.plot

# From Inspection, it looks like the Modified ASTMG154 exposure is
# Most similar to the 1x exposure.


haze.mASTMG154 <- data.all %>%
  dplyr::filter(exposure == 'mASTMG154') %>%
  dplyr::select(c('dose', 'Haze', 'ftir.1250', 'ftir.1700', 'ftir.2900', 'ftir.3350')) %>%
  netSEMm()
YI.mASTMG154 <- data.all %>%
  dplyr::filter(exposure == 'mASTMG154') %>%
  dplyr::select(c('dose', 'YI', 'ftir.1250', 'ftir.1700', 'ftir.2900', 'ftir.3350')) %>%
  netSEMm()
plot(YI.mASTMG154, cutoff = 0.1)
