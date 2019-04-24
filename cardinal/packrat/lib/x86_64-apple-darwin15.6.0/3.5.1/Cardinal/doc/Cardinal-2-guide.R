### R code from vignette source 'Cardinal-2-guide.Rnw'

###################################################
### code chunk number 1: Cardinal-2-guide.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: Cardinal-2-guide.Rnw:27-32
###################################################
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)
options(width=100)
register(SerialParam())


###################################################
### code chunk number 3: Cardinal-2-guide.Rnw:62-64 (eval = FALSE)
###################################################
## install.packages("BiocManager")
## BiocManager::install("Cardinal")


###################################################
### code chunk number 4: Cardinal-2-guide.Rnw:80-83 (eval = FALSE)
###################################################
## name <- "common name of your .imzML and .ibd files"
## folder <- "/path/to/the/folder/containing/the/files"
## data <- readImzML(name, folder, as="MSImagingExperiment")


###################################################
### code chunk number 5: Cardinal-2-guide.Rnw:92-94 (eval = FALSE)
###################################################
## # import large datasets without loading them into memory
## data <- readImzML(name, folder, attach.only=TRUE, as="MSImagingExperiment")


###################################################
### code chunk number 6: Cardinal-2-guide.Rnw:101-109 (eval = FALSE)
###################################################
## # import 'processed' data between m/z 500 - 600
## data <- readImzML(name, folder, mass.range=c(500,600), as="MSImagingExperiment")
## 
## # import 'processed' data binned to 100 ppm
## data <- readImzML(name, folder, resolution=100, units="ppm", as="MSImagingExperiment")
## 
## # import 'processed' data binned to 1 m/z
## data <- readImzML(name, folder, resolution=1, units="mz", as="MSImagingExperiment")


###################################################
### code chunk number 7: Cardinal-2-guide.Rnw:114-115 (eval = FALSE)
###################################################
## writeImzML(data, name, folder, mz.type="64-bit float", intensity.type="32-bit float")


###################################################
### code chunk number 8: Cardinal-2-guide.Rnw:128-131 (eval = FALSE)
###################################################
## name <- "common name of your .hdr, .img, and .t2m files"
## folder <- "/path/to/the/folder/containing/the/files"
## data <- readAnalyze(name, folder, as="MSImagingExperiment")


###################################################
### code chunk number 9: Cardinal-2-guide.Rnw:136-138 (eval = FALSE)
###################################################
## # import large datasets without loading them into memory
## data <- readAnalyze(name, folder, attach.only=TRUE, as="MSImagingExperiment")


###################################################
### code chunk number 10: Cardinal-2-guide.Rnw:143-144 (eval = FALSE)
###################################################
## writeAnalyze(data, name, folder, intensity.type="16-bit integer")


###################################################
### code chunk number 11: Cardinal-2-guide.Rnw:153-155 (eval = FALSE)
###################################################
## file <- "/path/to/an/imaging/data/file.extension"
## data <- readMSIData(file, as="MSImagingExperiment")


###################################################
### code chunk number 12: Cardinal-2-guide.Rnw:180-182
###################################################
xdf <- XDataFrame(a=1:10, b=letters[1:10])
xdf


###################################################
### code chunk number 13: Cardinal-2-guide.Rnw:192-198
###################################################
coord <- expand.grid(x=1:9, y=1:9)
run <- factor(rep("Run 1", nrow(coord)))
pid <- seq_len(nrow(coord))

pdata <- PositionDataFrame(run=run, coord=coord, pid=pid)
pdata


###################################################
### code chunk number 14: Cardinal-2-guide.Rnw:203-204
###################################################
head(run(pdata))


###################################################
### code chunk number 15: Cardinal-2-guide.Rnw:209-210
###################################################
coord(pdata)


###################################################
### code chunk number 16: Cardinal-2-guide.Rnw:215-217
###################################################
gridded(pdata)
resolution(pdata)


###################################################
### code chunk number 17: Cardinal-2-guide.Rnw:230-235
###################################################
mz <- seq(from=500, to=600, by=0.2)
fid <- seq_along(mz)

fdata <- MassDataFrame(mz=mz, fid=fid)
fdata


###################################################
### code chunk number 18: Cardinal-2-guide.Rnw:240-242
###################################################
head(mz(fdata))
resolution(fdata)


###################################################
### code chunk number 19: Cardinal-2-guide.Rnw:253-260
###################################################
set.seed(1)
data0 <- generateSpectrum(nrow(pdata), range=c(500, 600), peaks=3,
  baseline=3000, noise=0.01, sd=0.5, resolution=300, step=0.2)
data1 <- generateSpectrum(nrow(pdata), range=c(500, 600), peaks=3,
  baseline=3000, noise=0.01, sd=0.5, resolution=300, step=0.2)
idata <- ImageArrayList(list(data0=data0$x, data1=data1$x))
idata


###################################################
### code chunk number 20: Cardinal-2-guide.Rnw:265-267
###################################################
dim(idata[[1]])
dim(idata[["data1"]])


###################################################
### code chunk number 21: Cardinal-2-guide.Rnw:282-284
###################################################
msdata <- MSImagingExperiment(imageData=idata, featureData=fdata, pixelData=pdata)
msdata


###################################################
### code chunk number 22: Cardinal-2-guide.Rnw:289-292
###################################################
imageData(msdata)
pixelData(msdata)
featureData(msdata)


