library(tidyverse)
library(readxl)
library(janitor)
library(tidygeocoder)
library(sf)
library(mapview)

international_addresses <- read_excel("data/street-addresses.xlsx",
                                      sheet = "International Addresses") %>% 
  clean_names()