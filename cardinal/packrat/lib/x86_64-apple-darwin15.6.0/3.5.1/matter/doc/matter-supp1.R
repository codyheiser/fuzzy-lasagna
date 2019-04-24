### R code from vignette source 'matter-supp1.Rnw'

###################################################
### code chunk number 1: matter-supp1.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: matter-supp1.Rnw:34-35
###################################################
options(width=72)


###################################################
### code chunk number 3: matter-supp1.Rnw:38-39
###################################################
library(matter)


###################################################
### code chunk number 4: matter-supp1.Rnw:42-43
###################################################
data(matter_sim)


###################################################
### code chunk number 5: setup-lm-base (eval = FALSE)
###################################################
## set.seed(81216)
## 
## chunksize <- 10000
## 
## n <- 1.5e7
## p <- 9
## 
## b <- runif(p)
## names(b) <- paste0("x", 1:p)
## 
## data <- data.frame(y=rnorm(n), check.rows=FALSE)
## 
## for ( nm in names(b) ) {
##   xi <- rnorm(n)
##   data[[nm]] <- xi
##   data[["y"]] <- data[["y"]] + xi * b[nm]
## }
## 
## fm <- as.formula(paste0("y ~ ", paste0(names(b), collapse=" + ")))
## 
## lm.prof <- list()


###################################################
### code chunk number 6: lm-base (eval = FALSE)
###################################################
## lm.prof[["base"]] <- profmem({
## 
## 	base.out <- lm(fm, data=data)
## 
## })
## 
## rm(base.out)
## gc()


###################################################
### code chunk number 7: matter-supp1.Rnw:85-86
###################################################
print(lm.prof[["base"]])


###################################################
### code chunk number 8: setup-lm-bigmemory (eval = FALSE)
###################################################
## library(bigmemory)
## library(biganalytics)
## 
## backingfile <- "lm-ex.bin"
## backingpath <- tempdir()
## descriptorfile <- "lm-ex.desc"
## 
## data.bm <- filebacked.big.matrix(nrow=n, ncol=p + 1,
## 	backingfile=backingfile,
## 	backingpath=backingpath,
## 	descriptorfile=descriptorfile,
## 	dimnames=list(NULL, c("y", names(b))),
## 	type="double")
## 
## for ( nm in names(data) )
## 	data.bm[,nm] <- data[[nm]]
## 
## rm(data)
## gc()


###################################################
### code chunk number 9: lm-bigmemory (eval = FALSE)
###################################################
## lm.prof[["bigmemory"]] <- profmem({
## 
## 	bm.out <- biglm.big.matrix(fm, data=data.bm, chunksize=chunksize)
## 
## })
## 
## rm(bm.out)
## gc()


###################################################
### code chunk number 10: matter-supp1.Rnw:126-127
###################################################
print(lm.prof[["bigmemory"]])


###################################################
### code chunk number 11: setup-lm-ff (eval = FALSE)
###################################################
## library(ff)
## library(ffbase)
## 
## data.ff <- ff(filename=paste0(backingpath, "/", backingfile),
## 	vmode="double", dim=c(n, p + 1),
## 	dimnames=list(NULL, c("y", names(b))))
## 
## data.ff <- as.ffdf(data.ff)


###################################################
### code chunk number 12: lm-ff (eval = FALSE)
###################################################
## lm.prof[["ff"]] <- profmem({
## 
## 	ff.out <- bigglm(fm, data=data.ff, chunksize=chunksize)
## 
## })
## 
## rm(ff.out)
## gc()


###################################################
### code chunk number 13: matter-supp1.Rnw:154-155
###################################################
print(lm.prof[["ff"]])


###################################################
### code chunk number 14: setup-lm-matter (eval = FALSE)
###################################################
## data.m <- matter(paths=paste0(backingpath, "/", backingfile),
## 	datamode="double", nrow=n, ncol=p + 1,
## 	dimnames=list(NULL, c("y", names(b))))


###################################################
### code chunk number 15: lm-matter (eval = FALSE)
###################################################
## lm.prof[["matter"]] <- profmem({
## 
## 	m.out <- bigglm(fm, data=data.m, chunksize=chunksize)
## 
## })
## 
## rm(m.out)
## gc()


