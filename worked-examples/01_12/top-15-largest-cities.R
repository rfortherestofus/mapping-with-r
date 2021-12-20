library(tidyverse)
library(sf)
library(mapview)
library(maps)

top_15_largest_cities <- world.cities %>% 
  slice_max(pop, n = 15)

