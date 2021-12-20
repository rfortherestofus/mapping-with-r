library(tidyverse)
library(sf)
library(tigris)
library(rmapshaper)
library(janitor)

us_airport_passengers <- read_csv("data/us-airport-passenger-numbers_2019.csv")

us_airport_passengers_2019 <- us_airport_passengers %>% 
  filter(year == 2019) %>% 
  st_as_sf(coords = c("long", "lat"))

us_contiguous_sf <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()
