library("stars")
library("tidyverse")
library("readxl")

## ==== landsat 7 data

landsat7_data <- read_stars(system.file("tif/L7_ETMs.tif", package = "stars"))

landsat7_bands <- read_excel("data/landsat-7-bands.xlsx")




## ==== Australian weather data ====

australia_daily_max_temp_2015_jan <- read_stars("data/australia_daily_max_temp_2015_jan.tif")

australia_daily_max_temp_2015_jan_bands <- read_csv("data/band-details_australia_daily_max_temp_2015_jan.csv")