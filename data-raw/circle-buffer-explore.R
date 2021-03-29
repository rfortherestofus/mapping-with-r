library("tidyverse")
library("sf")
library("mapview")

## Create an sf object storing the location of London with EPSG:4326
london <- tibble(lng = -0.1, lat = 51.5) %>% 
  st_as_sf(coords = c("lng", "lat"), crs = 4326)

circle_buffer <- function(point,
                          crs_for_buffer,
                          distance){
  point %>% 
    st_transform(crs_for_buffer) %>% 
    st_buffer(dist = distance) %>% 
    mutate(label = paste("Geographic projection -", crs_for_buffer))
}

## Compute a circle of width 100e3/111320 in EPSG:4326
## This is a rough approximation of the distance between longitudes.
london_circle_crs_4326 <- london %>% 
  circle_buffer(crs_for_buffer = 4326,
                distance = 100e3/111320)

## Compute a circle of width 100e3 in EPSG:32637
london_circle_crs_27700 <- london %>% 
  circle_buffer(crs_for_buffer = 27700,
                distance = 100e3)

## Compute a circle of width 100e3 in EPSG:3857
london_circle_crs_3857 <- london %>% 
  circle_buffer(crs_for_buffer = 3857,
                distance = 100e3)

london_circle_crs_3857 <- london %>% 
  circle_buffer(crs_for_buffer = 3857,
                distance = 100e3)

london_circle_crs_23030 <- london %>% 
  circle_buffer(crs_for_buffer = 23030,
                distance = 100e3)

london_circle_crs_albers <- london %>% 
  circle_buffer(crs_for_buffer = "+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m no_defs",
                distance = 100e3)

## Calculating the area of the circles WITHIN the projected CRS 
## approximates pi * 100e3 which makes sense.
london_areas_in_projected_crs <- map(list(london_circle_crs_4326, london_circle_crs_27700, london_circle_crs_3857, london_circle_crs_23030, london_circle_crs_albers), ~list(label = .x$label, area_in_projected_crs = st_area(.x))) %>%
  bind_rows()
london_areas_in_projected_crs

## Reprojecting to 4326 and calculating the area shows that only CRS 27700 
## retains an accurate area estimate.
london_areas_in_4326 <- map(list(london_circle_crs_4326, london_circle_crs_27700, london_circle_crs_3857, london_circle_crs_23030, london_circle_crs_albers), ~list(label = .x$label, area_in_4326 = st_area(st_transform(.x, 4326)))) %>%
  bind_rows()
london_areas_in_4326

## Reprojected to 4326 to visualise and as expected the 4326 buffer is an 
## ellipse, whereas the projected CRS are circles!
## But... they are wildly different in size, as seen in the visualisation.
## Only the circle with 27700 is an accurate size.
map(list(london_circle_crs_27700, london_circle_crs_4326, london_circle_crs_3857, london_circle_crs_23030, london_circle_crs_albers), ~st_transform(.x, 4326)) %>% 
  bind_rows() %>% 
  mutate(label = fct_recode(label, "Albers" = "Geographic projection - +proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m no_defs",
                             "Geographic projection 23030",
                             "Geographic projection 27700",
                             "Geogprahic projection 3857",
                             "Geographic projection 4326")) %>% 
  ggplot() +
  geom_sf(aes(fill = label),
          alpha = .5) +
  scale_fill_manual(labels = list("Albers" = "+proj=aea +lat_1=43 +lat_2=62 +lat_0=30 +lon_0=10 +x_0=0 +y_0=0 +ellps=intl +units=m no_defs",
                        "Geographic projectioon 23030",
                        "Geographic projection 27700",
                        "Geogprahic projection 3857",
                        "Geographic projection 4326"))

# ==== I can do the same for Morocco as it lies within +/- 6 degrees ====
# ==== of the central meridian ==========================================

casablanca <- tibble(lng = -7.583333, lat = 33.533333) %>% 
  st_as_sf(coords = c("lng", "lat"), crs = 4326)

casablanca_circle_crs_4326 <- casablanca %>% 
  circle_buffer(crs_for_buffer = 4326,
                distance = 100e3/111320)

# https://epsg.io/4261
casablanca_circle_crs_4261 <- casablanca %>% 
  circle_buffer(crs_for_buffer = 4261,
                distance = 100e3)

# https://epsg.io/26192
casablanca_circle_crs_26192 <- casablanca %>% 
  circle_buffer(crs_for_buffer = 26192,
                distance = 100e3)

