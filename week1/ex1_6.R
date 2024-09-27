# Establish Environment
library(tidyverse)
library(ggthemes)

set.seed(42)

#Import Data
coverage <- read.delim("~/qbb2024-answers/week1/ex1_6_output.txt",header = FALSE)

#Make Poisson and Norm Distribution
maxcoverage=max(coverage$V1)
poisson_estimates=1000000*dpois(0:maxcoverage,30)
normal_estimates=1000000*dnorm(0:maxcoverage,30,sqrt(30))

#Plot Data
ggplot() +
  geom_histogram(data=coverage,aes(x=V1),binwidth=1,color="grey",outline="white") +
  geom_line(aes(x=0:maxcoverage,y=poisson_estimates,color="Poisson")) +
  geom_line(aes(x=0:maxcoverage,y=normal_estimates,color="Normal")) +
  scale_color_manual(values = c(Poisson = "blue", Normal = "yellow")) +
  xlab("Coverage Depth") +
  ylab("Frequency") +
  ggsave(filename="~/qbb2024-answers/week1/ex1_30x_cov.png")


