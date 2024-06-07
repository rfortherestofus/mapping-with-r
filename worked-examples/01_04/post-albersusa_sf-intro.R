library(sf)
library(mapview)
library(tidyverse)
library(tigris)

us_states <- states(resolution = "20m")

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
  filter(REGION < 5) %>% 
  shift_geometry() %>% 
  count(REGION) %>% 
  mapview(zcol = "REGION")
