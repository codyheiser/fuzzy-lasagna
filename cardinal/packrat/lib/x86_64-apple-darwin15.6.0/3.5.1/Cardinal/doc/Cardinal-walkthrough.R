### R code from vignette source 'Cardinal-walkthrough.Rnw'

###################################################
### code chunk number 1: Cardinal-walkthrough.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: Cardinal-walkthrough.Rnw:27-31
###################################################
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)
options(width=100)


###################################################
### code chunk number 3: Cardinal-walkthrough.Rnw:72-75 (eval = FALSE)
###################################################
## name <- "This is the common name of your .hdr, .img, and .t2m files"
## folder <- "/This/is/the/path/to/the/folder/containing/the/files"
## data <- readAnalyze(name, folder)


###################################################
### code chunk number 4: Cardinal-walkthrough.Rnw:89-92 (eval = FALSE)
###################################################
## name <- "This is the common name of your .imzML and .ibd files"
## folder <- "/This/is/the/path/to/the/folder/containing/the/files"
## data <- readImzML(name, folder)


###################################################
### code chunk number 5: Cardinal-walkthrough.Rnw:105-107 (eval = FALSE)
###################################################
## file <- "/This/is/the/path/to/an/imaging/data/file.extension"
## data <- readMSIData(file)


###################################################
### code chunk number 6: Cardinal-walkthrough.Rnw:115-117 (eval = FALSE)
###################################################
## save(data, file="/Where/to/save/the/data.RData")
## load("/Where/to/save/the/data.RData")


###################################################
### code chunk number 7: Cardinal-walkthrough.Rnw:142-155
###################################################
pattern <- factor(c(0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0,
	0, 0, 0, 0, 0, 0, 1, 2, 2, 0, 0, 0, 0, 0, 2, 1, 1, 2,
	2, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 0, 0, 0, 0, 1, 2, 2,
	2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0),
	levels=c(0,1,2), labels=c("blue", "black", "red"))

set.seed(1)
msset <- generateImage(pattern, coord=expand.grid(x=1:9, y=1:9),
	range=c(1000, 5000), centers=c(2000, 3000, 4000),
	resolution=100, step=3.3, as="MSImageSet")

summary(msset)


###################################################
### code chunk number 8: Cardinal-walkthrough.Rnw:170-173
###################################################
head(mz(msset), n=10) # first 10 m/z values
head(coord(msset), n=10) # first 10 pixel coordinates
head(spectra(msset)[,1], n=10) # first 10 intensities in the first mass spectrum


###################################################
### code chunk number 9: Cardinal-walkthrough.Rnw:178-182
###################################################
nrow(msset)
ncol(msset)
dim(msset)
dims(msset)


###################################################
### code chunk number 10: Cardinal-walkthrough.Rnw:187-192
###################################################
features(msset, mz=3000) # returns the feature number most closely matching m/z 3000
mz(msset)[607]
pixels(msset, coord=list(x=5, y=5)) # returns the pixel number for x = 5, y = 5
pixels(msset, x=5, y=5) # also returns the pixel number for x = 5, y = 5
coord(msset)[41,]


###################################################
### code chunk number 11: Cardinal-walkthrough.Rnw:206-209
###################################################
tmp <- msset[2500 < mz(msset) & mz(msset) < 4500,]
range(mz(msset))
range(mz(tmp))


###################################################
### code chunk number 12: Cardinal-walkthrough.Rnw:214-217
###################################################
tmp <- msset[,coord(msset)$x > 5]
range(coord(msset)$x)
range(coord(tmp)$x)


###################################################
### code chunk number 13: Cardinal-walkthrough.Rnw:222-225
###################################################
tmp <- msset[2500 < mz(msset) & mz(msset) < 4500, coord(msset)$x > 5]
range(mz(tmp))
range(coord(tmp)$x)


###################################################
### code chunk number 14: plot1
###################################################
plot(msset, pixel=1)


###################################################
### code chunk number 15: plot2
###################################################
plot(msset, coord=list(x=5, y=5), plusminus=2)


###################################################
### code chunk number 16: plot3
###################################################
mycol <- c("blue", "black", "red")
plot(msset, pixel=1:ncol(msset), pixel.groups=pattern, superpose=TRUE, key=TRUE, col=mycol)


