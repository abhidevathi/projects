# Script Name: 1709-351-451-Proj1-cleaningColor-dxd310.R
# Purpose: Learning R 
# Authors: Abhi Devathi 
# License: Creative Commons Attribution-NonCommercial-ShareAlike-4.0 International License.  
# Latest Changelog Entries: v0.00.01 - 1709-351-451-Proj1-cleaningColor-dxd310
# 
suppressMessages(library(tidyverse))
suppressMessages(library(tibble))
suppressMessages(library(netSEM))
suppressMessages(library(stringr))

root <- "/Users/abhidevathi/Desktop/git/17f-dsci351-451-dxd310/1-assignments/proj/proj1/"
setwd(root)
dat.example <- read.csv("./1708-351-451-Proj1-example-dataframe.csv")
key <- read.csv("./AcrylicHardcoats/acryhc-key.csv", sep = ",", header = TRUE)
exposures <- read.csv("./AcrylicHardcoats/acryhc-exp.csv", sep = ",", header = TRUE)
exposures <- exposures %>%
  dplyr::rename(mASTMG154 = mASTG154) # This was labeled incorrectly in the CSV Data.


# Renaming the column names in the key file for easier names
key <- key %>%
  dplyr::rename(ID = Sample.Number, material = Product.Name, exposure = Exposure, retain = Step.Number.Retained)

# Let's try changing the material column to two columns, the second as substrate
rearrange.cols <- str_split_fixed(key$material, "-",2)
rearrange.cols <- as.data.frame(rearrange.cols)
names(rearrange.cols) <- list("substrate", "material")
levels(rearrange.cols$substrate) <- c(levels(rearrange.cols$substrate), "PURE")
for (i in 1:nrow(rearrange.cols)) {
  if(str_length(as.character(rearrange.cols$substrate[i])) <= 3) {
    rearrange.cols$material[i] <- rearrange.cols$substrate[i]
    rearrange.cols$substrate[i] <- "PURE"
  }
}
key$material <- NULL
key <- cbind(key, rearrange.cols)


write.csv(key, "./AcrylicHardcoats/acryhc-key-updated.csv", row.names = FALSE)

## First we concatenate all the color data into a single data frame
## and make sure the column names are the same

# Reading in the Color Data for step 0
setwd("./AcrylicHardcoats/color/step0/")
filenames.step0 <- list.files("./", pattern = ".csv")
files.step0 <- lapply(filenames.step0, read.csv)
names(files.step0) <- filenames.step0

color.step0 <- NULL
for (i in 1:length(filenames.step0)) {
  files.step0[[i]]$step <- 0
  color.step0 <- rbind(color.step0, files.step0[[i]])
}

# Reading in the Color Data for step 1
setwd("../step1/")
filenames.step1 <- list.files("./", pattern = ".csv")
files.step1 <- lapply(filenames.step1, read.csv)
names(files.step1) <- filenames.step1
 
color.step1 <- NULL
for (i in 1:length(filenames.step1)) {
 files.step1[[i]]$step <- 1
 color.step1 <- rbind(color.step1, files.step1[[i]])
}

setwd("../step2/")
filenames.step2 <- list.files("./", pattern = ".csv")
files.step2 <- lapply(filenames.step2, read.csv)
names(files.step2) <- filenames.step2

color.step2 <- NULL
for (i in 1:length(filenames.step2)) {
  files.step2[[i]]$step <- 2
  color.step2 <- rbind(color.step2, files.step2[[i]])
}

setwd("../step3/")
filenames.step3 <- list.files("./", pattern = ".csv")
files.step3 <- lapply(filenames.step3, read.csv)
names(files.step3) <- filenames.step3

color.step3 <- NULL
for (i in 1:length(filenames.step3)) {
  files.step3[[i]]$step <- 3
  color.step3 <- rbind(color.step3, files.step3[[i]])
}

setwd("../step4/")
filenames.step4 <- list.files("./", pattern = ".csv")
files.step4 <- lapply(filenames.step4, read.csv)
names(files.step4) <- filenames.step4

color.step4 <- NULL
for (i in 1:length(filenames.step4)) {
  files.step4[[i]]$step <- 4
  color.step4 <- rbind(color.step4, files.step4[[i]])
}

color.binded <- rbind(color.step0, color.step1, color.step2, color.step3, color.step4)
rm(color.step0, color.step1, color.step2, color.step3, color.step4)
rm(files.step0,files.step1, files.step2, files.step3, files.step4)
rm(filenames.step0, filenames.step1, filenames.step2, filenames.step3, filenames.step4)

## Removing values with incorrectly labeled samples 
color.binded <- color.binded %>%
  dplyr::rename(lstar = L., astar = a., bstar = b., YI = YI.E313..D65.10., Haze = Haze...D65.10) %>%
  dplyr::filter(nchar(as.character(ID)) == 10)

setwd("../")
setwd("../data/")
color.all <- merge(key, color.binded, by.x = "ID", all.x = TRUE)

# There are some entries where the baseline is measured again in step 4
# But there's no extra dose so we will change the step value to 0
# To not affect the analysis
for (i in 1:nrow(color.all)) {
  if (color.all$retain[i] == 0)
    color.all$step[i] <- 0
}
write.csv(color.all, file = "compiledColorData.csv", row.names = FALSE)

setwd(root)