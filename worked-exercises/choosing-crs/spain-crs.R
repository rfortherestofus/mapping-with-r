library("tidyverse")
library("sf")
library("mapview")
library("maps")

spain_sf <- raster::getData(country = "ESP", level = 1, download = TRUE) %>% 
  st_as_sf() %>% 
  select(NAME_1)

spain_cities <- world.cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  filter(country.etc == "Spain")

spain_sf %>% 
  mutate(cities_in_region = lengths(st_covers(spain_sf, spain_cities)))