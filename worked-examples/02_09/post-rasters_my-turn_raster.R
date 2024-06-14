library(terra)
library(tidyterra)
library(tidyverse)
library(ggspatial)

alaska_landuse <- rast("data/recoded_alaska_landcover.img")

# ==== dataviz ====

tib_landuse <- tribble(
  ~value, ~label, ~colour,
  0, "Water", "#69BFC6",
  1, "Evergreen Needlelead Forest", "#4C602F",
  2, "Evergreen Broadleaf Forest", "#005A15",
  4, "Deciduous Broadleaf Forest", "#D05B25",
  5, "Mixed Forest", "#FBE7D3"
)



alaska_landuse <- alaska_landuse %>% 
  mutate(landuse = case_when(Layer_1 == 0 ~ "Water", 
                             Layer_1 == 1 ~ "Evergreen Needlelead Forest", 
                             Layer_1 == 2 ~ "Evergreen Broadleaf Forest", 
                             Layer_1 == 4 ~ "Deciduous Broadleaf Forest", 
                             Layer_1 == 5 ~ "Mixed Forest"))

ggplot() +
  geom_spatraster(data = alaska_landuse,
                  aes(fill = landuse)) +
  scale_fill_manual(values = c("Water" = "#69BFC6",
                               "Evergreen Needlelead Forest" = "#4C602F",
                               "Evergreen Broadleaf Forest" = "#005A15",
                               "Deciduous Broadleaf Forest" = "#D05B25",
                               "Mixed Forest" = "#FBE7D3"), na.value = "grey80")
