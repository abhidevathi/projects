# Script Name: 1709-351-451-Proj1-cleaningFTIR-dxd310.R
# Purpose: Extracting Peaks from the FTIR Data
# Authors: Abhi Devathi 
# License: Creative Commons Attribution-NonCommercial-ShareAlike-4.0 International License.  
# Latest Changelog Entries: v0.00.01 - 1709-351-451-Proj1-cleaningFTIR-dxd310
# 

suppressMessages(library(tidyverse))
suppressMessages(library(tibble))
suppressMessages(library(netSEM))
suppressMessages(library(hyperSpec))

# Make sure you put in the right root directory
root <- "/Users/abhidevathi/Desktop/git/17f-dsci351-451-dxd310/1-assignments/proj/proj1/"
setwd(root)
setwd("./AcrylicHardcoats/")
key <- read.table("acryhc-key-updated.csv", sep = ",", header = TRUE)
setwd("./data/")
color.data <- read.table("compiledColorData.csv", header = TRUE, sep = ",")

setwd("../FTIR/step0")
spc.step0 <- read.table(file = "step0.csv", sep = ",", header = TRUE)

setwd("../step1")
filenames.step1 <- list.files(".")
files.step1 <- lapply(filenames.step1, read.csv, sep = ",")
files.step1[[2]]$Wavenumber <- NULL
spc.step1 <- cbind(files.step1[[1]], files.step1[[2]])

setwd("../step2")
filenames.step2 <- list.files(".")
files.step2 <- lapply(filenames.step2, read.csv, sep = ",")
files.step2[[2]]$Wavenumber <- NULL
spc.step2 <- cbind(files.step2[[1]], files.step2[[2]])

setwd("../step3")
filenames.step3 <- list.files(".")
files.step3 <- lapply(filenames.step3, read.csv, sep = ",")
spc.step3.outdoor <- files.step3[[1]]
spc.step3.indoor <- files.step3[[2]]

setwd("../step4")
filenames.step4 <- list.files(".")
files.step4 <- lapply(filenames.step4, read.csv, sep = ",")
spc.step4 <- files.step4[[1]]


# Function that finds the max value within a range of the given frequency
# Takes in the spectra, a wavenumber column, a given frequency, and an adjustable range.
# Returns the max absorbance (peak) and the wavenumber at which it occurs in a vector
peak_finder <- function(spccolumn, wavenumber, frequency, range = 40){
  # Find the closest value to the given frequency
  index <- which(abs(wavenumber - frequency) == min(abs(wavenumber - frequency)))
  # Find the range of wavenumbers
  indices <- (index - range/2):(index + range/2)
  
  # Find Index of Max Absorbance within the range of the peak
  absorbance.max <- max(spccolumn[indices])
  
  wavenumber.max <- wavenumber[which(spccolumn == absorbance.max)]
  return(c(absorbance.max, wavenumber.max))
}

# Set of peaks we need to find
peaks <- c(1250, 1700, 2900, 3350)

#Creating the data frame so we can use it for later
columns <- c("ID","step","ftir.1250", "ftir.1700", "ftir.2900", "ftir.3350",
             "ftir.1250.wavenum", "ftir.1700.wavenum", "ftir.2900.wavenum",
             "ftir.3350.wavenum")
df.peaks <- setNames(data.frame(matrix(ncol = length(columns), nrow = 0)), columns)
df.peaks[columns] <- sapply(df.peaks[columns], as.numeric)
wavenumber.long <- spc.step0$Wavenumber  # Wavenumber for step0-step3.indoor (checked after inspection)
wavenumber.short <- spc.step4$Wavenumber # Wavenumber for step3.outdoor - step4

# Iterate through all the steps in the data.
spc.step0$Wavenumber <- NULL # so that we only iterate through the spc.step0 data
sample.IDs <- colnames(spc.step0)

for (i in 1:length(spc.step0[1,])){
  sample.ID <- as.character(sample.IDs[i])
  
  # Below, we store the actual peak value.
  ftir.1250 <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[4])[1]
  
  # Here, we store the wavenumber at which the peak occurs
  ftir.1250.wavenum <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step0[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  
  step <- 0
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                        as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                        as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                        as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}

