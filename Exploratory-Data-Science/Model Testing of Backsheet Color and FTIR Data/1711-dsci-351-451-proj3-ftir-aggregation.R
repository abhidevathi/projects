### This is a script that gets FTIR Data and aggregates it. 
### We will then turn copy this into the rmd.

library(hyperSpec)
library(readr)
setwd("./FTIR/DampHeat-FTIR/")

curFile1 <- FTIR.DH[1]
spectra1 <- read.csv(curFile1, header = FALSE)

# The spectra is only in V2
spectra2 <- read.csv(curFile2, header = FALSE)$V2

spc <- new("hyperSpec", spc = spectra1$V2, wavelength = spectra1$V1)

FTIR.DH <- list.files(path = "./", pattern = "*.dpt")

curFile <- FTIR.DH[1]
m <- regexpr("SPA.*dpt", curFile)

m <-regexpr("P.*.",curFile)
material <- substr(curFile, m, m+attr(m,"match.length")-17)


ftir <- function(dir, exposure) {
  setwd(dir)
  files <- list.files(path = "./", pattern = "*.dpt")
  for (i in 1:length(files)) {
    # Get some metadata from the filename
    curFile <- files[i]
    
    m <- regexpr("SPA.*dpt",curFile)
    id <- substr(curFile, m - 8, m - 8) # sample ID
    id <- paste0("sa3100", id, collapse = "")
    # couponID <- substr(curFile, m - 6, m - 4) # couponID
    mn <- as.numeric(substr(curFile, m - 2, m - 2)) # Measurement Number
    exp <- exposure
    hours <- parse_number(curFile)
    step <- ifelse(hours < 4000, hours/500, 7)
    m <- regexpr("P.*.",curFile)
    material <- substr(curFile, m, m + attr(m,"match.length")-17)
    # Read the dpt file as a csv and grab the second column
    if (i == 1) {
      wavelength <- read.csv(curFile, header = FALSE)$V1
      spectra <- read.csv(curFile, header = FALSE)$V2
    } else {
      spectra <- read.csv(curFile, header = FALSE)$V2
    }
    
    # Create hyperSpec Object
    spectrum <- new("hyperSpec", spc = spectra, wavelength = wavelength)
    if (i == 1) {
      ftir <- spectrum
      
      ftir@data$SampleID <- id
      ftir@data$Exposure <- exp
      
      ftir@data$Material <- material
      
      ftir@data$hours <- hours
      
      ftir@data$Step <- step
      
      ftir@data$Measurement_Times <- mn
      
    } else {
      
      # Add meta data to hyperSpec object
      spectrum@data$SampleID <- id
      spectrum@data$Exposure <- exp
      
      spectrum@data$Material <- material
      
      spectrum@data$hours <- hours
      
      spectrum@data$Step <- step
      
      spectrum@data$Measurement_Times <- mn
      
      
      # Combine spectrum with other spectra
      
      ftir <- hyperSpec::collapse(ftir,spectrum)
    }
  }
  setwd("../")
  return(ftir)
}
