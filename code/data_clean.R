## Load Packages
if (!require(tidyverse)) {
  install.packages("tidyverse")
}
library(tidyverse)

## Read in Data
grosses <- read.csv("../data/2020-04-28/grosses.csv")
synopses <- read.csv("../data/2020-04-28/synopses.csv")
cpi <- read.csv("../data/2020-04-28/cpi.csv")
pre_starts <- read.csv("../data/2020-04-28/pre-1985-starts.csv")

## Filter show which has seats_sold
show_gross <- grosses %>% 
  select(week_ending, show, seats_sold) %>% 
  arrange(show)
head(show_gross)  

write.csv(show_gross, file = "../data/df_show_gross.csv", row.names = FALSE)
