library(fivethirtyeight)
library(tidyverse)


bechdel %>% 
  filter(year == max(year)) %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point()
