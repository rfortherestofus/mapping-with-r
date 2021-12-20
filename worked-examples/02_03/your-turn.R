library(maps)
library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(ggrepel)

germany_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Germany")

world.cities %>% 
  filter(country.etc == "Germany") %>% 
  slice_max(pop, n = 10)