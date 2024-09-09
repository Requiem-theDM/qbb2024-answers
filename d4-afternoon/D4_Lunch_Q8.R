#ENVIRONMENT
library(tidyverse)
library(ggthemes)

df <- read.delim("~/qbb2024-answers/d4-afternoon/relevant_expression_values.tsv")

mutant_df <- df %>% dplyr::mutate(Tissue_Gene=paste0(Tissue, " ", GeneID))

mutant_df <- mutant_df %>% dplyr::mutate(log_Expression_Values = log2(Expression_Values + 1))


ggplot(data = mutant_df, mapping = aes(x= log_Expression_Values,y = Tissue_Gene)) +
  geom_violin() +
  ylab("Tissue, Gene Pair") +
  xlab("Expression Value")

#Overall yes, as I would have expected most genes to display substantially lower variance if they are so highly expressed.
#Notably, the pancreas seems to have substantially reduced variability compared to the other tissue, gene pairings, likely these genes are relatively tightly regulated, and any individuals for whom expression levels fall outside of the ranges here are unlikely to survive, or were filtered out of the study's samples due to preexisting conditions such as diabetes.