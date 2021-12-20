library(readxl)
library(janitor)
library(tidygeocoder)
library(sf)
library(mapview)
library(rnaturalearthdata)
library(tidyverse)

uk_addresses <- read_excel("data/street-addresses.xlsx",
                                      sheet = "UK Addresses") %>% 
  clean_names()

uk_addresses_geocoded <- uk_addresses %>% 
  geocode(street = street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

uk_addresses_sf <- uk_addresses_geocoded %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

uk_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "United Kingdom")


