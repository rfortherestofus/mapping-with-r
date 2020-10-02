library("tidyverse")
library("tmaptools")
library("sf")
library("mapview")
library("readxl")
library("janitor")

geocode_OSM(c("10 Downing Street, London", "221B Baker Street, London"), as.sf = TRUE) %>%
  mapview()

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses")
uk_addresses <- clean_names(uk_addresses)

uk_addresses %>%
  mutat

uk_addresses

foo_results <- geocode_OSM(uk_addresses$address, as.sf = TRUE, return.first.only = FALSE)


foo_results %>%
  left_join(uk_addresses,
            by = c("query" = "address"))

add_coords <- function(data, address){
  
  address_enquo <- enquo(address)

  geocode_results <- geocode_OSM(pull(data, !!address_enquo), as.sf = TRUE, details = TRUE)
  
  geocode_results %>%
    left_join(data,
              by = c("query" = quo_name(address_enquo)))
    
}


uk_addresses %>%
  add_coords(address) %>%
  st_set_geometry("bbox") %>%
  mapview()
  
