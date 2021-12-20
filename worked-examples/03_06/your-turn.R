library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)
library(leaflet)

# ==== States Data =====

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

us_contiguous <- us_contiguous %>% 
  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West"))

colors_of_regions <- list("Northeast" = "#c03728",
                          "Midwest" = "#919c4c",
                          "West" = "#fd8f24",
                          "South" = "#f5c04a")

# ==== Your Data Viz ==== 



