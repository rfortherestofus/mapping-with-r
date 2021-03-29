library("tidyverse")
library("readxl")
library("janitor")
library("tidygeocoder")
library("sf")
library("rnaturalearthdata")
library("ggspatial")

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses") %>% 
  clean_names()

uk_addresses <- uk_addresses %>% 
  mutate(across(business_name:country, ~str_replace_na(., ""))) %>% 
  mutate(full_street_address = paste(business_name, street, sep = ", "))

uk_addresses <- uk_addresses %>% 
  geocode(street = full_street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

uk_addresses_sf <- uk_addresses %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

uk_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "United Kingdom") %>% 
  st_transform(4326)

ggplot() +
  geom_sf(data = uk_sf) +
  geom_sf(data = uk_addresses_sf,
          aes(colour = city)) +
  theme_void() +
  guides(colour = guide_legend(override.aes = list(size = 3)))

ggplot() +
  geom_sf(data = uk_sf) +
  geom_sf(data = uk_addresses_sf) +
  facet_wrap(~ city) +
  theme_void() +
  guides(colour = guide_legend(override.aes = list(size = 3)))


ggplot() +
  annotation_map_tile(zoom = 6,
                      type = "hotstyle") +
  geom_sf(data = uk_sf,
          alpha = 0) +
  geom_sf(data = uk_addresses_sf,
          aes(colour = city)) +
  labs(title = "Cities of focus in the UK",
       subtitle = "© OpenStreetMap contributors")


