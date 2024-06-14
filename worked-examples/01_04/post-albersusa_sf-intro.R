library(sf)
library(mapview)
library(tidyverse)
library(tigris)

us_states <- states(cb = TRUE, resolution = "20m")

## [[Record introduction to sf]]