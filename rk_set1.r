# Analysis of rk_set1_whole dataset from NHP
# @author: C Heiser
# Mar2019

library('tidyverse')
library('Cardinal')

name <- '20170825_rk_set1_whole'
folder <- './inputs'
data <- readImzML(name, folder, as='MSImagingExperiment')
