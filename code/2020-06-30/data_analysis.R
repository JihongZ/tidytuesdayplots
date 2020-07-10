# packages ----------------------------------------------------------------
library(tidyverse)

# Read in data ------------------------------------------------------------
tt_output <- tidytuesdayR::tt_load(2020, week = 27)
characters <- tt_output$characters



# Clean data --------------------------------------------------------------
glimpse(characters)
unique(characters$character)


# * Remove alias ----------------------------------------------------------
characters$character <- gsub("\\=.*", "", characters$character)
characters$character <- gsub("\\(.*", "", characters$character)

# Summary
kill_data <- characters %>% 
  group_by(character) %>% 
  summarise(
    n_kill_humans = sum(number_of_kills_humans),
    n_kill_nonhumans = sum(number_of_kills_non_humans, na.rm = TRUE)
  ) %>% 
  ungroup() %>% 
  filter(
    (!(n_kill_humans == 0) | !(n_kill_nonhumans == 0)) & (!is.na(n_kill_nonhumans) | !is.na(n_kill_humans))
  ) %>% 
  pivot_longer(starts_with("n_kill"), names_to = "type", values_to = "num") %>% 
  mutate(
    num = ifelse(num == 0, 0.01, num)
  )

library(RColorBrewer)
ggplot(kill_data, aes(x = ifelse(num > 20, 20, num), y = character, fill = as.factor(type))) +
  geom_bar(stat = "identity", position = position_dodge(), show.legend = FALSE) +
  geom_text(aes(x = ifelse(num > 20, 18.5, num + 0.1) , 
                label = ifelse(num == 0.01, 0, num)), position = position_dodge(width = 0.9)) +
  scale_x_continuous(limits = c(0, 20)) +
  labs(title = "Number of human/nonhuman killed by Charachers",
          subtitle = "Source: the Claremont Run Project and Malcom Barret(https://twitter.com/malco_barrett)",
          caption = "Orange: nonhuman; Green: human"
          ) +
  labs(x = "Number of the kiled", y = "") +
  scale_fill_brewer(palette = "Dark2") +
  theme(text=element_text(size=13,  family="Roboto Condensed"))
ggsave(paste0(getwd(), "/figure_out.png"))
