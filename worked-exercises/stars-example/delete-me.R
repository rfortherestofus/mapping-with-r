library("stars")
library("tidyverse")
library("readxl")
library("lubridate")

## ==== landsat 7 data

landsat7_data <- read_stars(system.file("tif/L7_ETMs.tif", package = "stars"))

landsat7_bands <- read_excel("data/landsat-7-bands.xlsx")

landsat7_data %>% 
  filter(band == "6") %>% 
  mutate(normalised_thermal = L7_ETMs.tif / max(L7_ETMs.tif))

landsat7_data %>% 
  split("band") %>% 
  mutate(ndvi = {X4 - X3} / {X4 + X3}) %>% 
  select(ndvi) %>% 
  mapview()

## ==== Australian weather data ====

australia_daily_max_temp_2015_jan <- read_stars("data/australia_daily_max_temp_2015_jan.tif")

australia_daily_max_temp_2015_jan_bands <- read_csv("data/band-details_australia_daily_max_temp_2015_jan.csv")

australia_daily_max_temp_2015_jan <- australia_daily_max_temp_2015_jan %>% 
  st_set_dimensions(3, values = australia_daily_max_temp_2015_jan_bands$date, name = "time")

names(australia_daily_max_temp_2015_jan) <- "max_temp"

australia_daily_max_temp_2015_jan %>% 
  filter(time %in% c(ymd("2015-01-18"), ymd("2015-01-19")))


## ==== sweep ====

landsat7_data <- read_stars(system.file("tif/L7_ETMs.tif", package = "stars"))
landsat7_data_2015_01_01 <- landsat7_data
landsat7_data_2015_01_02 <- landsat7_data 

landsat7_sweep <- c(landsat7_data_2015_01_01, landsat7_data_2015_01_02) %>% 
  st_redimension() %>% 
  st_set_dimensions(4, values = c(as.Date("2015-01-01"), as.Date("2015-01-02")), name = "time")
landsat7_sweep

landsat7_thermal <- landsat7_data %>% 
  filter(band == 6) %>% 
  adrop()

landsat7_thermal_2020_01_01 <- landsat7_thermal
landsat7_thermal_2020_01_02 <- landsat7_thermal

landsat7_thermal_sweep_before_export <- c(landsat7_thermal_2020_01_01, landsat7_thermal_2020_01_02) %>% 
  st_redimension() %>% 
  st_set_dimensions(3, values = c(as.Date("2015-01-01"), as.Date("2015-01-02")), name = "time")
names(landsat7_thermal_sweep_before_export) <- "x"

landsat7_thermal_sweep_before_export %>% 
  write_stars("data/post_export_landsat7_thermal.tif")

post_export_landsat7_thermal <- read_stars("data/post_export_landsat7_thermal.tif")
post_export_landsat7_thermal

## ===== AUSTRALIA ===

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

western_aus_sf <- australia_sf %>% 
  filter(shapeName == "Western Australia")

australia_daily_max_temp_2015_jan %>% 
  .[western_aus_sf] %>% 
  mapview()

australia_daily_max_temp_2015_jan[western_aus_sf] %>% 
  mapview()

australia_sf[2]
