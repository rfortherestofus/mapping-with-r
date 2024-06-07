library(rnaturalearthdata)
library(sf)
library(mapview)
library(tigris)

us_states <- states(cb = TRUE, resolution = "20m")

us_states %>% 
  mapview()

us_states %>% 
  shift_geometry() %>% 
  mapview()


alaska_landcover <- raster("data/alaska_landcover.img")

library(terra)

alaska_terra <- rast("data/alaska_landcover.img")

alaska_terra %>% 
  mapview()

countries110 %>% 
  mapview()

countries110 %>% 
  st_as_sf() %>% 
  mapview()

mapview(c(countries110, tiny_countries110))

usa_sf() %>% 
  mapview()


library(leaflet)

leaflet() %>% 
  addRasterImage(alaska_landcover)

library(ggspatial)

library(tidyterra)

ggplot() +
  geom_spatraster(data = alaska_terra)
