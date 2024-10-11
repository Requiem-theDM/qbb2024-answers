# install new packages
BiocManager::install("DESeq2")
BiocManager::install("vsn")
install.packages("ggfortify")
install.packages("hexbin")

# Establish Environment
library(DESeq2)
library(vsn)
library(matrixStats)
library(dplyr)
library(readr)
library(tibble)
library(hexbin)
library(ggplot2)
library(ggthemes)
library(ggfortify)

# Trim Data to Match DESeq2 Requirements
data = read_tsv("qbb2024-answers/week5/salmon.merged.gene_counts.tsv")
data = column_to_rownames(data,var="gene_name")
data = dplyr::select(data,-gene_id)
data = dplyr::mutate_if(data,is.numeric,as.integer)
data = data[rowSums(data) > 100,]

#Filter Data to Midgut Tissues
narrow = dplyr::select(data,"A1_Rep1":"P2-4_Rep3")

# Create metadata tibble with tissues and replicate numbers based on sample names
# This is the corrected version.
narrow_metadata = tibble(Tissue=as.factor(c("A1", "A1", "A1",
                                            "A2-3", "A2-3", "A2-3",
                                            "Cu", "Cu", "Cu",
                                            "LFC-Fe", "LFC-Fe", "Fe",
                                            "LFC-Fe","Fe","Fe",
                                            "P1","P1","P1",
                                            "P2-4","P2-4","P2-4")),
                        Replicate=as.factor(c("Replicate1", "Replicate2", "Replicate3",
                                              "Replicate1", "Replicate2", "Replicate3",
                                              "Replicate1", "Replicate2", "Replicate3",
                                              "Replicate1", "Replicate2", "Replicate1",
                                              "Replicate3", "Replicate2", "Replicate3",
                                              "Replicate1", "Replicate2", "Replicate3",
                                              "Replicate1", "Replicate2", "Replicate3")))

# Create a DESeq data object
narrowdata = DESeqDataSetFromMatrix(countData=as.matrix(narrow), colData=narrow_metadata, design=~Tissue)

# Batch-correct data to remove excess variance with variance stabilizing transformation
narrowVstdata = vst(narrowdata)

# Plot variance by average to verify the removal of batch-effects
meanSdPlot(assay(narrowVstdata))

# Perform PCA and plot to check batch-correction
narrowVstPcaData = plotPCA(narrowVstdata,intgroup=c("Replicate","Tissue"), returnData=TRUE)
ggplot(narrowVstPcaData, aes(PC1, PC2, color=Tissue, shape=Replicate)) +
  geom_point(size=5) +
  scale_color_colorblind() +
  labs(title = "VST Corrected Principle Component Analysis of Midgut Tissues")
#  ggsave("~/qbb2024-answers/week5/PCAPlot.png")

# Convert into a matrix and filter for highly variant genes
matnarrow = as.matrix(assay(narrowVstdata))
combinedReps = matnarrow[,seq(1,21,3)]
combinedReps = combinedReps + matnarrow[,seq(2,21,3)]
combinedReps = combinedReps + matnarrow[,seq(3,21,3)]
combinedReps = combinedReps /3
matnarrow = matnarrow[rowSds(combinedReps) > 1,]

# Set seed so this clustering is reproducible
set.seed(42)

# Cluster genes using k-means clustering
k=kmeans(matnarrow, centers=12)$cluster

# Find ordering of samples to put them into their clusters
ordering = order(k)

# Reorder genes
k = k[ordering]

# Save heatmap
png("~/qbb2024-answers/week5/heatmap.jpg")
heatmap(matnarrow[ordering,],Rowv=NA,Colv=NA,RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])
dev.off()

# Pull out gene names from a specific cluster
genes = rownames(matnarrow[k == 1,])

# Same gene names to a text file
write.table(genes, "~/qbb2024-answers/week5/cluster_genes.txt", sep="\n", quote=FALSE, row.names=FALSE, col.names=FALSE)
