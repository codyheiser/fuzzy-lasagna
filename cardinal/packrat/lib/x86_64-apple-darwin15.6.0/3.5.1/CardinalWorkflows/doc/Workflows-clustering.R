### R code from vignette source 'Workflows-clustering.Rnw'

###################################################
### code chunk number 1: style
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: Workflows-clustering.Rnw:35-42
###################################################
## To save time in rebuilding the vignette,
## most of the processing and analysis is run
## beforehand and saved to be loaded later.
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)
options(width=100)


###################################################
### code chunk number 3: Workflows-clustering.Rnw:57-59
###################################################
library(CardinalWorkflows)
data(pig206, pig206_analyses)


###################################################
### code chunk number 4: ionimage256 (eval = FALSE)
###################################################
## image(pig206, mz=256)


###################################################
### code chunk number 5: Workflows-clustering.Rnw:79-80
###################################################
image(pig206, mz=256)


###################################################
### code chunk number 6: Workflows-clustering.Rnw:88-89
###################################################
summary(pig206)


###################################################
### code chunk number 7: Workflows-clustering.Rnw:111-112 (eval = FALSE)
###################################################
## pig206.norm <- normalize(pig206, method="tic")


###################################################
### code chunk number 8: Workflows-clustering.Rnw:124-125 (eval = FALSE)
###################################################
## pig206.peaklist <- peakPick(pig206.norm, pixel=seq(1, ncol(pig206), by=10), method="simple", SNR=6)


###################################################
### code chunk number 9: Workflows-clustering.Rnw:130-131 (eval = FALSE)
###################################################
## pig206.peaklist <- peakAlign(pig206.peaklist, ref=pig206.norm, method="diff", units="ppm", diff.max=200)


###################################################
### code chunk number 10: Workflows-clustering.Rnw:136-137 (eval = FALSE)
###################################################
## pig206.peaklist <- peakFilter(pig206.peaklist, method="freq", freq.min=ncol(pig206.peaklist) / 100)


###################################################
### code chunk number 11: Workflows-clustering.Rnw:142-143 (eval = FALSE)
###################################################
## pig206.peaks <- reduceDimension(pig206.norm, ref=pig206.peaklist, type="height")


###################################################
### code chunk number 12: Workflows-clustering.Rnw:146-147
###################################################
summary(pig206.peaks)


