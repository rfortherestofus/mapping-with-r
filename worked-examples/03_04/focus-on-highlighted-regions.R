library(tigris)
library(sf)
library(janitor)
library(rmapshaper)
library(leaflet)
library(leaflet.extras)
library(tidyverse)

us_states <- states(resolution = "500k") %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

us_contiguous <- us_states %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

texas_state <- us_contiguous %>% 
  filter(name == "Texas")

# ==== New code =====

texas_border_states <- us_contiguous[st_touches(texas_state, us_contiguous, sparse = FALSE), ]

texas_counties <- counties(state = "TX") %>% 
  ms_simplify()

# ==== Data viz ====

