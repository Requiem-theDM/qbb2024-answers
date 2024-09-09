library(tidyverse)
library(ggthemes)
library(broom)

#Exercise 1
dnm <- read.csv(file = "~/qbb2024-answers/d4-afternoon/aau1043_dnm.csv")
pa <- read.csv(file = "qbb2024-answers/d4-afternoon/aau1043_parental_age.csv")

#Exercise 1.2
dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father"),
            n_maternal_dnm = sum(Phase_combined == "mother"))

#Exercise 1.4
dnm_by_age <- left_join(dnm_summary, pa, by = "Proband_id")

#Exercise 2

#Exercise 2.1
ggplot(data = dnm_by_age, mapping = aes(x = Mother_age, y = n_maternal_dnm)) +
  geom_point() +
  xlab("Maternal Age") +
  ylab("Number of de Novo Mutations")

ggplot(data = dnm_by_age, mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() +
  xlab("Paternal Age") +
  ylab("Number of de Novo Mutations")

#Exercise 2.2
maternal_model <- lm(data = dnm_by_age, formula = n_maternal_dnm ~ 1 + Mother_age)
summary(maternal_model)
#The average child has 2.5 dnm regardless of maternal age, and gains approximately 1 mutation per 3 years of maternal age.
#This effect is significant and of moderate strength and size. This is evident by the p value having an exponent of -16, and means that the trend is better explained by there being a relationship between maternal age and number of dnm than there not being a relationship between the two.

#Exercise 2.3
paternal_model <- lm(data = dnm_by_age, formula = n_paternal_dnm ~ 1 + Father_age)
summary(paternal_model)

#The average child has 10 dnm regardless of paternal age, and gains approximately 1 mutation per year of paternal age.
#This effect is significant and of high strength and size. This is evident by the p value having an exponent of -16, and means that the trend is better explained by there being a relationship between paternal age and number of dnm than there not being a relationship between the two.

#Exercise 2.4
new_father <- tibble(
  Father_age = 50.5
)
print(predict(paternal_model,new_father))

#Exercise 2.5
ggplot(data = dnm_by_age) +
  geom_histogram(mapping = aes(x = n_paternal_dnm),binwidth = 1, fill = "orange", alpha = 0.5) +
  geom_histogram(mapping = aes(x = n_maternal_dnm),binwidth = 1, fill = "blue", alpha = 0.5) +
  ylab("Frequency") +
  xlab("Number of de Novo Mutations")

#Exercise 2.6
t.test(dnm_by_age$n_maternal_dnm, dnm_by_age$n_paternal_dnm, paired = TRUE)
  
#2.6.1: I chose to use a paired sample t-test as the maternal and paternal values each come from single individuals, and the question being asked is if there is a difference in the means of the de novo mutations from each parent.
#2.6.2: My t test was statistically significant at a value of 2.2e-16, meaning that the data is better explained by the hypothesis that there is a difference in the de novo mutation rates between mothers and fathers.