#Prepare Environment
library(tidyverse)
library(palmerpenguins) #Load Dataset
library(ggthemes) #Visual Themes for ggplot2

#Dataset and Visualization
penguins #Main dataframe from palmerpenguins set
glimpse(penguins) #Way of viewing rows/colums of a dataframe

#Basics of Data Indexing
?penguins #Lists information about the penguins dataframe
penguins[,"island"] #Extracts all rows in the island column
penguins[,c("species","island")] #Extracts all rows in the species and island columns, using numbers counts from 1
penguins[2,c("species","island")] #Extracts second row in the species and island columns, using numbers counts from 1
penguins[2,c(1,2)] #Is identical to the line above, but uses numerical indicators

#Plotting Data 101
ggplot() #Makes a blank plot
ggplot(data = penguins,
       mapping = aes(y = body_mass_g, x = flipper_length_mm)) #Plots body mass against flipper length
ggplot(data = penguins,
       mapping = aes(y = body_mass_g, x = flipper_length_mm)) +
  geom_point() #Actually plots the data points

ggplot(data = penguins,
       mapping = aes(y = body_mass_g, x = flipper_length_mm, colour = species)) +
  geom_point()  #Colors points by species

ggplot(data = penguins,
       mapping = aes(y = body_mass_g, x = flipper_length_mm, colour = species, shape = species)) +
  geom_point() +
  scale_color_colorblind() #Changes point shape by species and makes things colorblind safe
  #can use scale_color_manual(values = c("red", "purple", "green")) to manually set plot colors, this accepts hex codes

ggplot(data = penguins,
       mapping = aes(y = body_mass_g,
                     x = flipper_length_mm,
                     colour = species,
                     shape = species)) +
  geom_point() +
  scale_color_colorblind() +
  geom_smooth(method = "lm") #Adds a trendline to each species group

ggplot(data = penguins,
       mapping = aes(y = body_mass_g,
                     x = flipper_length_mm)) +
  geom_point(mapping = aes(colour = species,
                           shape = species)) + #Moves color/shape mapping just to the points
  scale_color_colorblind() +
  geom_smooth(method = "lm")

ggplot(data = penguins,
       mapping = aes(y = body_mass_g,
                     x = flipper_length_mm)) +
  geom_point(mapping = aes(colour = species,
                           shape = species)) +
  scale_color_colorblind() + 
  geom_smooth(method = "lm") +
  xlab("Flipper Length (mm)") + #Adds X axis label
  ylab("Body Mass (g)") #Adds Y axis label

ggplot(data = penguins,
       mapping = aes(y = body_mass_g,
                     x = flipper_length_mm)) +
  geom_point(mapping = aes(colour = species,
                           shape = species)) + #Moves color/shape mapping just to the points
  scale_color_colorblind() +
  geom_smooth(method = "lm")

ggplot(data = penguins,
       mapping = aes(y = body_mass_g,
                     x = flipper_length_mm)) +
  geom_point(mapping = aes(colour = species,
                           shape = species)) +
  scale_color_colorblind() + 
  geom_smooth(method = "lm") +
  xlab("Flipper Length (mm)") +
  ylab("Body Mass (g)") +
  ggtitle("Relationship Between Body Mass\n and Flipper Length") #Adds a title
  ggsave(filename = "penguin-plot.pdf",path = "~/qbb2024-answers/d1-afternoon/") #Saves graph as a pdf to specified directory

  ggplot(data = penguins %>% filter(sex != "na"),
         mapping = aes(x = bill_length_mm)) +
      geom_histogram(position = "identity", mapping = aes(fill = sex, alpha = 0.5)) +
    scale_fill_colorblind() + 
    facet_grid(sex ~ .) +
    facet_grid(. ~ species) +
    xlab("Bill Length (mm)") +
    ylab("Frequency") +
    ggtitle("Penguin Bill Length by Species and Sex")
  
  ggplot(data = penguins %>% filter(sex != "na"), mapping = aes(x = factor(year), y = body_mass_g)) +
    geom_boxplot(mapping = aes(fill = sex)) +
    scale_fill_colorblind() +
    facet_grid(island ~ species) +
    xlab("Year") +
    ylab("Body Mass (g)") +
    ggtitle("Penguin Body Mass over Time")
  
  ggplot(data = penguins %>% filter(sex != "na"), mapping = aes(x = factor(year), y = body_mass_g)) +
    geom_violin(mapping = aes(fill = sex)) +
    scale_fill_colorblind() +
    facet_grid(island ~ species) +
    xlab("Year") +
    ylab("Body Mass (g)") +
    ggtitle("Penguin Body Mass over Time")
  
  ggplot(data = penguins %>% filter(sex != "na"),
         mapping = aes(x = bill_length_mm)) +
    geom_density(position = "identity", mapping = aes(color = sex)) +
    scale_color_colorblind() + 
    facet_grid(sex ~ .) +
    facet_grid(. ~ species) +
    xlab("Bill Length (mm)") +
    ylab("Frequency") +
    ggtitle("Penguin Bill Length by Species and Sex")
  