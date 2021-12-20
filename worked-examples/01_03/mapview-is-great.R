library(rnaturalearthdata)
# remotes::install_github("hrbrmstr/albersusa")
library(albersusa)
library(sf)
library(raster)
library(mapview)

alaska_landcover <- raster("data/alaska_landcover.img")
