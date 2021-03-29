library("stars")
library("tidyverse")
library("lubridate")
library("mapview")

## ==== Australian weather data ====

australia_daily_max_temp_2015_jan <- read_stars("data/australia_daily_max_temp_2015_jan.tif")

australia_daily_max_temp_2015_jan_bands <- read_csv("data/band-details_australia_daily_max_temp_2015_jan.csv")

australia_daily_max_temp_2015_jan_bands <- read_csv("data/band-details_australia_daily_max_temp_2015_jan.csv")

australia_daily_max_temp_2015_jan <- australia_daily_max_temp_2015_jan %>% 
  st_set_dimensions(3, values = australia_daily_max_temp_2015_jan_bands$date, name = "time")

names(australia_daily_max_temp_2015_jan) <- "max_temp"

## ==== Asustralia sub-regions ====

australia_sf <- read_sf("data/australia-shapefiles")