spc.step1$Wavenumber <- NULL # so that we only iterate through the spc.step1 data
sample.IDs <- colnames(spc.step1)

for (i in 1:length(spc.step1[1,])){
  sample.ID <- as.character(sample.IDs[i])
  ftir.1250 <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[4])[1]
  
  ftir.1250.wavenum <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step1[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  step <- 1
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                           as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                           as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                           as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}

spc.step2$Wavenumber <- NULL # so that we only iterate through the spc.step2 data
sample.IDs <- colnames(spc.step2)

for (i in 1:length(spc.step2[1,])){
  sample.ID <- as.character(sample.IDs[i])
  ftir.1250 <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[4])[1]
  
  ftir.1250.wavenum <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step2[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  step <- 2
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                           as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                           as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                           as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}

spc.step3.indoor$Wavenumber <- NULL # so that we only iterate through the spc.step3.indoor data
sample.IDs <- colnames(spc.step3.indoor)

for (i in 1:length(spc.step3.indoor[1,])){
  sample.ID <- as.character(sample.IDs[i])
  ftir.1250 <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[4])[1]
  
  ftir.1250.wavenum <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step3.indoor[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  step <- 3
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                           as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                           as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                           as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}

spc.step3.outdoor$Wavenumber <- NULL # so that we only iterate through the spc.step3.outdoor data
sample.IDs <- colnames(spc.step3.outdoor)

for (i in 1:length(spc.step3.outdoor[1,])){
  sample.ID <- as.character(sample.IDs[i])
  ftir.1250 <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.short, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.short, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.short, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.short, frequency = peaks[4])[1]
  
  ftir.1250.wavenum <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step3.outdoor[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  
  step <- 3
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                           as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                           as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                           as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}

spc.step4$Wavenumber <- NULL # so that we only iterate through the spc.step4 data
sample.IDs <- colnames(spc.step4)

for (i in 1:length(spc.step4[1,])){
  sample.ID <- as.character(sample.IDs[i])
  ftir.1250 <- peak_finder(spc.step4[,i], wavenumber = wavenumber.short, frequency = peaks[1])[1]
  ftir.1700 <- peak_finder(spc.step4[,i], wavenumber = wavenumber.short, frequency = peaks[2])[1]
  ftir.2900 <- peak_finder(spc.step4[,i], wavenumber = wavenumber.short, frequency = peaks[3])[1]
  ftir.3350 <- peak_finder(spc.step4[,i], wavenumber = wavenumber.short, frequency = peaks[4])[1]
  
  ftir.1250.wavenum <- peak_finder(spc.step4[,i], wavenumber = wavenumber.long, frequency = peaks[1])[2]
  ftir.1700.wavenum <- peak_finder(spc.step4[,i], wavenumber = wavenumber.long, frequency = peaks[2])[2]
  ftir.2900.wavenum <- peak_finder(spc.step4[,i], wavenumber = wavenumber.long, frequency = peaks[3])[2]
  ftir.3350.wavenum <- peak_finder(spc.step4[,i], wavenumber = wavenumber.long, frequency = peaks[4])[2]
  step <- 4
  each.observation <- list(sample.ID, step, as.numeric(ftir.1250), as.numeric(ftir.1700), 
                           as.numeric(ftir.2900), as.numeric(ftir.3350), as.numeric(ftir.1250.wavenum),
                           as.numeric(ftir.1700.wavenum), as.numeric(ftir.2900.wavenum),
                           as.numeric(ftir.3350.wavenum))
  df.peaks[nrow(df.peaks) + 1,] <- each.observation
  
}
# Here we are merging the color data and the FTIR data to make the full, cleaned
# Data frame for analysis later on.
colorPlusFTIR <- merge(color.data, df.peaks, by = c("ID", "step"), all.x = TRUE)
setwd("../")
setwd("../data/")
write.csv(df.peaks, file = "ftirPeakData.csv", row.names = FALSE)
write.csv(colorPlusFTIR, file = "colorPlusFTIR.csv", row.names = FALSE)
setwd(root)