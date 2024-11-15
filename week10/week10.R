library(tidyverse)
library(ggthemes)

setwd("~/qbb2024-answers/week10/")
nuclei = read_csv("nuclei.csv")

meanRatioByGene = nuclei %>% group_by(gene) %>% summarise(mean = mean(Ratio))

ggplot(nuclei,aes(x=gene,y = nascentRNA))+
  geom_violin() +
  theme_bw() +
  labs(title = "Nascent RNA Mean Nuclear Signal by Gene Knockdown",x="Gene",y="Nascent RNA Mean Nuclear Signal")
ggsave("NascentRNA.png")

  ggplot(nuclei,aes(x=gene,y = PCNA))+
  geom_violin() +
  theme_bw() +
  labs(title = "PCNA Mean Nuclear Signal by Gene Knockdown",x="Gene",y="PCNA Mean Nuclear Signal")
ggsave("PCNA.png")
  
  ggplot(nuclei,aes(x=gene,y = Ratio))+
    geom_violin() +
    theme_bw() +
    labs(title = "Ratio of Nascent RNA and PCNA\nMean Nuclear Signal by Gene Knockdown",x="Gene",y="log2( RNA Mean Nuclear Signal/\nPCNA Mean Nuclear Signal)")
ggsave("Ratio.png")
  