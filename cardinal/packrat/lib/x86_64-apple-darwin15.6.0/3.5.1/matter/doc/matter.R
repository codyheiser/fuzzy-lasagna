### R code from vignette source 'matter.Rnw'

###################################################
### code chunk number 1: matter.Rnw:10-11
###################################################
BiocStyle::latex()


###################################################
### code chunk number 2: matter.Rnw:45-47 (eval = FALSE)
###################################################
## install.packages("BiocManager")
## BiocManager::install("matter")


###################################################
### code chunk number 3: matter.Rnw:52-55
###################################################
options(width=72)
library(matter)
data(matter_ex)


###################################################
### code chunk number 4: matter.Rnw:62-65
###################################################
x <- matter_mat(data=1:50, nrow=10, ncol=5, datamode="double")
x
x[]


###################################################
### code chunk number 5: matter.Rnw:72-74
###################################################
x[1:4,]
x[,3:4]


###################################################
### code chunk number 6: matter.Rnw:79-82
###################################################
rownames(x) <- 1:10
colnames(x) <- letters[1:5]
x[]


###################################################
### code chunk number 7: matter.Rnw:87-92
###################################################
colSums(x)
colSums(x[])

colVars(x)
apply(x, 2, var)


###################################################
### code chunk number 8: matter.Rnw:99-107
###################################################
y <- matter_mat(data=51:100, nrow=10, ncol=5, datamode="double")

paths(x)
paths(y)

z <- cbind(x, y)
z
z[]


###################################################
### code chunk number 9: matter.Rnw:114-117
###################################################
t(x)

rbind(t(x), t(y))


###################################################
### code chunk number 10: matter.Rnw:124-125
###################################################
atomdata(x)


###################################################
### code chunk number 11: matter.Rnw:132-136
###################################################
x2 <- matter_vec(offset=80, extent=10, paths=paths(x), datamode="double")
y3 <- matter_vec(offset=160, extent=10, paths=paths(y), datamode="double")
cbind(x2, y3)[]
cbind(x[,2], y[,3])


###################################################
### code chunk number 12: matter.Rnw:141-144
###################################################
z <- cbind(c(x2, y3), c(y3, x2))
atomdata(z)
z[]


###################################################
### code chunk number 13: matter.Rnw:151-170
###################################################
v1 <- 1:10
v2 <- as.matter(v1)
v2
v2[]

m1 <- diag(3)
m2 <- as.matter(m1)
m2
m2[]

s1 <- letters[1:10]
s2 <- as.matter(s1)
s2
s2[]

df1 <- data.frame(a=v1, b=s1, stringsAsFactors=FALSE)
df2 <- as.matter(df1)
df2
df2[]


###################################################
### code chunk number 14: setup-bigglm
###################################################
set.seed(81216)
n <- 1.5e7
p <- 9

b <- runif(p)
names(b) <- paste0("x", 1:p)

data <- matter_mat(nrow=n, ncol=p + 1, datamode="double")

colnames(data) <- c(names(b), "y")

data[,p + 1] <- rnorm(n)
for ( i in 1:p ) {
  xi <- rnorm(n)
  data[,i] <- xi
  data[,p + 1] <- data[,p + 1] + xi * b[i]
}

data

head(data)


###################################################
### code chunk number 15: summary-stats
###################################################
apply(data, 2, mean)

apply(data, 2, var)


###################################################
### code chunk number 16: matter.Rnw:219-223 (eval = FALSE)
###################################################
## profmem({
## 	fm <- as.formula(paste0("y ~ ", paste0(names(b), collapse=" + ")))
## 	bigglm.out <- bigglm(fm, data=data, chunksize=10000)
## })


###################################################
### code chunk number 17: fit-bigglm (eval = FALSE)
###################################################
## fm <- as.formula(paste0("y ~ ", paste0(names(b), collapse=" + ")))
## bigglm.out <- bigglm(fm, data=data, chunksize=10000)


###################################################
### code chunk number 18: coef
###################################################
summary(bigglm.out)

cbind(coef(bigglm.out)[-1], b)


###################################################
### code chunk number 19: setup-prcomp
###################################################
set.seed(81216)
n <- 1.5e6
p <- 100

data <- matter_mat(nrow=n, ncol=p, datamode="double")

for ( i in 1:10 )
  data[,i] <- (1:n)/n + rnorm(n)
for ( i in 11:20 )
  data[,i] <- (n:1)/n + rnorm(n)
for ( i in 21:p )
  data[,i] <- rnorm(n)

data


###################################################
### code chunk number 20: plot-var
###################################################
var.out <- colVars(data)
plot(var.out, type='h', ylab="Variance")


