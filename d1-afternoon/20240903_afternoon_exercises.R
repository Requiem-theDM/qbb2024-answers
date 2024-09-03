#ENVIRONMENT
library(tidyverse)
library(ggthemes)

#Q1
df <- read.delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Q2
df
glimpse(df)

#Q3
rna_df <- df %>% filter(SMGEBTCHT == "TruSeq.v1")
sorted_rna_df <- rna_df %>% group_by(SMTSD) %>% summarise(ct=n())
                                         
#Q4
ggplot(data = sorted_rna_df, mapping = aes(x = reorder(SMTSD,ct),y = ct)) +
  geom_col(position="identity") +
  xlab("Tissue Type") +
  theme(axis.text.x = element_text(angle=90)) +
  ylab("Frequency") +
  ggtitle("Tissue Type Frequency")

#Q5
ggplot(data = rna_df, mapping = aes(x = SMRIN)) +
  geom_histogram(binwidth = 0.1) +
  xlab("RNA Integrity Number (RIN)") +
  ylab("Frequency") +
  ggtitle("RNA Integrity Number of All Samples")
#The distribution is bimodal, with a large peak centered on  7 and a secondary peak at 10.

#Q6
ggplot(data = rna_df, mapping = aes(x = SMTSD,y = SMRIN)) +
  geom_boxplot() +
  xlab("Tissue Type") +
  theme(axis.text.x = element_text(angle=90)) +
  ylab("RNA Integrity Number (RIN)") +
  ggtitle("RNA Integrity Number by Tissue Type")
#The cultured cell lines appear to have substantially higher mean RIN, likely due to the easier access to said samples, thus allowing experimenters to choose higher quality samples overall.

#Q7
ggplot(data = rna_df, mapping = aes(x = SMTSD,y = SMGNSDTC)) +
  geom_boxplot() +
  xlab("Tissue Type") +
  theme(axis.text.x = element_text(angle=90)) +
  ylab("Number of Genes Detected") +
  ggtitle("Number of Genes Detected by Tissue Type")
#Testis are an outlier, as they utilize transcriptional scanning to ensure germline gene integrity.

#Q8
ggplot(data = rna_df, mapping = aes(y = SMTSISCH,x = SMGNSDTC)) +
  geom_point(size = 0.5, alpha = 0.5) +
  xlab("Tissue Type") +
  theme(axis.text.x = element_text(angle=90)) +
  geom_smooth(method = "lm") +
  xlab("Ischemic Time") +
  ylab("Number of Genes Detected") +
  facet_wrap(SMTSD ~ .)
  ggtitle("Number of Genes Detected by Ischemic Time per Tissue Type")
  #Most tissues have a neutral relationship, but some excretory tissues such as the medula of the kidney and the female reproductive system have positive relationships.
  
#Q9
  ggplot(data = rna_df, mapping = aes(y = SMTSISCH,x = SMGNSDTC)) +
    geom_point(aes(color = SMATSSCR),size = 0.5, alpha = 0.5) +
    xlab("Tissue Type") +
    theme(axis.text.x = element_text(angle=90)) +
    geom_smooth(method = "lm") +
    xlab("Ischemic Time") +
    ylab("Number of Genes Detected") +
    facet_wrap(. ~ SMTSD)
  ggtitle("Number of Genes Detected by Ischemic Time per Tissue Type")
  #Broadly, blood and the nervous system do not appear to undergo significant autolysis, except for the cerebellum and cortex.
  
#Q10
  cml_df <- rna_df %>% filter(SMTSD == "Cells - Leukemia cell line (CML)")
  cml_df
glimpse(cml_df)
#Interestingly, the CML cell line was not kept on ice, unlike the primary tissues and other cultured cells.
