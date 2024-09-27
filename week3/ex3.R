# Establish Environment
library(tidyverse)
library(ggthemes)

#Load Data
alleleFreq <- read.delim("~/qbb2024-answers/week3/AF.txt")
readDepth <- read.delim("~/qbb2024-answers/week3/DP.txt")

ggplot(alleleFreq,aes(x = Allele_Frequency)) +
  geom_histogram(bins=11) +
  aes(y = after_stat(count)/sum(after_stat(count))) + 
  scale_y_continuous(labels = scales::percent) +
  labs(title="Allele Frequency Across Variants",
       y="Percent of Variants",
       x="Allele Frequency") +
  ggsave("~/qbb2024-answers/week3/Allele_Frequency.png")

### Question 3.1 ###
# The distribution of allele frequency largely resembles a normal distribution. This is expected given that alleles of low frequency will often be removed from the population by genetic drift, while alleles of high frequency reduce genetic diversity, thus resulting in overall stabilizing selection.

ggplot(readDepth,aes(x=Read_Depth)) +
  geom_histogram(bins=21) +
  scale_x_continuous(breaks=c(0:20),limits=c(0,20)) +
  aes(y = after_stat(count)/sum(after_stat(count))) + 
  scale_y_continuous(labels = scales::percent) +
  labs(title="Read Depth Across Variants",
       y="Percent of Variants",
       x="Read Depth") +
  ggsave("~/qbb2024-answers/week3/Read_Depth.png")
  
  ### Question 3.2 ###
  # The distribution of read depth largely resembles a poisson distribution. Given the presumed random spread of reads through the genome and the expected average coverage of 4, it makes sense that the most common read depths would cluster around four, then decrease in frequency the further away from a coverage of 4 the values were.