###################################################
### code chunk number 17: Cardinal-walkthrough.Rnw:260-261
###################################################
plot(msset, pixel=1)


###################################################
### code chunk number 18: Cardinal-walkthrough.Rnw:268-269
###################################################
plot(msset, coord=list(x=5, y=5), plusminus=2)


###################################################
### code chunk number 19: Cardinal-walkthrough.Rnw:276-277
###################################################
mycol <- c("blue", "black", "red")
plot(msset, pixel=1:ncol(msset), pixel.groups=pattern, superpose=TRUE, key=TRUE, col=mycol)


###################################################
### code chunk number 20: image1
###################################################
image(msset, feature=1)


###################################################
### code chunk number 21: image2
###################################################
image(msset, mz=4000, plusminus=10)


###################################################
### code chunk number 22: image3
###################################################
mycol <- c("blue", "black", "red")
image(msset, mz=c(2000, 3000, 4000), col=mycol, superpose=TRUE)


###################################################
### code chunk number 23: image4
###################################################
mycol <- gradient.colors(100, start="white", end="blue")
image(msset, mz=2000, col.regions=mycol, contrast.enhance="suppress")


###################################################
### code chunk number 24: image5
###################################################
mycol <- gradient.colors(100, start="white", end="black")
image(msset, mz=3000, col.regions=mycol, smooth.image="gaussian")


###################################################
### code chunk number 25: image6
###################################################
msset2 <- msset[,pattern == "black" | pattern == "red"]
mycol <- gradient.colors(100, start="black", end="red")
image(msset2, mz=4000, col.regions=mycol)


###################################################
### code chunk number 26: Cardinal-walkthrough.Rnw:333-334
###################################################
image(msset, feature=1)


###################################################
### code chunk number 27: Cardinal-walkthrough.Rnw:341-342
###################################################
image(msset, mz=4000, plusminus=10)


###################################################
### code chunk number 28: Cardinal-walkthrough.Rnw:349-350
###################################################
mycol <- c("blue", "black", "red")
image(msset, mz=c(2000, 3000, 4000), col=mycol, superpose=TRUE)


###################################################
### code chunk number 29: Cardinal-walkthrough.Rnw:357-358
###################################################
mycol <- gradient.colors(100, start="white", end="blue")
image(msset, mz=2000, col.regions=mycol, contrast.enhance="suppress")


###################################################
### code chunk number 30: Cardinal-walkthrough.Rnw:365-366
###################################################
mycol <- gradient.colors(100, start="white", end="black")
image(msset, mz=3000, col.regions=mycol, smooth.image="gaussian")


###################################################
### code chunk number 31: Cardinal-walkthrough.Rnw:373-374
###################################################
msset2 <- msset[,pattern == "black" | pattern == "red"]
mycol <- gradient.colors(100, start="black", end="red")
image(msset2, mz=4000, col.regions=mycol)


###################################################
### code chunk number 32: normalizetic
###################################################
normalize(msset, pixel=1, method="tic", plot=TRUE)


###################################################
### code chunk number 33: normalize
###################################################
msset2 <- normalize(msset, method="tic")


###################################################
### code chunk number 34: Cardinal-walkthrough.Rnw:404-405
###################################################
normalize(msset, pixel=1, method="tic", plot=TRUE)


###################################################
### code chunk number 35: smoothgaus
###################################################
smoothSignal(msset2, pixel=1, method="gaussian", window=9, plot=TRUE)


###################################################
### code chunk number 36: smoothsgolay
###################################################
smoothSignal(msset2, pixel=1, method="sgolay", window=15, plot=TRUE)


###################################################
### code chunk number 37: smooth
###################################################
msset3 <- smoothSignal(msset2, method="gaussian", window=9)


###################################################
### code chunk number 38: Cardinal-walkthrough.Rnw:431-432
###################################################
smoothSignal(msset2, pixel=1, method="gaussian", window=9, plot=TRUE)


###################################################
### code chunk number 39: Cardinal-walkthrough.Rnw:439-440
###################################################
smoothSignal(msset2, pixel=1, method="sgolay", window=15, plot=TRUE)