###################################################
### code chunk number 13: ionimage187 (eval = FALSE)
###################################################
## image(pig206, mz=187, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 14: ionimage284 (eval = FALSE)
###################################################
## image(pig206, mz=284, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 15: ionimage537 (eval = FALSE)
###################################################
## image(pig206, mz=537, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 16: Workflows-clustering.Rnw:185-186
###################################################
image(pig206, mz=187, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 17: Workflows-clustering.Rnw:193-194
###################################################
image(pig206, mz=284, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 18: Workflows-clustering.Rnw:201-202
###################################################
image(pig206, mz=537, contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 19: Workflows-clustering.Rnw:220-221 (eval = FALSE)
###################################################
## pig206.pca <- PCA(pig206.peaks, ncomp=5)


###################################################
### code chunk number 20: Workflows-clustering.Rnw:224-225
###################################################
summary(pig206.pca)


###################################################
### code chunk number 21: pcaimage (eval = FALSE)
###################################################
## image(pig206.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, col.regions=risk.colors(100), layout=c(3,1))


###################################################
### code chunk number 22: pcaplot (eval = FALSE)
###################################################
## plot(pig206.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, layout=c(3,1))


###################################################
### code chunk number 23: Workflows-clustering.Rnw:246-247
###################################################
image(pig206.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, col.regions=risk.colors(100), layout=c(3,1))


###################################################
### code chunk number 24: Workflows-clustering.Rnw:254-255
###################################################
plot(pig206.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, layout=c(3,1))


###################################################
### code chunk number 25: Workflows-clustering.Rnw:291-293 (eval = FALSE)
###################################################
## set.seed(1)
## pig206.skmg <- spatialKMeans(pig206.peaks, r=c(1,2), k=c(5,10), method="gaussian")


###################################################
### code chunk number 26: Workflows-clustering.Rnw:296-297
###################################################
summary(pig206.skmg)


###################################################
### code chunk number 27: Workflows-clustering.Rnw:302-304 (eval = FALSE)
###################################################
## set.seed(1)
## pig206.skma <- spatialKMeans(pig206.peaks, r=c(1,2), k=c(5,10), method="adaptive")


###################################################
### code chunk number 28: Workflows-clustering.Rnw:307-308
###################################################
summary(pig206.skma)


###################################################
### code chunk number 29: skmgimage (eval = FALSE)
###################################################
## image(pig206.skmg, key=FALSE, layout=c(2,2))


###################################################
### code chunk number 30: skmaimage (eval = FALSE)
###################################################
## image(pig206.skma, key=FALSE, layout=c(2,2))


###################################################
### code chunk number 31: Workflows-clustering.Rnw:333-334
###################################################
image(pig206.skmg, key=FALSE, layout=c(2,2))


###################################################
### code chunk number 32: Workflows-clustering.Rnw:341-342
###################################################
image(pig206.skma, key=FALSE, layout=c(2,2))


###################################################
### code chunk number 33: skmgplot (eval = FALSE)
###################################################
## plot(pig206.skmg, key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 34: skmaplot (eval = FALSE)
###################################################
## plot(pig206.skma, key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 35: Workflows-clustering.Rnw:374-375
###################################################
plot(pig206.skmg, key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 36: Workflows-clustering.Rnw:382-383
###################################################
plot(pig206.skma, key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 37: Workflows-clustering.Rnw:424-427 (eval = FALSE)
###################################################
## set.seed(1)
## pig206.sscg <- spatialShrunkenCentroids(pig206.peaks, r=c(1,2),
## 	k=c(15,20), s=c(0,3,6,9), method="gaussian")


###################################################
### code chunk number 38: Workflows-clustering.Rnw:430-431
###################################################
summary(pig206.sscg)


###################################################
### code chunk number 39: Workflows-clustering.Rnw:436-439 (eval = FALSE)
###################################################
## set.seed(1)
## pig206.ssca <- spatialShrunkenCentroids(pig206.peaks, r=c(1,2),
## 	k=c(15,20), s=c(0,3,6,9), method="adaptive")


###################################################
### code chunk number 40: Workflows-clustering.Rnw:442-443
###################################################
summary(pig206.ssca)


###################################################
### code chunk number 41: sscgimage (eval = FALSE)
###################################################
## image(pig206.sscg, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2))


###################################################
### code chunk number 42: sscaimage (eval = FALSE)
###################################################
## image(pig206.ssca, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2))


###################################################
### code chunk number 43: Workflows-clustering.Rnw:468-469
###################################################
image(pig206.sscg, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2))


###################################################
### code chunk number 44: Workflows-clustering.Rnw:476-477
###################################################
image(pig206.ssca, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2))


###################################################
### code chunk number 45: sscgplot (eval = FALSE)
###################################################
## plot(pig206.sscg, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 46: sscaplot (eval = FALSE)
###################################################
## plot(pig206.ssca, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 47: Workflows-clustering.Rnw:512-513
###################################################
plot(pig206.sscg, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 48: Workflows-clustering.Rnw:520-521
###################################################
plot(pig206.ssca, model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 49: sscgtstat (eval = FALSE)
###################################################
## plot(pig206.sscg, mode="tstatistics", model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 50: sscatstat (eval = FALSE)
###################################################
## plot(pig206.ssca, mode="tstatistics", model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 51: Workflows-clustering.Rnw:559-560
###################################################
plot(pig206.sscg, mode="tstatistics", model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 52: Workflows-clustering.Rnw:567-568
###################################################
plot(pig206.ssca, mode="tstatistics", model=list(r=2, s=c(0,6)), key=FALSE, layout=c(2,2), type=c('p', 'h'), pch=20)


###################################################
### code chunk number 53: Workflows-clustering.Rnw:580-581
###################################################
topLabels(pig206.sscg, n=20)


###################################################
### code chunk number 54: Workflows-clustering.Rnw:586-587
###################################################
topLabels(pig206.sscg, model=list(r=2, s=6, k=20), filter=list(classes=5))


###################################################
### code chunk number 55: sscnumsegments (eval = FALSE)
###################################################
## plot(summary(pig206.sscg), main="Number of segments")


###################################################
### code chunk number 56: sscchosenseg (eval = FALSE)
###################################################
## mycol <- c(internal1="#FD9827", back="#42FD24", internal2="#1995FC", brain="#FC23D9", liver="#3524FB", heart="#FC0D1B", bg="#CDFD34")
## image(pig206.sscg, model=list(r=2, k=20, s=6), key=FALSE, col=mycol, main="Selected segmentation")


###################################################
### code chunk number 57: Workflows-clustering.Rnw:618-619
###################################################
plot(summary(pig206.sscg), main="Number of segments")


###################################################
### code chunk number 58: Workflows-clustering.Rnw:626-627
###################################################
mycol <- c(internal1="#FD9827", back="#42FD24", internal2="#1995FC", brain="#FC23D9", liver="#3524FB", heart="#FC0D1B", bg="#CDFD34")
image(pig206.sscg, model=list(r=2, k=20, s=6), key=FALSE, col=mycol, main="Selected segmentation")


###################################################
### code chunk number 59: Workflows-clustering.Rnw:648-655
###################################################
summaryPlots <- function(dataset, results, model, segment, name, col) {
  image(results, model=model, key=FALSE, column=segment, main=name, layout=c(3,2), col=col)
  plot(results, model=model, key=FALSE, column=segment, mode="centers", main="Shrunken mean spectrum", col=col)
  plot(results, model=model, key=FALSE, column=segment, mode="tstatistics", main="Shrunken t-statistics", col=col)
  top <- topLabels(results, n=3, model=model, filter=list(classes=segment))
  image(dataset, mz=top$mz, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian")
}


###################################################
### code chunk number 60: sscgliver (eval = FALSE)
###################################################
## summaryPlots(pig206, pig206.sscg, model=list(r=2, s=6, k=20), segment=5, name="Liver segment", col=mycol)


###################################################
### code chunk number 61: Workflows-clustering.Rnw:667-668
###################################################
summaryPlots(pig206, pig206.sscg, model=list(r=2, s=6, k=20), segment=5, name="Liver segment", col=mycol)


###################################################
### code chunk number 62: sscgheart (eval = FALSE)
###################################################
## summaryPlots(pig206, pig206.sscg, model=list(r=2, s=6, k=20), segment=6, name="Heart segment", col=mycol)


###################################################
### code chunk number 63: Workflows-clustering.Rnw:686-687
###################################################
summaryPlots(pig206, pig206.sscg, model=list(r=2, s=6, k=20), segment=6, name="Heart segment", col=mycol)


###################################################
### code chunk number 64: Workflows-clustering.Rnw:722-723
###################################################
data(cardinal, cardinal_analyses)


###################################################
### code chunk number 65: Workflows-clustering.Rnw:729-730 (eval = FALSE)
###################################################
## cardinal.norm <- normalize(cardinal, method="tic")


###################################################
### code chunk number 66: Workflows-clustering.Rnw:736-743 (eval = FALSE)
###################################################
## cardinal.peaklist <- peakPick(cardinal.norm, pixel=seq(1, ncol(cardinal), by=10), method="simple", SNR=6)
## 
## cardinal.peaklist <- peakAlign(cardinal.peaklist, ref=cardinal.norm, method="diff", units="ppm", diff.max=200)
## 
## cardinal.peaklist <- peakFilter(cardinal.peaklist, method="freq", freq.min=ncol(cardinal.peaklist) / 100)
## 
## cardinal.peaks <- reduceDimension(cardinal.norm, ref=cardinal.peaklist, type="height")


###################################################
### code chunk number 67: Workflows-clustering.Rnw:749-754 (eval = FALSE)
###################################################
## set.seed(1)
## cardinal.sscg <- spatialShrunkenCentroids(cardinal.peaks, r=c(1,2), k=c(10,15), s=c(0,3,6,9), method="gaussian")
## 
## set.seed(1)
## cardinal.ssca <- spatialShrunkenCentroids(cardinal.peaks, r=c(1,2), k=c(10,15), s=c(0,3,6,9), method="adaptive")


###################################################
### code chunk number 68: cardinalchooseg
###################################################
plot(summary(cardinal.sscg))


###################################################
### code chunk number 69: cardinalchoosea
###################################################
plot(summary(cardinal.ssca))


###################################################
### code chunk number 70: cardinalsscg (eval = FALSE)
###################################################
## mycol <- c("#5C605C", "#4D2C36", "#A1A1A1", "#999999", "#B02020", "#1B1B1B", "#901010", "#906565")
## 
## image(cardinal.sscg, model=list(r=1, k=10, s=3), key=FALSE, col=mycol)


###################################################
### code chunk number 71: cardinalssca (eval = FALSE)
###################################################
## mycol <- c("#1B1B1B", "#A1A1A1", "#906565", "#999999", "#B02020", "#901010", "#5C605C", "#4D2C36")
## 
## image(cardinal.ssca, model=list(r=2, k=10, s=3), key=FALSE, col=mycol)


###################################################
### code chunk number 72: Workflows-clustering.Rnw:800-801
###################################################
mycol <- c("#5C605C", "#4D2C36", "#A1A1A1", "#999999", "#B02020", "#1B1B1B", "#901010", "#906565")

image(cardinal.sscg, model=list(r=1, k=10, s=3), key=FALSE, col=mycol)


###################################################
### code chunk number 73: Workflows-clustering.Rnw:808-809
###################################################
mycol <- c("#1B1B1B", "#A1A1A1", "#906565", "#999999", "#B02020", "#901010", "#5C605C", "#4D2C36")

image(cardinal.ssca, model=list(r=2, k=10, s=3), key=FALSE, col=mycol)


###################################################
### code chunk number 74: Workflows-clustering.Rnw:816-817
###################################################
plot(summary(cardinal.sscg))


###################################################
### code chunk number 75: Workflows-clustering.Rnw:824-825
###################################################
plot(summary(cardinal.ssca))


###################################################
### code chunk number 76: Workflows-clustering.Rnw:975-976
###################################################
toLatex(sessionInfo())


