### R code from vignette source 'Workflows-classification.Rnw'

###################################################
### code chunk number 1: style
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: Workflows-classification.Rnw:35-39
###################################################
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)
options(width=100)


###################################################
### code chunk number 3: Workflows-classification.Rnw:56-58
###################################################
library(CardinalWorkflows)
data(rcc, rcc_analyses)


###################################################
### code chunk number 4: ionimages810 (eval = FALSE)
###################################################
## image(rcc, mz=810.5, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))


###################################################
### code chunk number 5: Workflows-classification.Rnw:122-123
###################################################
image(rcc, mz=810.5, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))


###################################################
### code chunk number 6: Workflows-classification.Rnw:132-133
###################################################
summary(rcc)


###################################################
### code chunk number 7: Workflows-classification.Rnw:161-162 (eval = FALSE)
###################################################
## rcc.norm <- normalize(rcc, method="tic")


###################################################
### code chunk number 8: Workflows-classification.Rnw:169-170 (eval = FALSE)
###################################################
## rcc.resample <- reduceDimension(rcc.norm, method="resample")


###################################################
### code chunk number 9: Workflows-classification.Rnw:181-182
###################################################
summary(rcc$diagnosis)


###################################################
### code chunk number 10: Workflows-classification.Rnw:187-188 (eval = FALSE)
###################################################
## rcc.small <- rcc.resample[,rcc$diagnosis %in% c("cancer", "normal")]


###################################################
### code chunk number 11: Workflows-classification.Rnw:191-192
###################################################
summary(rcc.small)


###################################################
### code chunk number 12: ionimages215 (eval = FALSE)
###################################################
## image(rcc, mz=215.3, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))


###################################################
### code chunk number 13: ionimages886 (eval = FALSE)
###################################################
## image(rcc, mz=885.7, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))
## 


###################################################
### code chunk number 14: Workflows-classification.Rnw:233-234
###################################################
image(rcc, mz=215.3, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))


