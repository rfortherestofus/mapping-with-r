library("tidyverse")
library("readxl")
library("janitor")
library("tidygeocoder")
library("sf")
library("mapview")

international_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "International Addresses") %>% 
  clean_names()

international_addresses <- international_addresses %>% 
  mutate(across(address_line_1:country, ~str_replace_na(., ""))) %>% 
  mutate(full_street_address = paste(address_line_1, address_line_2, address_line_3, sep = ", "))

international_addresses <- international_addresses %>% 
  geocode(street = full_street_address,
          city = city, 
          # region = region,
          postalcode = postal_code,
          country = country,
          method = "iq")


international_addresses %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326) %>% 
  mapview()