###################################################
### code chunk number 23: Cardinal-2-guide.Rnw:297-301
###################################################
dim(iData(msdata))
dim(iData(msdata, 1))
dim(iData(msdata, "data0"))
dim(spectra(msdata))


###################################################
### code chunk number 24: Cardinal-2-guide.Rnw:316-318
###################################################
msdata0 <- MSImagingExperiment(imageData=data0$x, featureData=fdata, pixelData=pdata)
msdata0


###################################################
### code chunk number 25: Cardinal-2-guide.Rnw:331-335
###################################################
t <- matter::rep_vt(list(data1$t), ncol(data1$x))
x <- lapply(1:ncol(data1$x), function(i) data1$x[,i])
data1b <- matter::sparse_mat(data=list(keys=t, values=x),
  nrow=length(t[[1]]), ncol=length(x), keys=t[[1]])


###################################################
### code chunk number 26: Cardinal-2-guide.Rnw:340-342
###################################################
msdata1 <- MSImagingExperiment(imageData=data1b, featureData=fdata, pixelData=pdata)
msdata1


###################################################
### code chunk number 27: Cardinal-2-guide.Rnw:351-355
###################################################
head(mzData(msdata1)[[1]]) # m/z of spectrum 1
head(peakData(msdata1)[[1]]) # intensities of spectrum 1
head(mzData(msdata1)[[2]]) # m/z of spectrum 2
head(peakData(msdata1)[[2]]) # intensities of spectrum 2


###################################################
### code chunk number 28: Cardinal-2-guide.Rnw:372-374
###################################################
msdata[1:10,]
msdata[,1:10]


###################################################
### code chunk number 29: Cardinal-2-guide.Rnw:379-380
###################################################
cbind(msdata0, msdata1)


###################################################
### code chunk number 30: Cardinal-2-guide.Rnw:387-389
###################################################
select(msdata, x < 4, y < 4) # select based on pixels
filter(msdata, mz < 550) # filter based on m/z features


###################################################
### code chunk number 31: Cardinal-2-guide.Rnw:398-401
###################################################
msdata %>%
  select(x < 5, y < 5) %>%
  filter(mz > 525)


###################################################
### code chunk number 32: Cardinal-2-guide.Rnw:411-415
###################################################
tic <- pixelApply(msdata, sum, BPPARAM=SerialParam()) # calculate TIC
head(tic)
ms <- featureApply(msdata, mean, BPPARAM=SerialParam()) # calculate mean spectrum
head(ms)


###################################################
### code chunk number 33: Cardinal-2-guide.Rnw:428-430
###################################################
summarize(msdata, sum, .by="pixel") # calculate TIC
summarize(msdata, .stat="mean") # calculate mean spectrum


###################################################
### code chunk number 34: plot0
###################################################
plot(msdata, pixel=1)


###################################################
### code chunk number 35: plot1
###################################################
plot(msdata, coord=list(x=2, y=2))


###################################################
### code chunk number 36: Cardinal-2-guide.Rnw:477-478
###################################################
plot(msdata, pixel=1)


###################################################
### code chunk number 37: Cardinal-2-guide.Rnw:485-486
###################################################
plot(msdata, coord=list(x=2, y=2))


###################################################
### code chunk number 38: image0
###################################################
image(msdata, feature=1)


###################################################
### code chunk number 39: image1
###################################################
image(msdata, mz=550, plusminus=0.5)


###################################################
### code chunk number 40: Cardinal-2-guide.Rnw:515-516
###################################################
image(msdata, feature=1)


###################################################
### code chunk number 41: Cardinal-2-guide.Rnw:523-524
###################################################
image(msdata, mz=550, plusminus=0.5)


###################################################
### code chunk number 42: Cardinal-2-guide.Rnw:557-559
###################################################
tmp <- process(msdata, function(x) x + 1, label="add1")
tmp


###################################################
### code chunk number 43: Cardinal-2-guide.Rnw:566-574
###################################################
tmp <- msdata %>%
  process(function(x) ifelse(x > 0, x, 0), label="pos", delay=TRUE) %>%
  process(function(x) x + 1, label="add1", delay=TRUE) %>%
  process(log2, label="log2", delay=TRUE) %>%
  select(x <= 4, y <= 4) %>%
  filter(mz < 550)

process(tmp, BPPARAM=SerialParam())


###################################################
### code chunk number 44: process0 (eval = FALSE)
###################################################
## tmp <- msdata %>%
##   smoothSignal() %>%
##   reduceBaseline() %>%
##   peakPick() %>%
##   peakFilter() %>%
##   select(x == 1, y == 1) %>%
##   process(plot=TRUE,
##     par=list(layout=c(1,3)),
##     BPPARAM=SerialParam())


###################################################
### code chunk number 45: Cardinal-2-guide.Rnw:601-602
###################################################
tmp <- msdata %>%
  smoothSignal() %>%
  reduceBaseline() %>%
  peakPick() %>%
  peakFilter() %>%
  select(x == 1, y == 1) %>%
  process(plot=TRUE,
    par=list(layout=c(1,3)),
    BPPARAM=SerialParam())


###################################################
### code chunk number 46: Cardinal-2-guide.Rnw:656-658
###################################################
msdata0b <- as(msdata0, "MSImageSet")
msdata0b


###################################################
### code chunk number 47: Cardinal-2-guide.Rnw:663-665
###################################################
msdata0c <- as(msdata0b, "MSImagingExperiment")
msdata0c


###################################################
### code chunk number 48: Cardinal-2-guide.Rnw:675-676
###################################################
toLatex(sessionInfo())


