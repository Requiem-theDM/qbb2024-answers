library(tidyverse)
library(palmerpenguins)
library(broom)

head(penguins)
glimpse(penguins)

# is there a relationship between bill length and depth


summary(lm(data = penguins, formula = bill_length_mm ~ 1 + bill_depth_mm))

ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm))+
  geom_point(aes(color = species))

gentoo <- penguins %>% filter(species == "Gentoo")
chinstrap <- penguins %>% filter(species == "Chinstrap")
adelie <- penguins %>% filter(species == "Adelie")


#Consider species together
full_model <- lm(data = penguins %>% filter(!is.na(sex)), formula = bill_length_mm ~ 1 + bill_depth_mm + species)
#The P values of the individual types are telling if there is a statistically significant different between that line and the reference (which is the alphabetically first group unless specified)
reduced_model <- lm(data = penguins %>% filter(!is.na(sex)), formula = bill_length_mm ~ 1 + bill_depth_mm)

anova(full_model,reduced_model) #This tells us that our full model is a better predictor than the reduced model, so species is an important factor

#Also consider sex
fuller_model <- lm(data = penguins %>% filter(!is.na(sex)), formula = bill_length_mm ~ 1 + bill_depth_mm + species + sex)
summary(fuller_model) #Males on average have bills that are 2.89 mm longer (this is a significant difference)

anova(fuller_model,full_model)

print(27.6224 + 0.5317*17.5 + 10.4890 + 2.8938)

new_penguin <- tibble(
  bill_depth_mm = 17.5,
  species = "Gentoo",
  sex= "male")

predict(fuller_model,new_penguin)
