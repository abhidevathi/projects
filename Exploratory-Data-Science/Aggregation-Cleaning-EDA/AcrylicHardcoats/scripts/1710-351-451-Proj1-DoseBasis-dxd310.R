# Script Name: 1710-351-451-Proj1-DoseBasis-dxd310.R
# Purpose: Converting the exposures to a Dose Basis for Analysis
# Authors: Abhi Devathi 
# License: Creative Commons Attribution-NonCommercial-ShareAlike-4.0 International License.  
# Latest Changelog Entries: v0.00.01 - 1710-351-451-Proj1-DoseBasis-dxd310
# 
library(tidyverse)
library(ggplot2)

# Make sure you set the right root!
root <- "/Users/abhidevathi/Desktop/git/17f-dsci351-451-dxd310/1-assignments/proj/proj1/"
setwd(root)
setwd("./AcrylicHardcoats/data/")
colorPlusFTIR <- read.csv("colorPlusFTIR.csv", header = TRUE, sep = ",")

setwd("../")
exposures <- read.csv("acryhc-exp.csv", header = TRUE, sep = ",")

# Replace the per step hour time with a cumulative sum
# So the data frame reads "at step 3, sample SA was exposed for x hours"
# Start at 2 to skip the step column (we don't want to cumulate the number of steps)
for (i in 2:ncol(exposures)){ 
  exposures[,i] <- cumsum(exposures[,i])
}

# Rename the columns for more readable variable names,
# and gather the exposures into a single column with tidyr
exposures <- exposures %>%
  dplyr::rename(step = Steps, mASTMG154 = mASTG154, '1x' = X1x, '5x' = X5x) %>%
  tidyr::gather(exposure, hours, baseline:'5x', na.rm = TRUE)

# Merge the exposure file with previous data
dat.0 <- merge(exposures, colorPlusFTIR, by = c("exposure", "step"), na.rm = FALSE,
               all.y = TRUE)


# All Doses are in MegaJoules per meter^2
# This data frame contains the dose and doseType value for each exposure type
doses <- data.frame(c('mASTMG154', 1,   0.21835, 'uva340'),
                    c('ASTMG154',  1,   8/12*0.21835, 'uva340'),
                    c('ASTMG155',  1,   .09382, 'uva340'),
                    c('1x',        1,   .04599, 'fullSpectrum'),
                    c('5x',       NA,   NA, 'fullSpectrum'),
                    c('baseline', 1,  0,         NA),
                    c('HF',       1,  NA,        NA))
doses <- as.data.frame(t(doses))
names(doses) <- list('exposure', 'hours', 'dose', 'doseType')
# The next four lines are needed to remove any funky business from R
# and to keep a clean data frame.
setwd("./data")
write.csv(doses, 'doses.csv', row.names = FALSE)
rm(doses)
doses <- read.csv('doses.csv', header = TRUE, sep = ",")

# Here we initialize the dose and doseType columns of the big data frame
dat.0$dose <- NA 
dat.0$doseType <- NA
# Now it's time to add the doses to the big data frame!
for (i in 1:nrow(dat.0)) {
  exp.specific <- as.character(dat.0$exposure[i]) # Find the exposure of this obs
  
  # Find the index of the corresponding exposure in the doses data frame.
  which.dose <- which(as.character(doses$exposure) == exp.specific)
  dose.onehour <- doses$dose[which.dose] # Find the dose value per hour of exposure
  # Enter in the total dose by multiplying hours of exposure by dose per hour
  dat.0$dose[i] <- dat.0$hours[i]*dose.onehour*doses$hours[which.dose]
  # Enter in the doseType to the big data frame
  dat.0$doseType[i] <- as.character(doses$doseType[which.dose])
  # change to factor because R is funky!
  dat.0$doseType <- factor(dat.0$doseType, levels = c("uva340", 'tuv280400', 'fullSpectrum'))
}

# Finally, we notice exposure became first column, but we want ID to be first
# So we switch them.
dat.0[,c("exposure","ID")] <- dat.0[,c("ID","exposure")]
dat.0 <- dat.0 %>%
  dplyr::rename(ID = exposure, exposure = ID)

data.final <- dat.0
rm(dat.0)
write.csv(data.final, "completeDataFrame.csv", row.names = FALSE)
setwd(root)