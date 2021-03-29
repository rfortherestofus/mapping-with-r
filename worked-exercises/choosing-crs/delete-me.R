library("tidyverse")
library("sf")
library("mapview")
library("maps")

uk_cities <- world.cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  filter(country.etc == "UK")

uk_countries <- read_sf("data/uk_country_borders")

uk_local_authorities <- read_sf("data/uk_local_authorities")

uk_cities <- uk_cities %>% 
  st_transform(st_crs(uk_local_authorities))


uk_countries %>% 
  mutate(cities_in_country = lengths(st_covers(uk_countries, uk_cities))) %>% 
  mapview(zcol = "cities_in_country")


uk_countries %>% 
  mutate(cities_in_country = lengths(st_covers(uk_countries, uk_cities))) %>% 
  ggplot() +
  geom_sf(aes(fill = cities_in_country)) +
  scale_fill_viridis_b(option = "magma")

uk_local_authorities %>% 
  mutate(cities_in_country = lengths(st_covers(uk_local_authorities, uk_cities))) %>% 
  mapview(zcol = "cities_in_country")


quakes %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()


spaio



## === UTM Area

## convert long lat to UTM
## https://stackoverflow.com/a/14457180/1659890

map_width <- 200
map_height <- 100

utm_x <- function(longitude){
  {longitude + 180} * map_width / 360
}

utm_lat_rad <- function(latitude){
  latitude * pi / 180
}

merc_n <- function(latitude){
  log(tan({pi / 4} + utm_lat_rad(latitude) / 2))
}

utm_y <- function(latitude){
  map_height / 2 - {map_width * merc_n(latitude) / 2 * pi}
}

utm_y(80)

tribble(
  ~long, ~lat,
  36, 60
) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  st_transform(crs = "+proj=tmerc")

library("rnaturalearthdata")

countries_sf <- countries110 %>% 
  st_as_sf()

countries_sf %>% 
  filter(name == "Madagascar") %>% 
  st_transform(crs = "+proj=tmerc")

st_graticule(crs = "+proj=tmerc")

ggplot() +
  geom_sf(data = st_graticule(crs = "+proj=tmerc")) +
  geom_sf(data = countries_sf) +
  coord_sf(crs = "+proj=tmerc",
           ylim = c(-40E5, 84E5),
           xlim = c(-1936321, 1936321),
           expand = TRUE)



spain_sf <- raster::getData(country = "ESP", level = 1)



# ==== SPAIN

spain_sf <- raster::getData(country = "ESP", level = 1, download = TRUE) %>% 
  st_as_sf() %>% 
  select(NAME_1)

spain_sf <- spain_sf %>% 
  st_transform("+proj=utm +zone=29 +ellps=intl +towgs84=-87,-98,-121,0,0,0,0 +units=m +no_defs ")

spain_cities <- world.cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  filter(country.etc == "Spain") %>% 
  st_transform(st_crs(spain_sf))

spain_sf %>% 
  mutate(cities_in_region = lengths(st_covers(spain_sf, spain_cities))) %>% 
  mapview(zcol = "cities_in_region")




