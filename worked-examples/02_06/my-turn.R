library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)

# ==== Streaming Data ====
# Data obtained from https://kiss951.com/2021/05/20/national-streaming-day-list-of-the-most-popular-streaming-services-in-each-state/

most_popular_streaming_service <- read_csv("data/most-popular-streaming-service.csv") %>% 
  clean_names()

# ==== States Data =====

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

us_most_popular_streaming_sf <- us_contiguous %>% 
  left_join(most_popular_streaming_service,
            by = c("name" = "state"))

# ==== Initial Data Visualisation ====






# ==== Ordering services in the legend ====






# ==== Alternative color palettes ====








# ==== Custom/manual color palette


colors_services <- list(
  "Amazon Prime" = "#2A96D9",
  "ESPN" = "#BE0002",
  "Hulu" = "#35B12E",
  "Netflix" = "black"
)


