# Establish Environment
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DropletUtils")
BiocManager::install("zellkonverter")

library(tidyverse)
library(DropletUtils)
library(zellkonverter)
library(ggthemes)
library(scuttle)
library(scater)
library(scran)

# Change Working Directory
setwd(dir = "~/qbb2024-answers/week8/")
gut = readH5AD("v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) = "counts"
gut = logNormCounts(gut)

#Question 1
gut
#There are 13407 genes in the dataset.
#There are 11788 cells in the dataset.
#The X-pca, X_tsne, and X_umap dimensional reductions are available

#Question 2
colData(gut)
#There are 39 columns
colnames(colData(gut))
#The most interesting columns are the broad_annotation as it provides the general cell type of each sample, while percent_mito and n_genes are important for quality control of the dataset, being markers for cell health and RNA capture efficiency.
set.seed(42)
plotReducedDim(gut,"X_umap",color="broad_annotation")

#Question 3
genecounts = rowSums(assay(gut))
summary(genecounts)
#The median is 254, while the mean is 3185, meaning the vast majority of genes are not highly expressed, but a few extremely highly expressed genes are present in the dataset.
sort(genecounts,TRUE)[1:3]
#The three highest expressed genes are Hsromega, CR45845, and roX1, each of which is RNA.

#Question 4.a
cellcounts = colSums(assay(gut))
hist(cellcounts)
summary(cellcounts)
#The mean cell count is 3622.
#The cells with higher cell counts likely come from more common cell types.

#Question 4.b
celldetected = colSums(assay(gut)>0)
hist(celldetected)
summary(celldetected)
#The mean gene count is 1059.
1059/13407
#This represents approximately 7 percent of the genes in the cell.

#Question 5
mito = grep("^mt:",rownames(gut),value=TRUE)
df = perCellQCMetrics(gut,subsets=list(Mito=mito))
df = as.data.frame(df)
summary(df)
colData(gut) = cbind( colData(gut), df )
plotColData(object = gut,y = "subsets_Mito_percent",x = "broad_annotation") + theme( axis.text.x=element_text( angle=90 ) ) + labs(x= "Cell Type",y="Percentage of Mitochondrial Gene Expression",title = "Percentage of Mitochondrial Gene Expression by Cell Type") + ggsave("Percentage of Mitochondrial Gene Expression by Cell Type.png")
#Broadly, the cells which are actively secreting large amounts of signaling molecules or storing and releasing large amounts of energy, such as the enteroendocrine cells, glands, muscle system, and adipose system have a higher proportion of mitochondrial gene expression, as they have higher energy needs.

#Question 6.a
coi = colData(gut)$broad_annotation == "epithelial cell"
epi = gut[,coi]
plotReducedDim(epi,"X_umap",color="annotation") + labs(x= "Umap 1",y="Umap 2",title = "UMap of Epithelial Cells",color="Cell Type") + ggsave("UMap of Epithelial Cells.png")
marker.info = scoreMarkers( epi, colData(epi)$annotation )
chosen = marker.info[["enterocyte of anterior adult midgut epithelium"]]
ordered = chosen[order(chosen$mean.AUC, decreasing=TRUE),]
ordered$mean.AUC[1:6]

#Question 6.b
#The top 6 genes are Mal-A6, Men-b, vnd, betaTry, Mal-A1, and Nhe2. Likely the anterior midgut is specialized to digest sugars.
plotExpression(epi,c("Mal-A6","Men-b","vnd","betaTry","Mal-A1","Nhe2"),x="annotation") + labs(x= "Annotation",y="Expression Log Fold Change",title = "Expression Log Fold Change in the Anterior Midgut") + theme( axis.text.x=element_text( angle=90 ) ) + ggsave("Expression Log Fold Change in the Anterior Midgut.png")

#Question 7
cellsOfInterest = colData(gut)$broad_annotation == "somatic precursor cell"
spc = gut[,cellsOfInterest]
spc.marker.info = scoreMarkers( spc, colData(spc)$annotation )
chosenSPCs = spc.marker.info[["intestinal stem cell"]]
orderedSPCs <- chosenSPCs[order(chosenSPCs$mean.AUC, decreasing=TRUE),]
goi = rownames(orderedSPCs)[1:6]
plotExpression(spc,goi,x="annotation")  + labs(x= "Annotation",y="Expression Log Fold Change",title = "Expression Log Fold Change in Somatic Precursor Cells") + theme( axis.text.x=element_text( angle=90 ) ) + ggsave("Expression Log Fold Change in Somatic Precursor Cells.png")
#Enteroblasts and Intestinal Stem Cells have the most similar expression patterns.
#DI is the most specific marker for intestinal stem cells. 
