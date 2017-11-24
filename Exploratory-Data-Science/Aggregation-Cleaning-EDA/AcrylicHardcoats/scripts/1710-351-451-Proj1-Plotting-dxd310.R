# Script Name: 1710-351-451-Proj1-Plotting-dxd310.R
# Purpose: Making Some Plots and Answering some Questions
# Authors: Abhi Devathi 
# License: Creative Commons Attribution-NonCommercial-ShareAlike-4.0 International License.  
# Latest Changelog Entries: v0.00.01 - 1710-351-451-Proj1-Plotting-dxd310
# 

library(tidyverse)
library(ggplot2)

root <- "/Users/abhidevathi/Desktop/git/17f-dsci351-451-dxd310/1-assignments/proj/proj1/"
setwd(root)

# Let's first bring in the big, bad data frame
setwd("./AcrylicHardcoats/data/")
data.all <- read.table("completeDataFrame.csv", header = TRUE, sep = ",")

# Question 1: What are the dimensions of your data frame?
str(data.all)
# returns 804 observations of 22 variables, so 804 by 22.

# Question 2: Show the head and tail of your data frame

head(data.all)

tail(data.all)


# Question 3 Plot YI and Haze as a function of Dose for each material for 1x exposure
# Do you notice any difference between substrates and coatings?

# Pipe in the data
haze.plot <- data.all %>%
  filter(exposure == '1x') %>%
  ggplot(aes(dose, Haze/100, color = material, shape = substrate)) + 
  geom_jitter(size = 3) + 
  geom_smooth(lwd = 1, se = FALSE) +
  labs(title = "Haze for 1x Outdoor Samples against Dose") + 
  xlab("Dose (MJ/m^2)") + ylab("Haze Percentage (%)") + 
  scale_color_discrete(name = "Substrate") + 
  scale_shape_discrete(name = "Coating")
haze.plot
YI.plot <- data.all %>%
  filter(exposure == '1x') %>%
  ggplot(aes(dose, YI, color = material, shape = substrate)) + 
  geom_jitter(size = 3) + 
  geom_smooth(lwd = 1, se = FALSE) +
  labs(title = "Yellowness Index for 1x Outdoor Samples against Dose") + 
  xlab("Dose (MJ/m^2)") + ylab("Yellowness Index (ASTM E313)") + 
  scale_color_discrete(name = "Substrate") + 
  scale_shape_discrete(name = "Coating")
YI.plot
