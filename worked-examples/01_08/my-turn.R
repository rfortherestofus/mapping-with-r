library(tidyverse)
library(sf)
library(countrycode)
library(rnaturalearthdata)
library(mapview)

countries_sf <- countries110 %>%
  st_as_sf() %>% 
  select(name, region_un, iso_a3)

countries_data <- tribble(
  ~country_name, ~choropleth_variable,
  "United Kingdom", 23,
  "USA", 30,
  "Peru", 26,
  "South Africa", 31,
  "Holland", 20
)
