library(tigris)
library(sf)
library(rmapshaper)
library(readxl)
library(janitor)
library(leaflet)
library(tidyverse)

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


order_streaming_service <- us_most_popular_streaming_sf %>% 
  # st_drop_geometry() %>% 
  count(streaming_service, sort = TRUE) %>% 
  as_tibble() %>% 
  drop_na() %>%
  pull(streaming_service)
  

# ==== Custom/manual color palette

colors_services <- list(
  "Amazon Prime" = "#2A96D9",
  "ESPN" = "#BE0002",
  "Hulu" = "#35B12E",
  "Netflix" = "black",
  "Missing" = "grey90"
)


order_streaming_service <- us_most_popular_streaming_sf %>% 
  st_drop_geometry() %>%
  count(streaming_service, sort = TRUE) %>% 
  as_tibble() %>% 
  replace_na(list(streaming_service = "Missing")) %>% 
  pull(streaming_service)

recoded_sf <- us_most_popular_streaming_sf %>% 
  mutate(streaming_service = fct_relevel(streaming_service, order_streaming_service)) %>% 
  mutate(streaming_service = fct_na_value_to_level(streaming_service, level = "Missing")) 


recoded_sf %>% 
  pull(streaming_service)

pal_streaming <- colorFactor(unlist(colors_services[order_streaming_service]), order_streaming_service)


recoded_sf %>% 
  pull(streaming_service)

recoded_sf %>% 
  leaflet() %>% 
  addPolygons(fillColor = ~pal_streaming(streaming_service),
              fillOpacity = 1) %>% 
  addLegend(pal = pal_streaming,
            values = ~streaming_service,
            opacity = 1)

us_most_popular_streaming_sf %>% 
  mutate(streaming_service = fct_relevel(streaming_service, order_streaming_service)) %>% 
  ggplot() +
  aes(fill = streaming_service) + 
  geom_sf() +
  scale_fill_manual(values = colors_services)


