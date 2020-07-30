library(ggplot2)
library(ggforce)

ggplot() +
  geom_regon(aes(x0 = runif(8), y0=runif(8), 
                 sides = sample(3:10, 8), angle = 0,
                 r = runif(8) / 10))+
  coord_fixed()

ggplot() +
  geom_regon(aes(x0 = runif(8), y0 = runif(8), sides = sample(3:10, 8), angle = 0,r = runif(8) / 10), 
             expand = unit(1, 'cm'),
             radius = unit(0.1, 'cm')) +
  coord_fixed()
