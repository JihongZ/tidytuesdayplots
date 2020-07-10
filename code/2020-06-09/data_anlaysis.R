
# Load Packages -----------------------------------------------------------
library(tidyverse)
library(usefulR)

# Get the Data

firsts <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv')
science <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/science.csv')


glimpse(firsts)
glimpse(science)


table(firsts$gender)
table(firsts$person)
table(firsts$category)

category_ordered <- firsts %>% 
  group_by(category) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  pull(category)
  
  

g0 <- ggplot(dt) +
  geom_bar(aes(x = year, fill = factor(category, levels = category_ordered))) +
  # geom_text(aes(x = year, y = 2, label = accomplishment), position = "jitter") +
  labs(x = "") +
  theme_classic() + 
  scale_y_continuous(limits = c(0, 15)) +
  guides(fill = guide_legend(title = "Category (Ordered)")) +
  theme(axis.ticks.x = element_blank()) 
