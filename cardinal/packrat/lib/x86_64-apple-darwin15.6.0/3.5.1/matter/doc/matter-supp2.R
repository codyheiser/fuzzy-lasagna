### R code from vignette source 'matter-supp2.Rnw'

###################################################
### code chunk number 1: matter-supp2.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: matter-supp2.Rnw:38-42 (eval = FALSE)
###################################################
## library(matter)
## library(Cardinal)
## path <- "~/Documents/Datasets/3D-MSI/3D_Timecourse/"
## file <- "Microbe_Interaction_3D_Timecourse_LP.imzML"


###################################################
### code chunk number 3: matter-supp2.Rnw:45-48
###################################################
options(width=72)
require(matter)
data(matter_msi)


###################################################
### code chunk number 4: matter-supp2.Rnw:53-54 (eval = FALSE)
###################################################
## msi <- readMSIData(paste0(path, file), attach.only=TRUE)


###################################################
### code chunk number 5: matter-supp2.Rnw:61-98 (eval = FALSE)
###################################################
## msi <- msi[,!duplicated(coord(msi))]
## 
## msi$sample <- factor(sapply(msi$z, function(z) {
## 	if ( z %in% 1:6 ) {
## 		1
## 	} else if ( z %in% 7:12 ) {
## 		2
## 	} else if ( z %in% 13:18 )  {
## 		3
## 	}
## }), labels=c("t = 4", "t = 8", "t = 11"))
## 
## msi$z <- sapply(msi$z, function(z) {
## 	if ( z %in% 1:6 ) {
## 		z
## 	} else if ( z %in% 7:12 ) {
## 		z-6
## 	} else if ( z %in% 13:18 )  {
## 		z-12
## 	}
## })
## 
## msi$x <- mapply(function(x, t) {
## 	switch(as.integer(t),
## 		x-30,
## 		x-15,
## 		x)
## }, msi$x, msi$sample)
## 
## varMetadata(msi)[c("x","y","z","sample"),"labelType"] <- "dim"
## 
## protocolData(msi) <- AnnotatedDataFrame(
## 	data=data.frame(row.names=sampleNames(msi)))
## 
## msi <- regeneratePositions(msi)
## 
## validObject(msi)


###################################################
### code chunk number 6: matter-supp2.Rnw:103-106 (eval = FALSE)
###################################################
## pdf("~/Documents/Developer/Projects/matter/vignettes/msi-img.pdf", height=4.5, width=6)
## image3D(msi, ~ x * z * y, mz=262, theta=-55, contrast="suppress", layout=c(3,1))
## dev.off()


###################################################
### code chunk number 7: msi-ion (eval = FALSE)
###################################################
## image3D(msi, ~ x * z * y, mz=262, theta=-55, contrast="suppress", layout=c(3,1))


###################################################
### code chunk number 8: msi-pca (eval = FALSE)
###################################################
## pca <- PCA(msi, ncomp=2, method="irlba", center=TRUE)
## pData(msi)[,c("PC1","PC2")] <- pca$scores[["ncomp = 2"]]
## fData(msi)[,c("PC1","PC2")] <- pca$loadings[["ncomp = 2"]]


###################################################
### code chunk number 9: matter-supp2.Rnw:124-131 (eval = FALSE)
###################################################
## pdf("~/Documents/Developer/Projects/matter/vignettes/msi-pc1.pdf", height=4.5, width=6)
## image3D(msi, PC1 ~ x * z * y, theta=-55, col.regions=risk.colors(100), layout=c(3,1))
## dev.off()
## 
## pdf("~/Documents/Developer/Projects/matter/vignettes/msi-pc2.pdf", height=4.5, width=6)
## image3D(msi, PC2 ~ x * z * y, theta=-55, col.regions=risk.colors(100), layout=c(3,1))
## dev.off()


###################################################
### code chunk number 10: msi-pc1-img (eval = FALSE)
###################################################
## image3D(msi, PC1 ~ x * z * y, theta=-55, col.regions=risk.colors(100), layout=c(3,1))


###################################################
### code chunk number 11: msi-pc2-img (eval = FALSE)
###################################################
## image3D(msi, PC2 ~ x * z * y, theta=-55, col.regions=risk.colors(100), layout=c(3,1))


