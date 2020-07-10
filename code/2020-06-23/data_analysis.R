
# packages ----------------------------------------------------------------
library(tidyverse)
library(ggmap)

# Read in data ------------------------------------------------------------
tt_output <- tidytuesdayR::tt_load('2020-06-23')
individuals <- tt_output$individuals
locations <- tt_output$locations



# Clean data --------------------------------------------------------------

str(individuals)
individuals %>% 
  summarise(across(sex:death_cause, list(~ mean(., na.rm = TRUE)),.name = "{col}" ))

borders()

dt <- individuals %>% 
  left_join(locations, by = "animal_id")

theme_set(theme_bw())
where <- c(left = min(dt$longitude) -1, right = max(dt$longitude) + 1, 
           top = max(dt$latitude) + 1, bottom = min(dt$latitude) - 1)
Mymap <- get_map(where, source = "google", maptype = "terrain")
ggmap(ggmap = Mymap) +
  geom_point(aes(x = longitude, y = latitude, col = season), data = dt, alpha = 0.3) +
  theme_bw()

ggsave(paste0(getwd(), "map_out.png"))
