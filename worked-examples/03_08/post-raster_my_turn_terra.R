library(terra)
library(tidyterra)
library(tidyverse)
library(ggspatial)
library(leaflet)

alaska_landuse <- rast("data/recoded_alaska_landcover.img")

landuse_types <- read_csv("data/landuse-codes.csv")

colors_landuse <- c("0" = "cadetblue3", "1" = "darkolivegreen", "2" = "darkgreen", "4" = "chocolate", "5" = "antiquewhite")

labels_landuse <- landuse_types %>% 
  filter(value %in% unique(values(alaska_landuse))) %>% 
  select(value, label) %>% 
  deframe()


# ==== dataviz ====

alaska_landuse <- alaska_landuse %>% 
  mutate(landuse = case_when(Layer_1 == 0 ~ "Water", 
                             Layer_1 == 1 ~ "Evergreen Needlelead Forest", 
                             Layer_1 == 2 ~ "Evergreen Broadleaf Forest", 
                             Layer_1 == 4 ~ "Deciduous Broadleaf Forest", 
                             Layer_1 == 5 ~ "Mixed Forest"))

pal_alaska_landuse <- colorFactor(as.character(colors_landuse), values(alaska_landuse$Layer_1), na.color = "pink")

leaflet() %>% 
  addRasterImage(alaska_landuse,
                 colors = pal_alaska_landuse) %>% 
  addLegend(pal = pal_alaska_landuse,
            values = values(alaska_landuse$Layer_1))