###################################################
### code chunk number 15: Workflows-classification.Rnw:241-242
###################################################
image(rcc, mz=885.7, normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian", layout=c(4,2))



###################################################
### code chunk number 16: Workflows-classification.Rnw:260-261 (eval = FALSE)
###################################################
## rcc.pca <- PCA(rcc.small, ncomp=5)


###################################################
### code chunk number 17: Workflows-classification.Rnw:264-265
###################################################
summary(rcc.pca)


###################################################
### code chunk number 18: pcaimages (eval = FALSE)
###################################################
## image(rcc.pca, column="PC1", superpose=FALSE, col.regions=risk.colors(100), layout=c(4,2))


###################################################
### code chunk number 19: Workflows-classification.Rnw:279-280
###################################################
image(rcc.pca, column="PC1", superpose=FALSE, col.regions=risk.colors(100), layout=c(4,2))


###################################################
### code chunk number 20: pcaloadings (eval = FALSE)
###################################################
## plot(rcc.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, layout=c(3,1))


###################################################
### code chunk number 21: Workflows-classification.Rnw:297-298
###################################################
plot(rcc.pca, column=c("PC1", "PC2", "PC3"), superpose=FALSE, layout=c(3,1))


###################################################
### code chunk number 22: Workflows-classification.Rnw:306-308
###################################################
pca.normal <- as.data.frame(rcc.pca[[1]]$scores[rcc.small$diagnosis == "normal",])
pca.cancer <- as.data.frame(rcc.pca[[1]]$scores[rcc.small$diagnosis == "cancer",])


###################################################
### code chunk number 23: pca1versus2 (eval = FALSE)
###################################################
## plot(PC2 ~ PC1, data=pca.normal, col="blue")
## points(PC2 ~ PC1, data=pca.cancer, col="red")
## legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 24: pca1versus3 (eval = FALSE)
###################################################
## plot(PC3 ~ PC1, data=pca.normal, col="blue")
## points(PC3 ~ PC1, data=pca.cancer, col="red")
## legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 25: pca2versus3 (eval = FALSE)
###################################################
## plot(PC3 ~ PC2, data=pca.normal, col="blue")
## points(PC3 ~ PC2, data=pca.cancer, col="red")
## legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 26: Workflows-classification.Rnw:358-359
###################################################
plot(PC2 ~ PC1, data=pca.normal, col="blue")
points(PC2 ~ PC1, data=pca.cancer, col="red")
legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 27: Workflows-classification.Rnw:366-367
###################################################
plot(PC3 ~ PC1, data=pca.normal, col="blue")
points(PC3 ~ PC1, data=pca.cancer, col="red")
legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 28: Workflows-classification.Rnw:374-375
###################################################
plot(PC3 ~ PC2, data=pca.normal, col="blue")
points(PC3 ~ PC2, data=pca.cancer, col="red")
legend("top", legend=c("normal", "cancer"), col=c("blue", "red"), pch=1, bg=rgb(1,1,1,0.75))


###################################################
### code chunk number 29: Workflows-classification.Rnw:408-409
###################################################
summary(rcc.small$sample)


###################################################
### code chunk number 30: Workflows-classification.Rnw:416-417 (eval = FALSE)
###################################################
## rcc.cv.pls <- cvApply(rcc.small, .y=rcc.small$diagnosis, .fun="PLS", ncomp=1:15)


###################################################
### code chunk number 31: plsaccuracy (eval = FALSE)
###################################################
## plot(summary(rcc.cv.pls))


###################################################
### code chunk number 32: Workflows-classification.Rnw:428-429
###################################################
summary(rcc.cv.pls)$accuracy[["ncomp = 10"]]


###################################################
### code chunk number 33: Workflows-classification.Rnw:435-436
###################################################
plot(summary(rcc.cv.pls))


###################################################
### code chunk number 34: plsimages
###################################################
image(rcc.cv.pls, model=list(ncomp=10), layout=c(4,2))


###################################################
### code chunk number 35: Workflows-classification.Rnw:463-464
###################################################
image(rcc.cv.pls, model=list(ncomp=10), layout=c(4,2))


###################################################
### code chunk number 36: Workflows-classification.Rnw:480-481 (eval = FALSE)
###################################################
## rcc.pls <- PLS(rcc.small, y=rcc.small$diagnosis, ncomp=10)


###################################################
### code chunk number 37: plscoef (eval = FALSE)
###################################################
## plot(rcc.pls)


###################################################
### code chunk number 38: Workflows-classification.Rnw:493-494
###################################################
plot(rcc.pls)


###################################################
### code chunk number 39: Workflows-classification.Rnw:503-504
###################################################
topLabels(rcc.pls)


###################################################
### code chunk number 40: ionimages751 (eval = FALSE)
###################################################
## image(rcc.small, mz=751, layout=c(4,2), normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 41: Workflows-classification.Rnw:516-517
###################################################
image(rcc.small, mz=751, layout=c(4,2), normalize.image="linear", contrast.enhance="histogram", smooth.image="gaussian")


###################################################
### code chunk number 42: Workflows-classification.Rnw:539-540 (eval = FALSE)
###################################################
## rcc.cv.opls <- cvApply(rcc.small, .y=rcc.small$diagnosis, .fun="OPLS", ncomp=1:15, keep.Xnew=FALSE)


###################################################
### code chunk number 43: oplsaccuracy (eval = FALSE)
###################################################
## plot(summary(rcc.cv.opls))


###################################################
### code chunk number 44: Workflows-classification.Rnw:549-550
###################################################
summary(rcc.cv.pls)$accuracy[["ncomp = 12"]]


###################################################
### code chunk number 45: Workflows-classification.Rnw:556-557
###################################################
plot(summary(rcc.cv.opls))


###################################################
### code chunk number 46: oplsimages (eval = FALSE)
###################################################
## image(rcc.cv.opls, model=list(ncomp=12), layout=c(4,2))


###################################################
### code chunk number 47: Workflows-classification.Rnw:575-576
###################################################
image(rcc.cv.opls, model=list(ncomp=12), layout=c(4,2))


###################################################
### code chunk number 48: Workflows-classification.Rnw:589-591 (eval = FALSE)
###################################################
## rcc.opls <- OPLS(rcc.small, y=rcc.small$diagnosis, ncomp=12,
## 	keep.Xnew=FALSE)


###################################################
### code chunk number 49: oplscoef (eval = FALSE)
###################################################
## plot(rcc.opls)


###################################################
### code chunk number 50: Workflows-classification.Rnw:603-604
###################################################
plot(rcc.opls)


###################################################
### code chunk number 51: Workflows-classification.Rnw:614-615
###################################################
topLabels(rcc.opls)


###################################################
### code chunk number 52: Workflows-classification.Rnw:651-652 (eval = FALSE)
###################################################
## rcc.cv.sscg <- cvApply(rcc.small, .y=rcc.small$diagnosis, .fun="spatialShrunkenCentroids", method="gaussian", r=c(1,2,3), s=c(0,4,8,12,16,20,24,28))


###################################################
### code chunk number 53: Workflows-classification.Rnw:657-658 (eval = FALSE)
###################################################
## rcc.cv.ssca <- cvApply(rcc.small, .y=rcc.small$diagnosis, .fun="spatialShrunkenCentroids", method="adaptive", r=c(1,2,3), s=c(0,4,8,12,16,20,24,28))


###################################################
### code chunk number 54: sscgaccuracy (eval = FALSE)
###################################################
## plot(summary(rcc.cv.sscg))


###################################################
### code chunk number 55: sscaaccuracy (eval = FALSE)
###################################################
## plot(summary(rcc.cv.ssca))


###################################################
### code chunk number 56: Workflows-classification.Rnw:676-677
###################################################
plot(summary(rcc.cv.sscg))


###################################################
### code chunk number 57: Workflows-classification.Rnw:684-685
###################################################
plot(summary(rcc.cv.ssca))


###################################################
### code chunk number 58: sscgimages
###################################################
image(rcc.cv.sscg, model=list(r=3, s=20), layout=c(4,2))


###################################################
### code chunk number 59: sscaimages
###################################################
image(rcc.cv.ssca, model=list(r=3, s=20), layout=c(4,2))


###################################################
### code chunk number 60: Workflows-classification.Rnw:718-719
###################################################
image(rcc.cv.sscg, model=list(r=3, s=20), layout=c(4,2))


###################################################
### code chunk number 61: Workflows-classification.Rnw:726-727
###################################################
image(rcc.cv.ssca, model=list(r=3, s=20), layout=c(4,2))


###################################################
### code chunk number 62: Workflows-classification.Rnw:744-747 (eval = FALSE)
###################################################
## rcc.sscg <- spatialShrunkenCentroids(rcc.small, y=rcc.small$diagnosis, r=3, s=20, method="gaussian")
## 
## rcc.ssca <- spatialShrunkenCentroids(rcc.small, y=rcc.small$diagnosis, r=3, s=20, method="adaptive")


###################################################
### code chunk number 63: sscgtstat
###################################################
plot(rcc.sscg, mode="tstatistics", model=list(r=3, s=20))


###################################################
### code chunk number 64: sscatstat
###################################################
plot(rcc.ssca, mode="tstatistics", model=list(r=3, s=20))


###################################################
### code chunk number 65: Workflows-classification.Rnw:765-766
###################################################
plot(rcc.sscg, mode="tstatistics", model=list(r=3, s=20))


###################################################
### code chunk number 66: Workflows-classification.Rnw:773-774
###################################################
plot(rcc.ssca, mode="tstatistics", model=list(r=3, s=20))


###################################################
### code chunk number 67: Workflows-classification.Rnw:784-786
###################################################
summary(rcc.sscg)
summary(rcc.ssca)


###################################################
### code chunk number 68: Workflows-classification.Rnw:793-795
###################################################
topLabels(rcc.sscg)
topLabels(rcc.ssca)


###################################################
### code chunk number 69: Workflows-classification.Rnw:812-813
###################################################
toLatex(sessionInfo())


