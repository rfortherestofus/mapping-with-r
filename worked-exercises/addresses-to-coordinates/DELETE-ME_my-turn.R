library("tidyverse")
library("readxl")
library("janitor")
library("tidygeocoder")
library("sf")
library("mapview")

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses") %>% 
  clean_names()

uk_addresses <- uk_addresses %>% 
  mutate(across(business_name:country, ~str_replace_na(., ""))) %>% 
  mutate(full_street_address = paste(business_name, street, sep = ", "))


geo("221B Baker Street, London")

geo("10 Downing Street, London", method = "osm")

geo("Redbrick House, 6 Wilder St", method = "osm")

geo(street = "Redbrick House",
    city = "Bristol",
    country = "UK",
    method = "osm")

uk_addresses <- uk_addresses %>% 
  geocode(street = full_street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")


uk_addresses %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326) %>% 
  mapview()

uk_addresses %>% 
  geocode()



uk_addresses_with_na %>% 
  geocode(street = street,
          city = city,
          postalcode = post_code,
          country = country,
          method = "osm")

geocoded_uk_addresses_without_na <- uk_addresses_without_na %>% 
  mutate(full_street_address = paste(business_name, street)) %>% 
  geocode(street = full_street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")


geocoded_uk_addresses_with_na <- uk_addresses_with_na %>% 
  mutate(full_street_address = paste(business_name, street, sep = ", ")) %>% 
  geocode(street = full_street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

library("leaflet")


leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = geocoded_uk_addresses_with_na,
                   color = "red",
                   popup = ~location_name) %>% 
  addCircleMarkers(data = geocoded_uk_addresses_without_na,
                   color = "black",
                   popup = ~location_name)





