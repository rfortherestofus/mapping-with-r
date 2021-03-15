library("raster")
library("tidyverse")
library("mapview")

landsat7_data <- raster("data/L7_ETMS.tif")

alaska_landcover <- raster("data/alaska_landcover.img")

alaska_landcover %>% 
  mapview()

unique(values(alaska_landcover))

landuse_codes <- read_csv("data/landuse-codes.csv")

## ==== reclassify values in RasterLayer ====

original_landuse_codes <- sort(unique(values(alaska_landcover)))

new_landuse_codes <- landuse_codes %>% 
  arrange(value) %>% 
  filter(value %in% original_landuse_codes) %>% 
  pull(category_code)


recoded_landuse_types <- matrix(
  c(original_landuse_codes, 
    new_landuse_codes), 
  ncol = 2)

alaska_landcover <- reclassify(alaska_landcover, rcl = recoded_landuse_types)

alaska_landcover %>% 
  mapview()

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

