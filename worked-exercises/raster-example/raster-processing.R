library("raster")
library("tidyverse")
library("mapview")




landuse_codes <- read_csv("data/landuse-codes.csv")

## ==== reclassify values in RasterLayer ====

recoded_landuse_types <- matrix(
  c(original_landuse_codes, 
    new_landuse_codes), 
  ncol = 2)


## ==== ggplot2 of reclassified landcover ====

library("ggspatial")

ggplot() +
  layer_spatial(
    alaska_landcover,
    aes(fill = as_factor(stat(band1)))
  ) +
  scale_fill_manual(
    values = c(
      "0" = "steelblue3",
      "1" = "forestgreen",
      "2" = "lightgreen",
      "3" = "yellow",
      "4" = "brown",
      "5" = "purple"
    ),
    labels = c(
      "0" = "Water",
      "1" = "Forest / Woodland",
      "2" = "Grassland / Shrubland",
      "3" = "Crop",
      "4" = "Bare ground",
      "5" = "Urban"
    ),
    na.translate = FALSE,
    name = "Land use category"
  ) +
  theme_void()
