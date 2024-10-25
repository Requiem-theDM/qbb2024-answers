# Establish Environment
library(tidyverse)
library(broom)
library(ggthemes)
library(DESeq2)

# Question 1

# Change Working Directory
setwd(dir = "~/qbb2024-answers/week7/")

# Import Data
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
metadata_df <- read_delim("gtex_metadata_downsample.txt")

# Parse Data into DESeq2 Format
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")

# Confirm metadata and column names in the counts are the same and in the same order
table(colnames(counts_df) == rownames(metadata_df))

# create a DESeq object
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)

# apply VST normalization
vsd <- vst(dds)

sexPCA <- plotPCA(vsd, intgroup = "SEX") +
  theme_base(base_size = 10) +
  labs(title="PCA Analysis of Expression by Sex",color="Sex") +
  scale_color_colorblind(labels = c("Female","Male"))
agePCA <- plotPCA(vsd, intgroup = "AGE") +
  theme_base(base_size = 10) +
  labs(title="PCA Analysis of Expression by Age",color="Age Group") +
  scale_color_continuous(labels = c("20-29","30-39","40-49","50-59","60-69","70-79"))
codPCA <- plotPCA(vsd, intgroup = "DTHHRDY") +
  theme_base(base_size = 10) +
  labs(title="PCA Analysis of Expression by Cause of Death",color="Cause of Death") +
  scale_color_colorblind(labels = c("Natural Causes","Death on Ventilator"))
ggsave("ex1sexPCA.png",sexPCA)
ggsave("ex1agePCA.png",agePCA)
ggsave("ex1codPCA.png",codPCA)

# Question 1.3.3
# 48% and 7%
# Cause of death appears to explain ~48% of the variance as patients cluster strongly on the PC1 axis by cause of death, while Age seems to be the next largest component with patients clustering weakly along the PC2 axis by age.

# Question 2

# Create VST Expression Matrix
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata_df, vsd_df)



# Question 2.1.1
# Perform multiple linear regression of WASH7P
WASH7Pmodel <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
# No, it shows no significant change in expression for a patient being male or female, given the p value of 2.792437e-01 for SEXmale being above a standard threshol of p = 0.05.

# Question 2.1.2
# Perform multiple linear regression of WASH7P
SLC25A47model <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
# Yes, it shows a significant change in expression when a patient is male, given the p value of 2.569926e-02 for SEXmale being below a standard threshold of p = 0.05.

# Question 2.2
# use DESeq2 to perform differential expression analysis across all genes
dds <- DESeq(dds)

# Question 2.3
# Look for differential expression in genes based on sex.
resSEX <- results(dds, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")

# Question 2.3.1
# Filter out NA values from the results
resSEX <- resSEX %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

# Question 2.3.2
# Filter for only padj values below 0.1 to select all samples where FDR = 10%
resSEX <- resSEX %>%
  filter(padj < 0.1) %>%
  arrange(padj)

dim(resSEX)[1]
# 262 genes are differentially expressed at a FDR of 10%.

# Question 2.3.3
gene_loc = read.delim("gene_locations.txt")
deGenesByLocation = left_join(gene_loc,resSEX,by="GENE_NAME") %>% arrange(padj)

# Unsurprisingly, the genes which are most differentially expressed between men and women are located on the sex chromosomes.
# Male genes are more upregulated near the top of the list, as female was set as the reference level.

# Question 2.3.4
WASH7DESeq = deGenesByLocation %>% filter(GENE_NAME == "WASH7")
SLC25A47DESeq = deGenesByLocation %>% filter(GENE_NAME == "SLC25A47")

# Broadly, the results are consistent, as SLC25A47 was found in the FDR = 10% dataset, while WASH7 was not.

# Question 2.4.1
resCOD <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")

resCOD <- resCOD %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

resCOD <- resCOD %>%
  filter(padj < 0.1) %>%
  arrange(padj)

dim(resCOD)[1]
# 16069 genes are differentially expressed at a FDR of 10%.

# Question 2.4.2
# Given the previous finding that cause of death explained 48% of the differential expression while sex explained only 7%, it is unsurprising that approximately 48% of all differentially expressed genes are found in the dataset filtered for cause of death as the variable of interest.

# Question 3
volcanoPlot = ggplot(data = resSEX, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = (abs(log2FoldChange) > 1 & -log10(padj)>1))) +
  geom_text(data = resSEX %>% filter(abs(log2FoldChange) > 2 & -log10(padj) > 100),
            aes(x = log2FoldChange, y = -log10(padj) + 5, label = GENE_NAME), size = 2,) +
  theme_base(base_size = 10) +
  geom_line(mapping = aes(1),linetype = "dashed") +
  geom_line(mapping = aes(-1),linetype = "dashed") +
  geom_line(mapping = aes(y=1),linetype = "dashed") +
  theme(legend.position = "none") +
  labs(title="Volcano Plot of Differential Expression by Sex") +
  scale_color_colorblind() +
  labs(y = expression(-log[10]("padj")), x = expression(log[2]("Fold Change")))
ggsave("ex3volcanoPlot.png",volcanoPlot)