###################################################
### code chunk number 12: matter-supp2.Rnw:180-181 (eval = FALSE)
###################################################
## head(atomdata(iData(msi)))


###################################################
### code chunk number 13: matter-supp2.Rnw:186-198 (eval = FALSE)
###################################################
## library(bigmemory)
## library(bigalgebra)
## 
## backingfile <- paste0(expname, ".bin")
## backingpath <- "~/Documents/Temporary/"
## descriptorfile <- paste0(expname, ".desc")
## 
## msi.bm <- filebacked.big.matrix(nrow=ncol(msi), ncol=nrow(msi),
## 	backingfile=backingfile,
## 	backingpath=backingpath,
## 	descriptorfile=descriptorfile,
## 	type="double")


###################################################
### code chunk number 14: matter-supp2.Rnw:203-205 (eval = FALSE)
###################################################
## for ( i in seq_len(ncol(iData(msi))) )
## 	msi.bm[i,] <- iData(msi)[,i]


###################################################
### code chunk number 15: matter-supp2.Rnw:214-223 (eval = FALSE)
###################################################
## ct.mult.bm <- function(A, B, center = ct) {
## 	if ( is.vector(A) ) {
## 		A <- t(A)
## 		cbind((A %*% B)[]) - (sum(A) * ct)
## 	} else if ( is.vector(B) ) {
## 		B <- as.matrix(B)
## 		cbind((A %*% B)[]) - sum(B * ct)
## 	}
## }


###################################################
### code chunk number 16: matter-supp2.Rnw:228-235 (eval = FALSE)
###################################################
## library(biganalytics)
## library(irlba)
## 
## ct <- apply(msi.bm, 2, mean)
## 
## pca.out <- irlba(msi.bm, nu=0, nv=2, mult=ct.mult.bm)
## fData(msi)[,c("PC1","PC2")] <- pca.out$v


###################################################
### code chunk number 17: matter-supp2.Rnw:247-257 (eval = FALSE)
###################################################
## library(ff)
## 
## msi.ff <- ff(dim=c(nrow(msi), ncol(msi)),
## 	filename=paste0(backingpath, backingfile),
## 	vmode="single")
## 
## for ( i in seq_len(ncol(iData(msi))) )
## 		msi.ff[,i] <- iData(msi)[,i]
## 
## msi.ff <- vt(msi.ff)


###################################################
### code chunk number 18: matter-supp2.Rnw:266-278 (eval = FALSE)
###################################################
## library(ffbase)
## library(bootSVD)
## 
## ct.mult.ff <- function(A, B, center = ct) {
## 	if ( is.vector(A) ) {
## 		A <- t(A)
## 		cbind(ffmatrixmult(A, B)[]) - (sum(A) * ct)
## 	} else if ( is.vector(B) ) {
## 		B <- as.matrix(B)
## 		cbind(ffmatrixmult(A, B)[]) - sum(B * ct)
## 	}
## }


###################################################
### code chunk number 19: matter-supp2.Rnw:283-287 (eval = FALSE)
###################################################
## ct <- as.vector(ffapply(X=msi.ff, MARGIN=2, AFUN=mean, RETURN=TRUE)[])
## 
## pca.out <- irlba(msi.ff, nu=0, nv=2, mult=ct.mult.ff)
## fData(msi)[,c("PC1","PC2")] <- pca.out$v


###################################################
### code chunk number 20: matter-supp2.Rnw:369-371 (eval = FALSE)
###################################################
## library(matter)
## datapath <- "~/Documents/Datasets/3D-MSI/"


###################################################
### code chunk number 21: matter-supp2.Rnw:374-389 (eval = FALSE)
###################################################
## require(Cardinal)
## 
## # file <- "3D_Timecourse/Microbe_Interaction_3D_Timecourse_LP.imzML"
## # expname <- "3D_Timecourse"
## 
## # file <- "3D_OSCC/3D_OSCC.imzML"
## # expname <- "3D_OSCC"
## 
## # file <- "3D_Mouse_Pancreas/3D_Mouse_Pancreas.imzML"
## # expname <- "3D_Mouse_Pancreas"
## 
## file <- "3DMouseKidney/3DMouseKidney.imzML"
## expname <- "3DMouseKidney"
## 
## msi <- readMSIData(paste0(datapath, file), attach.only=TRUE)


