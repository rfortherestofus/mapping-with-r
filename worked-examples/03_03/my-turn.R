library(sf)
library(rnaturalearthdata)
library(leaflet)
library(tidyverse)
library(leaflet.extras)

countries_sf <- countries110 %>% 
  st_as_sf()

