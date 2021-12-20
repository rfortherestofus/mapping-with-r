library(maps)
library(tidyverse)
library(sf)
library(rnaturalearthdata)

brazil_cities <- world.cities %>% 
  filter(country.etc == "Brazil",
         pop > 1e6) %>% 
  mutate(capital = as.logical(capital))

brazil_cities_sf <- brazil_cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

brazil_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Brazil")




