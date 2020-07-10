library(tidyverse)
library(ggplot2)

dt <- read.csv("../data/df_show_gross.csv")

rankbyseats <- 
  dt %>% 
  group_by(show) %>% 
  summarize(total_seats = max(seats_sold)) %>% 
  arrange(desc(total_seats)) %>% 
  mutate(rank = 1:nrow(.))

dt <- dt %>% 
  left_join(rankbyseats, by="show")

top10 <- filter(dt, rank < 11)
top10$year <- format(as.Date(top10$week_ending,format="%Y-%m-%d"), "%Y")

top10 <- top10 %>% 
  group_by(show, year) %>% 
  summarise(n_total = sum(total_seats))

## Plot the top ten shows
top10 %>% 
  ggplot(aes(x=year, y=n_total, color=show, group=show)) +
  geom_line(size=1.5, alpha = 0.8)+
  labs(y="", 
       title="Line Plot for Total Seats Sold For Broadyway Show")+
  scale_x_discrete(breaks = seq(1985, 2020, 10)) +
  hrbrthemes::theme_ft_rc() +
  labs(caption=
         "(Data from #tidytuesday)
       @JihongZhang")
ggsave(filename = "../code/Line_Plot.png")
