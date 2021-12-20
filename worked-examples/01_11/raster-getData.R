library(raster)
library(tidyverse)
library(sf)
library(mapview)

france_adm0 <- getData(country = "FRA", level = 0)