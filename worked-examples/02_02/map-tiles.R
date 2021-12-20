library(maps)
library(sf)
library(rnaturalearthdata)
library(ggspatial)
library(tidyverse)

germany_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Germany")

germany_cities <- world.cities %>% 
  filter(country.etc == "Germany") %>% 
  slice_max(pop, n = 5) %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)