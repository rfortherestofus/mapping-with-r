## ----child = "setup.Rmd"--------------------------------------------------------------------------------------------------------------------------------------

## ----setup, include=FALSE-------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(eval = FALSE, 
                      warning = FALSE,
                      message = FALSE,
                      rows.print = 5)



## ---- include=FALSE, eval=TRUE--------------------------------------------------------------------------------------------------------------------------------
library("sf")
library("tidyverse")
library("rnaturalearthdata")
library("mapview")
library("patchwork")
library("leaflet")
library("leaflet.extras")
library("readxl")
library("janitor")
library("stars")

journeys_to_sf <- function(journeys_data,
                           start_long = start.long,
                           start_lat = start.lat,
                           end_long = end.long,
                           end_lat = end.lat) {
  quo_start_long <- enquo(start_long)
  quo_start_lat <- enquo(start_lat)
  quo_end_long <- enquo(end_long)
  quo_end_lat <- enquo(end_lat)

  journeys_data %>%
    select(
      !! quo_start_long,
      !! quo_start_lat,
      !! quo_end_long,
      !! quo_end_lat
    ) %>%
    transpose() %>%
    map(~ matrix(flatten_dbl(.), nrow = 2, byrow = TRUE)) %>%
    map(st_linestring) %>%
    st_sfc(crs = 4326) %>%
    st_sf(geometry = .) %>%
    bind_cols(journeys_data) %>%
    select(everything(), geometry)
}

air_routes_seat_kms <- read_excel("data/air-routes.xlsx",
                                    sheet = "seat-kilometers") %>%
  clean_names()

air_routes_seat_kms <- air_routes_seat_kms %>%
  mutate(across(contains("long"), ~as.numeric(str_trim(.x))))



## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------------------------------------------------------------------------------
sf_lines_air_routes_seat_kms <- air_routes_seat_kms %>%
  filter(rank <= 5) %>%
  journeys_to_sf(airport_1_long,
                 airport_1_lat,
                 airport_2_long,
                 airport_2_lat) %>%
  st_segmentize(units::set_units(400, km)) %>%
  st_wrap_dateline(options = c("WRAPDATELINE=YES", "DATELINEOFFSET=180"))


part_1 <- air_routes_seat_kms %>%
  filter(rank <= 5) %>%
  select(starts_with("airport_1")) %>%
  rename_with(~str_remove(.x, "airport_1_"))

part_2 <- air_routes_seat_kms %>%
  filter(rank <= 5) %>%
  select(starts_with("airport_2")) %>%
  rename_with(~str_remove(.x, "airport_2_"))

sf_points_air_routes_seat_kms <- part_1 %>%
  bind_rows(part_2) %>%
  unique() %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326)

library("htmltools")
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 28px;
  }
"))

title <- tags$div(
  tag.map.title, HTML("Top 5 busiest passenger routes in 2015<br>(by total seat kilometres)")
) 

countries_sf <- countries110 %>%
  st_as_sf()

leaflet() %>%
  # addProviderTiles(providers$Esri.WorldStreetMap) %>%
  addPolygons(data = countries_sf %>%
                filter(!name == "Antarctica"),
              fillOpacity = 1,
              fillColor = "tan",
              weight = 1,
              color = "black") %>%
  addPolylines(data = sf_lines_air_routes_seat_kms,
               weight = 2,
               color = "black") %>%
  addCircleMarkers(data = sf_points_air_routes_seat_kms,
                   fillColor = "black",
                   stroke = FALSE,
                   fillOpacity = 1,
                   radius = 5,
                   popup = ~airport) %>%
  # addControl(title, position = "topleft", className="map-title") %>%
  setMapWidgetStyle(list(background= "lightblue"))


## ---- eval=TRUE, echo=FALSE, df_print="default"---------------------------------------------------------------------------------------------------------------

countries_tib <- countries_sf %>%
  st_drop_geometry() %>%
  as_tibble()

st_geometry(countries_tib) <- countries_sf$geometry

countries_tib %>%
  select(name, continent)


## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------------------------------------------------------------------------------
satellite_image <- system.file("tif/L7_ETMs.tif", package = "stars")
satellite_image %>%
  read_stars() %>%
  mapview()


## -------------------------------------------------------------------------------------------------------------------------------------------------------------
library("albersusa")
library("mapview")
library("tidyverse")

