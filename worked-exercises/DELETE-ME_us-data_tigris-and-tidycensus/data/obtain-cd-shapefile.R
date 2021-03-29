library("tidyverse")
library("sf")
library("tigris")
library("mapview")

us_cd_20m <- congressional_districts(resolution = "20m", cb = TRUE)

us_cd_20m %>%
  write_sf("data/us-congressional-districts/us-congressional-districts.shp")
