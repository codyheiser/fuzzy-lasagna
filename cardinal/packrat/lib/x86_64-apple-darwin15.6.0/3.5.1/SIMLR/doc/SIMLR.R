## ----style-knitr, eval=TRUE, echo=FALSE, results="asis"-----------------------------
BiocStyle::latex()

## ----include=FALSE------------------------------------------------------------------
library(knitr)
opts_chunk$set(
concordance = TRUE,
background = "#f3f3ff"
)

## ----req----------------------------------------------------------------------------
library(SIMLR)
data(BuettnerFlorian)
data(ZeiselAmit)
data(GliomasReduced)

## ----igraph, results='hide', message=FALSE------------------------------------------
library(igraph)

## ----SIMLR_run, warning=FALSE-------------------------------------------------------
set.seed(11111)
example = SIMLR(X = BuettnerFlorian$in_X, c = BuettnerFlorian$n_clust, cores.ratio = 0)

## ----nmi_performance----------------------------------------------------------------
nmi_1 = compare(BuettnerFlorian$true_labs[,1], example$y$cluster, method="nmi")
nmi_1

## ----image, fig.show='hide', fig.width=5, fig.height=5,results='hide'---------------
plot(example$ydata, 
    col = c(topo.colors(BuettnerFlorian$n_clust))[BuettnerFlorian$true_labs[,1]], 
    xlab = "SIMLR component 1",
    ylab = "SIMLR component 2",
    pch = 20,
    main="SIMILR 2D visualization for BuettnerFlorian")

## ----SIMLR_Feature_Ranking_run, results='hide'--------------------------------------
set.seed(11111)
ranks = SIMLR_Feature_Ranking(A=BuettnerFlorian$results$S,X=BuettnerFlorian$in_X)

## ----head-ranks---------------------------------------------------------------------
head(ranks$pval)
head(ranks$aggR)

## ----CIMLR_run, warning=FALSE-------------------------------------------------------
set.seed(11111)
example_llg = CIMLR(X = GliomasReduced$in_X, c = 3, cores.ratio = 0)

## ----SIMLR_Large_Scale_run, warning=FALSE-------------------------------------------
set.seed(11111)
example_large_scale = SIMLR_Large_Scale(X = ZeiselAmit$in_X, c = ZeiselAmit$n_clust, kk = 10)

## ----nmi_performance_large_scale----------------------------------------------------
nmi_2 = compare(ZeiselAmit$true_labs[,1], example_large_scale$y$cluster, method="nmi")
nmi_2

## ----image_large_scale, fig.show='hide', fig.width=5, fig.height=5,results='hide'----
plot(example_large_scale$ydata, 
    col = c(topo.colors(ZeiselAmit$n_clust))[ZeiselAmit$true_labs[,1]], 
    xlab = "SIMLR component 1",
    ylab = "SIMLR component 2",
    pch = 20,
    main="SIMILR 2D visualization for ZeiselAmit")

## ----SIMLR_Number_Clusters_run, warning=FALSE---------------------------------------
set.seed(53900)
NUMC = 2:5
res_example = SIMLR_Estimate_Number_of_Clusters(BuettnerFlorian$in_X,
    NUMC = NUMC,
    cores.ratio = 0)

## ----SIMLR_NC_output_k1-------------------------------------------------------------
NUMC[which.min(res_example$K1)]

## ----SIMLR_NC_output_k2-------------------------------------------------------------
NUMC[which.min(res_example$K2)]

## ----SIMLR_NC_output, warning=FALSE-------------------------------------------------
res_example

## ----sessioninfo, results='asis', echo=FALSE----------------------------------------
toLatex(sessionInfo())