###################################################
### code chunk number 16: matter-supp1.Rnw:177-178
###################################################
print(lm.prof[["matter"]])


###################################################
### code chunk number 17: setup-pca-base (eval = FALSE)
###################################################
## library(irlba)
## 
## set.seed(81216)
## n <- 1.5e6
## p <- 100
## 
## data <- matrix(nrow=n, ncol=p)
## 
## for ( i in 1:10 )
##   data[,i] <- (1:n)/n + rnorm(n)
## for ( i in 11:20 )
##   data[,i] <- (n:1)/n + rnorm(n)
## for ( i in 21:p )
##   data[,i] <- rnorm(n)
## 
## pca.prof <- list()


###################################################
### code chunk number 18: pca-base (eval = FALSE)
###################################################
## pca.prof[["base"]] <- profmem({
## 
## 	base.out <- svd(data, nu=0, nv=2)
## 
## })
## 
## rm(base.out)
## gc()


###################################################
### code chunk number 19: matter-supp1.Rnw:219-220
###################################################
print(pca.prof[["base"]])


###################################################
### code chunk number 20: setup-pca-bigmemory (eval = FALSE)
###################################################
## library(bigalgebra)
## 
## backingfile <- "pca-ex.bin"
## backingpath <- tempdir()
## descriptorfile <- "pca-ex.desc"
## 
## data.bm <- filebacked.big.matrix(nrow=n, ncol=p,
## 	backingfile=backingfile,
## 	backingpath=backingpath,
## 	descriptorfile=descriptorfile,
## 	type="double")
## 
## for ( i in seq_len(ncol(data)) )
## 	data.bm[,i] <- data[,i]
## 
## rm(data)
## gc()
## 
## mult.bm <- function(A, B) {
## 	if ( is.vector(A) )
## 		A <- t(A)
## 	if ( is.vector(B) )
## 		B <- as.matrix(B)
## 	cbind((A %*% B)[])
## }


###################################################
### code chunk number 21: pca-bigmemory (eval = FALSE)
###################################################
## pca.prof[["bigmemory"]] <- profmem({
## 
## 	bm.out <- irlba(data.bm, nu=0, nv=2, mult=mult.bm)
## 
## })
## 
## rm(bm.out)
## gc()


###################################################
### code chunk number 22: matter-supp1.Rnw:264-265
###################################################
print(pca.prof[["bigmemory"]])


###################################################
### code chunk number 23: setup-pca-ff (eval = FALSE)
###################################################
## library(bootSVD)
## 
## data.ff <- ff(filename=paste0(backingpath, "/", backingfile),
## 	vmode="double", dim=c(n, p))
## 
## mult.ff <- function(A, B) {
## 	if ( is.vector(A) )
## 		A <- t(A)
## 	if ( is.vector(B) )
## 		B <- as.matrix(B)
## 	cbind(ffmatrixmult(A, B)[])
## }


###################################################
### code chunk number 24: pca-ff (eval = FALSE)
###################################################
## pca.prof[["ff"]] <- profmem({
## 
## 	ff.out <- irlba(data.ff, nu=0, nv=2, mult=mult.ff)
## 
## })
## 
## rm(ff.out)
## gc()


###################################################
### code chunk number 25: matter-supp1.Rnw:297-298
###################################################
print(pca.prof[["ff"]])


###################################################
### code chunk number 26: setup-pca-matter (eval = FALSE)
###################################################
## library(matter)
## 
## data.m <- matter(paths=paste0(backingpath, "/", backingfile),
## 	datamode="double", nrow=n, ncol=p)


###################################################
### code chunk number 27: pca-matter (eval = FALSE)
###################################################
## pca.prof[["matter"]] <- profmem({
## 
## 	m.out <- irlba(data.m, nu=0, nv=2, fastpath=FALSE)
## 
## })
## 
## rm(m.out)
## gc()


###################################################
### code chunk number 28: matter-supp1.Rnw:321-322
###################################################
print(pca.prof[["matter"]])


###################################################
### code chunk number 29: matter-supp1.Rnw:326-327 (eval = FALSE)
###################################################
## save(lm.prof, pca.prof, file="~/Documents/Developer/Projects/matter/data/matter_sim.rda")


###################################################
### code chunk number 30: matter-supp1.Rnw:362-363
###################################################
toLatex(sessionInfo())