###################################################
### code chunk number 40: baselinemedian
###################################################
reduceBaseline(msset3, pixel=1, method="median", blocks=50, plot=TRUE)


###################################################
### code chunk number 41: baseline
###################################################
msset4 <- reduceBaseline(msset3, method="median", blocks=50)


###################################################
### code chunk number 42: Cardinal-walkthrough.Rnw:464-465
###################################################
reduceBaseline(msset3, pixel=1, method="median", blocks=50, plot=TRUE)


###################################################
### code chunk number 43: peakpickadaptive
###################################################
peakPick(msset4, pixel=1, method="adaptive", SNR=3, plot=TRUE)


###################################################
### code chunk number 44: peakpicklimpic
###################################################
peakPick(msset4, pixel=1, method="limpic", SNR=3, plot=TRUE)


###################################################
### code chunk number 45: peakpick
###################################################
msset5 <- peakPick(msset4, method="simple", SNR=3)


###################################################
### code chunk number 46: Cardinal-walkthrough.Rnw:491-492
###################################################
peakPick(msset4, pixel=1, method="adaptive", SNR=3, plot=TRUE)


###################################################
### code chunk number 47: Cardinal-walkthrough.Rnw:499-500
###################################################
peakPick(msset4, pixel=1, method="limpic", SNR=3, plot=TRUE)


###################################################
### code chunk number 48: peakaligndiff
###################################################
peakAlign(msset5, pixel=1, method="diff", plot=TRUE)


###################################################
### code chunk number 49: peakalign
###################################################
msset6 <- peakAlign(msset5, method="diff")


###################################################
### code chunk number 50: Cardinal-walkthrough.Rnw:521-522
###################################################
peakAlign(msset5, pixel=1, method="diff", plot=TRUE)


###################################################
### code chunk number 51: peakfilter
###################################################
msset7 <- peakFilter(msset6, method="freq")

dim(msset6) # 89 peaks retained

dim(msset7) # 10 peaks retained


###################################################
### code chunk number 52: reducedimbin
###################################################
reduceDimension(msset4, pixel=1, method="bin", width=25, units="mz", fun=mean, plot=TRUE)


###################################################
### code chunk number 53: reducedimresample
###################################################
reduceDimension(msset4, pixel=1, method="resample", step=25, plot=TRUE)


###################################################
### code chunk number 54: reducedim
###################################################
msset8 <- reduceDimension(msset4, method="resample", step=25)


###################################################
### code chunk number 55: Cardinal-walkthrough.Rnw:568-569
###################################################
reduceDimension(msset4, pixel=1, method="bin", width=25, units="mz", fun=mean, plot=TRUE)


###################################################
### code chunk number 56: Cardinal-walkthrough.Rnw:576-577
###################################################
reduceDimension(msset4, pixel=1, method="resample", step=25, plot=TRUE)


###################################################
### code chunk number 57: batch1
###################################################
msset9 <- batchProcess(msset, normalize=TRUE, smoothSignal=TRUE, reduceBaseline=TRUE)
summary(msset9)
processingData(msset9)


###################################################
### code chunk number 58: batch2
###################################################
msset10 <- batchProcess(msset, normalize=TRUE, smoothSignal=TRUE, reduceBaseline=list(blocks=200),
  peakPick=list(SNR=12), peakAlign=TRUE)
summary(msset10)
processingData(msset10)


###################################################
### code chunk number 59: pca
###################################################
pca <- PCA(msset4, ncomp=2)


###################################################
### code chunk number 60: pcaplot
###################################################
plot(pca)


###################################################
### code chunk number 61: pcaimage
###################################################
image(pca)


###################################################
### code chunk number 62: Cardinal-walkthrough.Rnw:647-648
###################################################
plot(pca)


###################################################
### code chunk number 63: Cardinal-walkthrough.Rnw:655-656
###################################################
image(pca)


###################################################
### code chunk number 64: pls
###################################################
pls <- PLS(msset4, y=pattern, ncomp=2)


###################################################
### code chunk number 65: plsplot
###################################################
plot(pls, col=c("blue", "black", "red"))


