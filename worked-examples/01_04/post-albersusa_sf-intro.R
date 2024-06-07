library(sf)
library(mapview)
library(tidyverse)
library(tigris)

us_states <- states(cb = TRUE, resolution = "20m")

us_states$geometry

us_states %>% 
  mapview()


us_states %>% 
  shift_geometry() %>% 
  mapview()

us_states %>% 
  select(NAME, ALAND)

us_states %>% 
  st_drop_geometry()

starwars %>% 
  count(homeworld)

us_states %>% 
  mutate(`state is >=10% water` = {AWATER / ALAND} >= 0.1) %>% 
  shift_geometry() %>% 
  count(`state is >=10% water`) %>% 
  mapview(zcol = "state is >=10% water")