###################################################
### code chunk number 21: matter.Rnw:286-289 (eval = FALSE)
###################################################
## profmem({
## 	prcomp.out <- prcomp(data, n=2, center=FALSE, scale.=FALSE)
## })


###################################################
### code chunk number 22: fit-prcomp (eval = FALSE)
###################################################
## prcomp.out <- prcomp(data, n=2, center=FALSE, scale.=FALSE)


###################################################
### code chunk number 23: plot-pc1
###################################################
plot(prcomp.out$rotation[,1], type='h', ylab="PC 1")


###################################################
### code chunk number 24: plot-pc2
###################################################
plot(prcomp.out$rotation[,2], type='h', ylab="PC 2")


###################################################
### code chunk number 25: matter.Rnw:313-314
###################################################
var.out <- colVars(data)
plot(var.out, type='h', ylab="Variance")


###################################################
### code chunk number 26: matter.Rnw:321-322
###################################################
plot(prcomp.out$rotation[,1], type='h', ylab="PC 1")


###################################################
### code chunk number 27: matter.Rnw:329-330
###################################################
plot(prcomp.out$rotation[,2], type='h', ylab="PC 2")


###################################################
### code chunk number 28: matter.Rnw:341-342 (eval = FALSE)
###################################################
## save(bigglm.out, prcomp.out, file="~/Documents/Developer/Projects/matter/data/matter_ex.rda")


###################################################
### code chunk number 29: fastq-setup
###################################################
seqs <- c("@SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=72",
	"GGGTGATGGCCGCTGCCGATGGCGTCAAATCCCACCAAGTTACCCTTAACAACTTAAGGGTTTTCAAATAGA",
	"+SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=72",
	"IIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IG9ICIIIIIIIIIIIIIIIIIIIIDIIIIIII>IIIIII/",
	"@SRR001666.2 071112_SLXA-EAS1_s_7:5:1:801:338 length=72",
	"GTTCAGGGATACGACGTTTGTATTTTAAGAATCTGAAGCAGAAGTCGATGATAATACGCGTCGTTTTATCAT",
	"+SRR001666.2 071112_SLXA-EAS1_s_7:5:1:801:338 length=72",
	"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII6IBIIIIIIIIIIIIIIIIIIIIIIIGII>IIIII-I)8I")

file <- tempfile()
writeLines(seqs, file)


###################################################
### code chunk number 30: fastq-class
###################################################
setClass("Fastq", slots=c(
	id = "matter_str",
	sread = "matter_str",
	quality = "matter_str"))

setGeneric("id", function(x) standardGeneric("id"))
setGeneric("sread", function(object, ...) standardGeneric("sread"))
setGeneric("quality", function(object, ...) standardGeneric("quality"))

setMethod("id", "Fastq", function(x) x@id)
setMethod("sread", "Fastq", function(object) object@sread)
setMethod("quality", "Fastq", function(object) object@quality)


###################################################
### code chunk number 31: fastq-constructor
###################################################
attachFastq <- function(file) {
	length <- file.info(file)$size
	raw <- matter_vec(paths=file, length=length, datamode="raw")
	newlines <- which(raw == charToRaw('\n')) # parses the file in chunks
	if ( newlines[length(newlines)] == length )
		newlines <- newlines[-length(newlines)]
	byte_start <- c(0L, newlines)
	byte_end <- c(newlines, length) - 1L # don't include the '\n'
	line_offset <- byte_start
	line_extent <- byte_end - byte_start
	id <- matter_str(paths=file,
		offset=1L + line_offset[c(TRUE,FALSE,FALSE,FALSE)], # skip the '@'
		extent=line_extent[c(TRUE,FALSE,FALSE,FALSE)] - 1L) # adjust for '@'
	sread <- matter_str(paths=file,
		offset=line_offset[c(FALSE,TRUE,FALSE,FALSE)],
		extent=line_extent[c(FALSE,TRUE,FALSE,FALSE)])
	quality <- matter_str(paths=file,
		offset=line_offset[c(FALSE,FALSE,FALSE,TRUE)],
		extent=line_extent[c(FALSE,FALSE,FALSE,TRUE)])
	new("Fastq", id=id, sread=sread, quality=quality)
}


###################################################
### code chunk number 32: fastq-demo
###################################################
fq <- attachFastq(file)
fq

id(fq)[1]
id(fq)[2]

sread(fq)[1]
sread(fq)[2]

quality(fq)[1]
quality(fq)[2]


###################################################
### code chunk number 33: matter.Rnw:503-504
###################################################
toLatex(sessionInfo())


