library(tigris)
library(tidycensus)
library(sf)
library(leaflet)
library(janitor)
library(rmapshaper)
library(tidyverse)

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15))


vars_2019 <- load_variables(year = 2019, dataset = "acs5")

state_population <- get_acs(geography = "state",
                            year = 2019,
                            variables = c("population" = "B01003_001"))

us_contiguous_population <- us_contiguous %>% 
  left_join(state_population,
            by = c("geoid" = "GEOID"))

# ==== dataviz =====




