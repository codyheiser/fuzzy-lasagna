# Analysis of rk_set1_whole dataset from NHP
# @author: C Heiser
# Mar2019

library('tidyverse')
library('Cardinal')

# read into MSImagingExperiment object
name <- '20170825_rk_set1_whole'
folder <- './inputs'
rk.set1.whole <- readImzML(name, folder, as='MSImagingExperiment', attach.only=T) 

#saveRDS(rk.set1.whole, 'inputs/rsk_set1_whole.rds') # save RDS file for loading later

# simple queries by pixel and feature
dim(rk.set1.whole) # number of features (rows) and pixels (columns) in dataset
head(coord(rk.set1.whole)) # x and y coordinates for each pixel ID
coord(rk.set1.whole)[20,] # x and y coordinates for pixel 20
pixels(rk.set1.whole, coord=list(x=230, y=380)) # pixel ID for given x and y coordinates
range(mz(rk.set1.whole)) # minimum and maximum m/z values in feature set

# subset MSImageSet by m/z values [600,900] and pixel coordinates
rk.set1.whole %>%
  
# output feature range should reflect filter
range(mz(tmp))

rk.set1.whole %>%
  # select pixels
  select(x > 350, y > 370) %>%
  # filter spectral features
  filter(mz > 600, mz < 700) %>%
  # queue default processing to workflow
  smoothSignal() %>%
  reduceBaseline() %>%
  peakPick() %>%
  peakFilter() %>%
  # execute queued processing
  process(plot=TRUE, 
          par=list(layout=c(1,3)), 
          BPPARAM=SerialParam()) -> tmp