###################################################
### code chunk number 66: plsimage
###################################################
image(pls, col=c("blue", "black", "red"))


###################################################
### code chunk number 67: Cardinal-walkthrough.Rnw:693-694
###################################################
plot(pls, col=c("blue", "black", "red"))


###################################################
### code chunk number 68: Cardinal-walkthrough.Rnw:701-702
###################################################
image(pls, col=c("blue", "black", "red"))


###################################################
### code chunk number 69: opls
###################################################
opls <- OPLS(msset4, y=pattern, ncomp=2)


###################################################
### code chunk number 70: oplsplot
###################################################
plot(opls, col=c("blue", "black", "red"))


###################################################
### code chunk number 71: oplsimage
###################################################
image(opls, col=c("blue", "black", "red"))


###################################################
### code chunk number 72: Cardinal-walkthrough.Rnw:735-736
###################################################
plot(opls, col=c("blue", "black", "red"))


###################################################
### code chunk number 73: Cardinal-walkthrough.Rnw:743-744
###################################################
image(opls, col=c("blue", "black", "red"))


###################################################
### code chunk number 74: skm
###################################################
set.seed(1)
skm <- spatialKMeans(msset7, r=2, k=3, method="adaptive")


###################################################
### code chunk number 75: skmplot
###################################################
plot(skm, col=c("black", "blue", "red"), type=c('p','h'), key=FALSE)


###################################################
### code chunk number 76: skmimage
###################################################
image(skm, col=c("black", "blue", "red"), key=FALSE)


###################################################
### code chunk number 77: Cardinal-walkthrough.Rnw:782-783
###################################################
plot(skm, col=c("black", "blue", "red"), type=c('p','h'), key=FALSE)


###################################################
### code chunk number 78: Cardinal-walkthrough.Rnw:790-791
###################################################
image(skm, col=c("black", "blue", "red"), key=FALSE)


###################################################
### code chunk number 79: ssc
###################################################
set.seed(1)
ssc <- spatialShrunkenCentroids(msset7, r=1, k=5, s=3, method="adaptive")


###################################################
### code chunk number 80: sscplot
###################################################
plot(ssc, col=c("blue", "red", "black"), type=c('p','h'), key=FALSE)


###################################################
### code chunk number 81: sscimage
###################################################
image(ssc, col=c("blue", "red", "black"), key=FALSE)


###################################################
### code chunk number 82: Cardinal-walkthrough.Rnw:830-831
###################################################
plot(ssc, col=c("blue", "red", "black"), type=c('p','h'), key=FALSE)


###################################################
### code chunk number 83: Cardinal-walkthrough.Rnw:838-839
###################################################
image(ssc, col=c("blue", "red", "black"), key=FALSE)


###################################################
### code chunk number 84: Cardinal-walkthrough.Rnw:864-865 (eval = FALSE)
###################################################
## BiocManager::install("CardinalWorkflows")


###################################################
### code chunk number 85: Cardinal-walkthrough.Rnw:897-898 (eval = FALSE)
###################################################
## vignette("Workflows-clustering")


###################################################
### code chunk number 86: Cardinal-walkthrough.Rnw:903-904 (eval = FALSE)
###################################################
## data(pig206, pig206_analyses)


###################################################
### code chunk number 87: Cardinal-walkthrough.Rnw:934-935 (eval = FALSE)
###################################################
## vignette("Workflows-classification")


###################################################
### code chunk number 88: Cardinal-walkthrough.Rnw:940-941 (eval = FALSE)
###################################################
## data(rcc, rcc_analyses)


###################################################
### code chunk number 89: pData
###################################################
pData(msset)$pg <- pattern


###################################################
### code chunk number 90: fData
###################################################
fData(msset)$fg <- factor(rep("bg", nrow(fData(msset))), levels=c("bg","blue", "black", "red"))
fData(msset)$fg[1950 < fData(msset)$mz & fData(msset)$mz < 2050] <- "blue"
fData(msset)$fg[2950 < fData(msset)$mz & fData(msset)$mz < 3050] <- "black"
fData(msset)$fg[3950 < fData(msset)$mz & fData(msset)$mz < 4050] <- "red"


