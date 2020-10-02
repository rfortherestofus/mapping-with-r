library("tidyverse")
library("tmaptools")
library("sf")
library("mapview")
library("readxl")
library("janitor")

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses")
uk_addresses <- clean_names(uk_addresses)

uk_addresses %>%
  mutate(address_query = paste(business_name, street, city, post_code, country, sep = " ")) %>%
  select(address_query, everything()) 

uk_addresses <- uk_addresses %>%
  mutate(across(everything(), ~str_replace_na(.x, ""))) %>%
  mutate(address_query = paste(business_name, street, city, post_code, country, sep = " ")) %>%
  select(address_query, everything()) 

uk_addresses

uk_geocoded <- geocode_OSM(uk_addresses$address_query, as.sf = TRUE)

uk_geocoded %>%
  right_join(uk_addresses,
            by = c("query" = "address_query")) %>%
  st_set_geometry("bbox") %>%
  mapview()




uk_addresses %>%
  mutate(across(everything(), ~str_replace_na(.x, ""))) %>%
  mutate(address_query = paste(business_name, street, city, post_code, country, sep = " ")) %>%
  select(address_query, everything()) %>%
  add_coords(address_query) %>%
  st_set_geometry("point") %>%
  mapview()



# ========= international addresses =================

international_addresses <- read_excel("data/street-addresses.xlsx",
                                      sheet = "International Addresses") %>%
  clean_names()

international_addresses <- international_addresses %>%
  mutate(across(everything(), ~str_replace_na(.x, ""))) %>%
  mutate(address_query = paste(address_line_1, address_line_2, address_line_3, 
                               city, region, postal_code, county, country)) %>%
  select(address_query, everything()) 

international_geocoded <- geocode_OSM(international_addresses$address_query, 
                                      as.sf = TRUE)

international_geocoded %>%
  right_join(uk_addresses,
             by = c("query" = "address_query")) %>%
  st_set_geometry("bbox") %>%
  mapview()



international_addresses %>%
  mutate(across(everything(), ~str_replace_na(.x, ""))) %>%
  mutate(address_query = paste(address_line_1,
                               address_line_2,
                               address_line_3,
                               city,
                               region,
                               postal_code,
                               county,
                               country, sep = " ")) %>%
  select(address_query, everything()) %>%
  add_coords(address_query) %>%
  st_set_geometry("point") %>%
  mapview()
