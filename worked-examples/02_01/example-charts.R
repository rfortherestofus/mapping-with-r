library(tidyverse)
library(sf)
library(rnaturalearthdata)







world_sf <- countries110 %>% 
  st_as_sf()

quakes_sf <- quakes %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)