###################################################
### code chunk number 91: pixelApply1
###################################################
p1 <- pixelApply(msset, mean, .feature.groups=fg)
p1[,1:30]


###################################################
### code chunk number 92: pixelApply2
###################################################
cbind(pData(msset), t(p1))[1:30,c("pg","blue", "black", "red")]


###################################################
### code chunk number 93: pixelApply3
###################################################
tmp1 <- MSImageSet(spectra=t(as.vector(p1["blue",])), coord=coord(msset), mz=2000)
image(tmp1, feature=1, col.regions=alpha.colors("blue", 100), sub="m/z = 2000")


###################################################
### code chunk number 94: pixelApply4
###################################################
tmp1 <- MSImageSet(spectra=t(as.vector(p1["black",])), coord=coord(msset), mz=3000)
image(tmp1, feature=1, col.regions=alpha.colors("black", 100), sub="m/z = 3000")


###################################################
### code chunk number 95: pixelApply5
###################################################
tmp2 <- MSImageSet(spectra=t(as.vector(p1["red",])), coord=coord(msset), mz=4000)
image(tmp2, feature=1, col.regions=alpha.colors("red", 100),  sub="m/z = 4000")


###################################################
### code chunk number 96: Cardinal-walkthrough.Rnw:1041-1042
###################################################
tmp1 <- MSImageSet(spectra=t(as.vector(p1["blue",])), coord=coord(msset), mz=2000)
image(tmp1, feature=1, col.regions=alpha.colors("blue", 100), sub="m/z = 2000")


###################################################
### code chunk number 97: Cardinal-walkthrough.Rnw:1049-1050
###################################################
tmp1 <- MSImageSet(spectra=t(as.vector(p1["black",])), coord=coord(msset), mz=3000)
image(tmp1, feature=1, col.regions=alpha.colors("black", 100), sub="m/z = 3000")


###################################################
### code chunk number 98: Cardinal-walkthrough.Rnw:1057-1058
###################################################
tmp2 <- MSImageSet(spectra=t(as.vector(p1["red",])), coord=coord(msset), mz=4000)
image(tmp2, feature=1, col.regions=alpha.colors("red", 100),  sub="m/z = 4000")


###################################################
### code chunk number 99: featureApply1
###################################################
f1 <- featureApply(msset, mean, .pixel.groups=pg)
f1[,1:30]


###################################################
### code chunk number 100: featureApply2
###################################################
plot(mz(msset), f1["blue",], type="l", xlab="m/z", ylab="Intensity", col="blue")


###################################################
### code chunk number 101: featureApply3
###################################################
plot(mz(msset), f1["black",], type="l", xlab="m/z", ylab="Intensity", col="black")


###################################################
### code chunk number 102: featureApply4
###################################################
plot(mz(msset), f1["red",], type="l", xlab="m/z", ylab="Intensity", col="red")


###################################################
### code chunk number 103: Cardinal-walkthrough.Rnw:1097-1098
###################################################
plot(mz(msset), f1["blue",], type="l", xlab="m/z", ylab="Intensity", col="blue")


###################################################
### code chunk number 104: Cardinal-walkthrough.Rnw:1105-1106
###################################################
plot(mz(msset), f1["black",], type="l", xlab="m/z", ylab="Intensity", col="black")


###################################################
### code chunk number 105: Cardinal-walkthrough.Rnw:1113-1114
###################################################
plot(mz(msset), f1["red",], type="l", xlab="m/z", ylab="Intensity", col="red")


###################################################
### code chunk number 106: Cardinal
###################################################
options(width=69)
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)


