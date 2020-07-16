# packages ----------------------------------------------------------------
library(tidyverse)

# Read in data ------------------------------------------------------------
tt_output <- tidytuesdayR::tt_load(2020, week = 29)
coffee_ratings <- tt_output$coffee_ratings



# Clean data --------------------------------------------------------------
glimpse(coffee_ratings)
table(coffee_ratings$country_of_origin)



# Transform Data ----------------------------------------------------------
main_origins <- count(coffee_ratings, country_of_origin) %>% 
  filter(n > 20) %>% 
  arrange(desc(n)) %>% 
  .[1:10,] %>% 
  pull(country_of_origin)
dt <- coffee_ratings %>% 
  filter(country_of_origin %in% main_origins) %>% 
  select(total_cup_points, species, country_of_origin, 
         acidity, balance, aroma, flavor, uniformity) %>% 
  .[complete.cases(.),] 
index <- c("acidity", "balance", "aroma", "flavor")

avg_points <- dt[,c("country_of_origin", "total_cup_points")] %>% 
  group_by(country_of_origin) %>% 
  summarise(
    avg_points = round(mean(total_cup_points), 2)
  ) %>% 
  ungroup()

# Visualization -----------------------------------------------------------
library(ggiraphExtra)
library(hrbrthemes)
library(RColorBrewer)

p <- ggRadar(dt[,c("country_of_origin", index)], 
             aes(group = country_of_origin), 
             rescale = FALSE, legend.position = "none", alpha = 0.6,
             size = 3, interactive = FALSE, use.label = TRUE
             ) +
  facet_wrap(~country_of_origin, ncol = 3) + 
  scale_y_discrete(breaks = NULL) + # don't show ticks 
  theme(axis.text.x = element_text(size = 12)) + # larger label sizes
  # adjust colors of radar charts to uniform colors
  scale_fill_brewer(palette = "Set3") +
  scale_color_brewer(palette = "Set3") +
  labs(fill = "Origin", col = "Origin") +
  theme_ft_rc() +
  ggtitle("Coffee Ratings Radar Charts")
print(p)

ggsave("plot_out.png")
