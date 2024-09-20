# Establish Environment
library(tidyverse)
library(ggthemes)

#Load Data
snpenrich <- read.delim("~/qbb2024-answers/week2/snp_counts.txt") #Reads in the output from ex 2.1

#Log transforms enrichment values
snpenrich <- snpenrich %>% mutate(logEnrichment = log2(Enrichment)) 

#Filter data by feature type
exons <- snpenrich %>% filter(Feature == "exons")
introns <- snpenrich %>% filter(Feature == "introns")
cCREs <- snpenrich %>% filter(Feature == "cCREs")
other <- snpenrich %>% filter(Feature == "other")

ggplot() +
  geom_line(data=exons,aes(MAF,logEnrichment,color="Exons")) + #Graphs exons and adds "Exons" to the legend
  geom_line(data=introns,aes(MAF,logEnrichment,color="Introns")) + #See above, but Introns
  geom_line(data=cCREs,aes(MAF,logEnrichment,color="cCREs")) + #See above, but cCREs
  geom_line(data=other,aes(MAF,logEnrichment,color="Other")) + #See above, but Other gene elements
  scale_color_colorblind() + #Scales the line colors in a colorblind safe manner
  labs(color="Legend",x="Minor Allele Frequency",y="Log2 of SNP Enrichment",title="SNP Enrichment vs. Minor Allele Frequency") + #Adds axis labels, legend, and title
  ggsave(filename = "~/qbb2024-answers/week2/snp_enrichments.pdf") #Saves the plot to a pdf, ignore the error, as it still saves just fine.
