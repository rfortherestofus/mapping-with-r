library("raster")
library("tidyverse")
library("sf")
library("mapview")
library("ggspatial")

## ==== reclassify Alaska landuse ====

alaska_landcover <- raster("data/alaska_landcover.img")

landuse_codes <- read_csv("data/landuse-codes.csv")


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

## ==== crop to Achorage ====


alaska_sf <- read_sf("data/shapefiles_alaksa")

anchorage <- alaska_sf %>% 
  filter(NAME_2 == "Anchorage")

cropped_anchorage <- crop(alaska_landcover, anchorage)

mask_anchorage <- rasterize(anchorage, cropped_anchorage)

anchorage_landuse <- mask(cropped_anchorage, mask_anchorage)

anchorage_landuse %>%  mapview()

crop_raster_to_sf <- function(raster, sf){
  cropped_raster <- crop(raster, sf)
  
  mask_raster <- rasterize(sf, cropped_raster)
  
  mask(cropped_raster, mask_raster)
}

crop_raster_to_sf(alaska_landcover, anchorage) %>% 
  mapview()


## ==== ggplot2 of reclassified landcover ====

ggplot() +
  layer_spatial(
    anchorage_landuse,
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