###################################################
### code chunk number 22: matter-supp2.Rnw:392-399 (eval = FALSE)
###################################################
## msi.prof[[expname]][["matter"]] <- profmem({
## 
## 	pca.out <- PCA(msi, ncomp=2, method="irlba", center=TRUE)
## 	pData(msi)[,c("PC1","PC2")] <- pca.out$scores[[1]]
## 	fData(msi)[,c("PC1","PC2")] <- pca.out$loadings[[1]]
## 
## })


###################################################
### code chunk number 23: matter-supp2.Rnw:404-423 (eval = FALSE)
###################################################
## require(bigmemory)
## require(bigalgebra)
## 
## backingfile <- paste0(expname, ".bin")
## backingpath <- "~/Documents/Temporary/"
## descriptorfile <- paste0(expname, ".desc")
## 
## msi.bm <- filebacked.big.matrix(nrow=ncol(msi), ncol=nrow(msi),
## 	backingfile=backingfile,
## 	backingpath=backingpath,
## 	descriptorfile=descriptorfile,
## 	type="double")
## 
## msi.prof[[expname]][["convert.bigmemory"]] <- profmem({
## 
## 	for ( i in seq_len(ncol(iData(msi))) )
## 		msi.bm[i,] <- iData(msi)[,i]
## 
## })


###################################################
### code chunk number 24: matter-supp2.Rnw:426-435 (eval = FALSE)
###################################################
## ct.mult.bm <- function(A, B, center = ct) {
## 	if ( is.vector(A) ) {
## 		A <- t(A)
## 		cbind((A %*% B)[]) - (sum(A) * ct)
## 	} else if ( is.vector(B) ) {
## 		B <- as.matrix(B)
## 		cbind((A %*% B)[]) - sum(B * ct)
## 	}
## }


###################################################
### code chunk number 25: matter-supp2.Rnw:439-451 (eval = FALSE)
###################################################
## require(biganalytics)
## require(irlba)
## 
## msi.prof[[expname]][["bigmemory"]] <- profmem({
## 
## 	ct <- apply(msi.bm, 2, mean)
## 
## 	pca.out <- irlba(msi.bm, nu=0, nv=2, mult=ct.mult.bm)
## 
## })
## 
## file.remove(paste0(backingpath, backingfile))


###################################################
### code chunk number 26: matter-supp2.Rnw:455-471 (eval = FALSE)
###################################################
## require(ff)
## library(ffbase)
## require(bootSVD)
## 
## msi.ff <- ff(dim=c(nrow(msi), ncol(msi)),
## 	filename=paste0(backingpath, backingfile),
## 	vmode="single")
## 
## msi.prof[[expname]][["convert.ff"]] <- profmem({
## 
## 	for ( i in seq_len(ncol(iData(msi))) )
## 		msi.ff[,i] <- iData(msi)[,i]
## 
## })
## 
## msi.ff <- vt(msi.ff)


###################################################
### code chunk number 27: matter-supp2.Rnw:474-483 (eval = FALSE)
###################################################
## ct.mult.ff <- function(A, B, center = ct) {
## 	if ( is.vector(A) ) {
## 		A <- t(A)
## 		cbind(ffmatrixmult(A, B)[]) - (sum(A) * ct)
## 	} else if ( is.vector(B) ) {
## 		B <- as.matrix(B)
## 		cbind(ffmatrixmult(A, B)[]) - sum(B * ct)
## 	}
## }


###################################################
### code chunk number 28: matter-supp2.Rnw:486-495 (eval = FALSE)
###################################################
## msi.prof[[expname]][["ff"]] <- profmem({
## 
## 	ct <- as.vector(ffapply(X=msi.ff, MARGIN=2, AFUN=mean, RETURN=TRUE)[])
## 
## 	pca.out <- irlba(msi.ff, nu=0, nv=2, mult=ct.mult.ff)
## 
## })
## 
## file.remove(paste0(backingpath, backingfile))


###################################################
### code chunk number 29: matter-supp2.Rnw:498-499
###################################################
print(msi.prof)


###################################################
### code chunk number 30: matter-supp2.Rnw:502-503 (eval = FALSE)
###################################################
## save(msi.prof, file="~/Documents/Developer/Projects/matter/data/matter_msi.rda")


###################################################
### code chunk number 31: matter-supp2.Rnw:509-510
###################################################
toLatex(sessionInfo())


