library("tidyverse")
library("sf")
library("mapview")

england_sf <- read_sf("data/uk_local_authorities",
                      layer = "local_authorities_england")


republic_of_ireland_sf <- read_sf("http://data-osi.opendata.arcgis.com/datasets/e0cfbed6a3cc432295fd3e2f57451cad_0.geojson")

republic_of_ireland_sf %>%
  mapview()

brexit_referendum <- read_csv("data/brexit-referendum-results.csv")

brexit_referendum
