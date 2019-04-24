### R code from vignette source 'Cardinal-development.Rnw'

###################################################
### code chunk number 1: Cardinal-development.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: Cardinal-development.Rnw:27-31
###################################################
library(Cardinal)
options(Cardinal.verbose=FALSE)
options(Cardinal.progress=FALSE)
options(width=100)


###################################################
### code chunk number 3: Cardinal-development.Rnw:69-70
###################################################
getClass("iSet")


###################################################
### code chunk number 4: Cardinal-development.Rnw:91-92
###################################################
getClass("SImageSet")


###################################################
### code chunk number 5: Cardinal-development.Rnw:99-100
###################################################
getClass("MSImageSet")


###################################################
### code chunk number 6: Cardinal-development.Rnw:116-117
###################################################
getClass("ImageData")


###################################################
### code chunk number 7: Cardinal-development.Rnw:138-139
###################################################
getClass("SImageData")


###################################################
### code chunk number 8: Cardinal-development.Rnw:163-164
###################################################
getClass("MSImageData")


###################################################
### code chunk number 9: Cardinal-development.Rnw:174-175
###################################################
getClass("Hashmat")


###################################################
### code chunk number 10: Cardinal-development.Rnw:204-205
###################################################
getClass("IAnnotatedDataFrame")


###################################################
### code chunk number 11: Cardinal-development.Rnw:218-219
###################################################
getClass("MIAPE-Imaging")


###################################################
### code chunk number 12: Cardinal-development.Rnw:228-229
###################################################
getClass("MSImageProcess")


###################################################
### code chunk number 13: Cardinal-development.Rnw:238-239
###################################################
getClass("ResultSet")


###################################################
### code chunk number 14: Cardinal-development.Rnw:267-269
###################################################
selectMethod("plot", c("PCA", "missing"))
selectMethod("image", "PCA")


###################################################
### code chunk number 15: Cardinal-development.Rnw:294-295
###################################################
options(Cardinal.timing=TRUE)


###################################################
### code chunk number 16: Cardinal-development.Rnw:306-307
###################################################
toLatex(sessionInfo())