# https://epsg.io/32628
casablanca_circle_crs_32628 <- casablanca %>% 
  circle_buffer(crs_for_buffer = 32628,
                distance = 100e3)

## Calculating the area of the circles WITHIN the projected CRS 
## approximates pi * 100e3 which makes sense.
casablance_areas_in_projected_crs <- map(list(casablanca_circle_crs_4326, casablanca_circle_crs_4261, casablanca_circle_crs_26192, casablanca_circle_crs_32628), ~list(label = .x$label, area_in_projected_crs = st_area(.x))) %>%
  bind_rows()
casablance_areas_in_projected_crs
# # A tibble: 4 x 2
# label                         area_in_projected_crs
# <chr>                                         [m^2]
# 1 Geographic projection - 4326            26105526836
# 2 Geographic projection - 4261                    NaN
# 3 Geographic projection - 26192           31401573746
# 4 Geographic projection - 32628           31401573746

## Reprojecting to 4326 and calculating the area shows that only CRS 27700 
## retains an accurate area estimate.
casablanca_areas_in_4326 <- map(list(casablanca_circle_crs_4326, casablanca_circle_crs_4261, casablanca_circle_crs_26192, casablanca_circle_crs_32628), ~list(label = .x$label, area_in_4326 = st_area(st_transform(.x, 4326)))) %>%
  bind_rows()
casablanca_areas_in_4326
# # A tibble: 4 x 2
# label                         area_in_4326
# <chr>                                [m^2]
# 1 Geographic projection - 4326   26105526836
# 2 Geographic projection - 4261             0
# 3 Geographic projection - 26192  31281626623
# 4 Geographic projection - 32628  31059327783

## Removed casablanca_circle_crs_4261 as has NA area
## eprojected to 4326 to visualise and as expected the 4326 buffer is an 
## ellipse, whereas the projected CRS are circles!
## But... they are wildly different in size, as seen in the visualisation.
## Only the circle with 27700 is an accurate size.
mapview(map(list(casablanca_circle_crs_4326, casablanca_circle_crs_26192, casablanca_circle_crs_32628), ~st_transform(.x, 4326)))

map(list(casablanca_circle_crs_4326, casablanca_circle_crs_26192, casablanca_circle_crs_32628), ~st_transform(.x, 4326)) %>% 
  bind_rows() %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons(fillColor = ~label)


# ==== Let's try the white house ==============================================

white_house <- tibble(lng = -77.0365, lat = 38.8977) %>% 
  st_as_sf(coords = c("lng", "lat"), crs = 4326)

white_house_circle_crs_4326 <- white_house %>% 
  circle_buffer(crs_for_buffer = 4326,
                distance = 100e3/111320)

white_house_circle_crs_4269_NAD83 <- white_house %>% 
  circle_buffer(crs_for_buffer = 4269,
                distance = 100e3)

white_house_circle_crs_3857 <- white_house %>% 
  circle_buffer(crs_for_buffer = 3857,
                distance = 100e3)

white_house_circle_crs_2163 <- white_house %>% 
  circle_buffer(crs_for_buffer = 2163,
                distance = 100e3)

white_house_circle_crs_4267 <- white_house %>% 
  circle_buffer(crs_for_buffer = 4267,
                distance = 100e3)


white_house_circle_crs_north_america_albers_conic <- white_house %>% 
  circle_buffer(crs_for_buffer = "+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80",
                distance = 100e3)

## Calculating the area of the circles WITHIN the projected CRS 
## approximates pi * 100e3 which makes sense.
white_house_areas_in_projected_crs <- map(list(white_house_circle_crs_4326, white_house_circle_crs_4269_NAD83, white_house_circle_crs_3857, white_house_circle_crs_2163, white_house_circle_crs_4267, white_house_circle_crs_north_america_albers_conic), ~list(label = .x$label, area_in_projected_crs = st_area(.x))) %>%
  bind_rows()
white_house_areas_in_projected_crs

# ========== 

egypt_centre <- countries110 %>% 
  st_as_sf() %>% 
  filter(name == "Egypt") %>% 
  st_transform(crs = "+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs") %>% 
  st_centroid()

egypt_circle_africa_albers_conic <- egypt_centre %>% 
  circle_buffer(crs_for_buffer = "+proj=aea +lat_1=20 +lat_2=-23 +lat_0=0 +lon_0=25 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs",
                distance = 100e3)

egypt_circle_africa_albers_conic %>% 
  st_area()




