library("tidyverse") #Load Tidyverse

df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt") #Load Subject Metadata

df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 ) #Create Subject Column

df %>%
  group_by(SUBJECT) %>%
  summarize(count=n()) %>%
  arrange(desc(count))
#Find Subjects with most samples
#K-562 and NPJ8 have the most samples at 217 and 72 respectively

df %>%
  group_by(SMTSD) %>%
  summarize(count=n()) %>%
  arrange(desc(count))
#Find Tissue Types with most samples

df %>% group_by(SMTSD) %>%
  summarize(count=n()) %>%
  arrange(count)
#Find Tissue Types with least samples

#Blood and muscle are really easy to sample from a body, kidney/cervix are harder, cervix in particular is limited to just female subjects

df_npj8 <- subset(df, SUBJECT == "GTEX-NPJ8")
#Filter the dataframe for subject npj8

df_npj8 %>%
  group_by(SMTSD) %>%
  summarize(count=n()) %>%
  arrange(desc(count))
#Find tissue types with most samples

df_npj8_whole_blood <- subset(df_npj8, SMTSD == "Whole Blood")
#Subset specifically for whole blood

view(df_npj8_whole_blood)
#Different molecules (RNA/DNA) and different sequencing machinery

SMATSSCR <- df %>%
  filter(!is.na(SMATSSCR)) %>%
  group_by(SUBJECT) %>%
  summarize(meanSM=mean(SMATSSCR)) 

sum(SMATSSCR$meanSM == 0)
# 15 Subjects have a mean SMATSSCR of 0
# Main information to learn is standard deviation depending on subject / tissue type
# A scatterplot grouped by either subject or tissue type likely makes the most sense