###################################################
### code chunk number 107: gs1
###################################################
set.seed(1)
s1 <- generateSpectrum(1, range=c(1001, 20000), centers=runif(50, 1001, 20000), baseline=2000, resolution=100, step=3.3)
plot(x ~ t, data=s1, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 108: gs2
###################################################
set.seed(2)
s2 <- generateSpectrum(1, range=c(1001, 20000), centers=runif(20, 1001, 20000), baseline=3000, resolution=50, step=3.3)
plot(x ~ t, data=s2, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 109: Cardinal-walkthrough.Rnw:1170-1171
###################################################
set.seed(1)
s1 <- generateSpectrum(1, range=c(1001, 20000), centers=runif(50, 1001, 20000), baseline=2000, resolution=100, step=3.3)
plot(x ~ t, data=s1, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 110: Cardinal-walkthrough.Rnw:1178-1179
###################################################
set.seed(2)
s2 <- generateSpectrum(1, range=c(1001, 20000), centers=runif(20, 1001, 20000), baseline=3000, resolution=50, step=3.3)
plot(x ~ t, data=s2, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 111: gs3
###################################################
set.seed(3)
s3 <- generateSpectrum(1, range=c(101, 1000), centers=runif(25, 101, 1000), baseline=0, resolution=250, noise=0.1, step=1.2)
plot(x ~ t, data=s3, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 112: gs4
###################################################
set.seed(4)
s4 <- generateSpectrum(1, range=c(101, 1000), centers=runif(100, 101, 1000), baseline=0, resolution=500, noise=0.2, step=1.2)
plot(x ~ t, data=s4, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 113: Cardinal-walkthrough.Rnw:1207-1208
###################################################
set.seed(3)
s3 <- generateSpectrum(1, range=c(101, 1000), centers=runif(25, 101, 1000), baseline=0, resolution=250, noise=0.1, step=1.2)
plot(x ~ t, data=s3, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 114: Cardinal-walkthrough.Rnw:1215-1216
###################################################
set.seed(4)
s4 <- generateSpectrum(1, range=c(101, 1000), centers=runif(100, 101, 1000), baseline=0, resolution=500, noise=0.2, step=1.2)
plot(x ~ t, data=s4, type="l", xlab="m/z", ylab="Intensity")


###################################################
### code chunk number 115: data
###################################################
data <- matrix(c(NA, NA, 1, 1, NA, NA, NA, NA, NA, NA, 1, 1, NA, NA, 
 NA, NA, NA, NA, NA, 0, 1, 1, NA, NA, NA, NA, NA, 1, 0, 0, 1, 
 1, NA, NA, NA, NA, NA, 0, 1, 1, 1, 1, NA, NA, NA, NA, 0, 1, 1, 
 1, 1, 1, NA, NA, NA, NA, 1, 1, 1, 1, 1, 1, 1, NA, NA, NA, 1, 
 1, NA, NA, NA, NA, NA, NA, 1, 1, NA, NA, NA, NA, NA), nrow=9, ncol=9)


###################################################
### code chunk number 116: truth
###################################################
image(data[,ncol(data):1], col=c("black", "red"))


###################################################
### code chunk number 117: Cardinal-walkthrough.Rnw:1247-1248
###################################################
image(data[,ncol(data):1], col=c("black", "red"))


###################################################
### code chunk number 118: img1
###################################################
set.seed(1)
img1 <- generateImage(data, range=c(1,1000), centers=c(100,200), step=1, as="MSImageSet")


###################################################
### code chunk number 119: gi1
###################################################
image(img1, mz=100, col.regions=alpha.colors("black", 100))


###################################################
### code chunk number 120: gi2
###################################################
image(img1, mz=200, col.regions=alpha.colors("red", 100))


###################################################
### code chunk number 121: Cardinal-walkthrough.Rnw:1274-1275
###################################################
image(img1, mz=100, col.regions=alpha.colors("black", 100))


###################################################
### code chunk number 122: Cardinal-walkthrough.Rnw:1282-1283
###################################################
image(img1, mz=200, col.regions=alpha.colors("red", 100))


###################################################
### code chunk number 123: img2
###################################################
pattern <- factor(c(0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0,
  0, 0, 0, 0, 0, 0, 1, 2, 2, 0, 0, 0, 0, 0, 2, 1, 1, 2,
  2, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 0, 0, 0, 0, 1, 2, 2,
	2, 2, 2, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0),
	levels=c(0,1,2), labels=c("blue", "black", "red"))
coord <- expand.grid(x=1:9, y=1:9)
set.seed(2)
msset <- generateImage(pattern, coord=coord, range=c(1000, 5000), centers=c(2000, 3000, 4000), resolution=100, step=3.3, as="MSImageSet")


###################################################
### code chunk number 124: gi3
###################################################
image(msset, mz=2000, col.regions=alpha.colors("blue", 100))


###################################################
### code chunk number 125: gi4
###################################################
image(msset, mz=3000, col.regions=alpha.colors("black", 100))


###################################################
### code chunk number 126: gi5
###################################################
image(msset, mz=4000, col.regions=alpha.colors("red", 100))


###################################################
### code chunk number 127: Cardinal-walkthrough.Rnw:1326-1327
###################################################
image(msset, mz=2000, col.regions=alpha.colors("blue", 100))


###################################################
### code chunk number 128: Cardinal-walkthrough.Rnw:1334-1335
###################################################
image(msset, mz=3000, col.regions=alpha.colors("black", 100))


###################################################
### code chunk number 129: Cardinal-walkthrough.Rnw:1342-1343
###################################################
image(msset, mz=4000, col.regions=alpha.colors("red", 100))


###################################################
### code chunk number 130: adv1
###################################################
x1 <- apply(expand.grid(x=1:10, y=1:10), 1, 
            function(z) 1/(1 + ((4-z[[1]])/2)^2 + ((4-z[[2]])/2)^2))
dim(x1) <- c(10,10)
image(x1[,ncol(x1):1])


###################################################
### code chunk number 131: adv2
###################################################
x2 <- apply(expand.grid(x=1:10, y=1:10), 1, 
            function(z) 1/(1 + ((6-z[[1]])/2)^2 + ((6-z[[2]])/2)^2))
dim(x2) <- c(10,10)
image(x2[,ncol(x2):1])


###################################################
### code chunk number 132: Cardinal-walkthrough.Rnw:1375-1376
###################################################
x1 <- apply(expand.grid(x=1:10, y=1:10), 1, 
            function(z) 1/(1 + ((4-z[[1]])/2)^2 + ((4-z[[2]])/2)^2))
dim(x1) <- c(10,10)
image(x1[,ncol(x1):1])


###################################################
### code chunk number 133: Cardinal-walkthrough.Rnw:1383-1384
###################################################
x2 <- apply(expand.grid(x=1:10, y=1:10), 1, 
            function(z) 1/(1 + ((6-z[[1]])/2)^2 + ((6-z[[2]])/2)^2))
dim(x2) <- c(10,10)
image(x2[,ncol(x2):1])


###################################################
### code chunk number 134: advsim
###################################################
set.seed(1)
x3 <- mapply(function(z1, z2) generateSpectrum(1, centers=c(500,510), intensities=c(z1, z2), range=c(1,1000), resolution=100, baseline=0, step=1)$x, as.vector(x1), as.vector(x2))
img3 <- MSImageSet(x3, coord=expand.grid(x=1:10, y=1:10), mz=1:1000)


###################################################
### code chunk number 135: advimg1
###################################################
image(img3, mz=500, col=intensity.colors(100))


###################################################
### code chunk number 136: advimg2
###################################################
image(img3, mz=510, col=intensity.colors(100))


###################################################
### code chunk number 137: Cardinal-walkthrough.Rnw:1420-1421
###################################################
image(img3, mz=500, col=intensity.colors(100))


###################################################
### code chunk number 138: Cardinal-walkthrough.Rnw:1428-1429
###################################################
image(img3, mz=510, col=intensity.colors(100))


###################################################
### code chunk number 139: advplot1
###################################################
plot(img3, coord=list(x=4, y=4), type="l", xlim=c(200, 800))


###################################################
### code chunk number 140: advplot2
###################################################
plot(img3, coord=list(x=6, y=6), type="l", xlim=c(200, 800))


###################################################
### code chunk number 141: Cardinal-walkthrough.Rnw:1454-1455
###################################################
plot(img3, coord=list(x=4, y=4), type="l", xlim=c(200, 800))


###################################################
### code chunk number 142: Cardinal-walkthrough.Rnw:1462-1463
###################################################
plot(img3, coord=list(x=6, y=6), type="l", xlim=c(200, 800))


###################################################
### code chunk number 143: Cardinal-walkthrough.Rnw:1478-1479
###################################################
toLatex(sessionInfo())


