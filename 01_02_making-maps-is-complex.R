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
library("albersusa")
library("rayshader")
library("threejs")
library("politicaldata")
library("ggtext")
library("janitor")
countries_sf <- countries110 %>%
  st_as_sf()

theme_cjh_map <- function(){
  theme_void() +
  theme(panel.background = element_rect(fill = "#98d7ef"), panel.border = element_blank())
}

gg_save_nicely <- function(gg_plot, file_name, width = 10, units = "in"){
  
  gg_internals <- ggplot_build(gg_plot)
  
  x_range <- diff(gg_internals$layout$panel_params[[1]]$x_range)
  y_range <- diff(gg_internals$layout$panel_params[[1]]$y_range)
  
  aspect_ratio <- x_range / y_range
  
  ggsave(file_name,
         gg_plot,
         width = width,
         height = width / aspect_ratio,
         units = units)
  
}


## ----eval=TRUE, include=FALSE---------------------------------------------------------------------------------------------------------------------------------
## This code was used to generate the ggplot2 charts that were then shoved
## into PowerPoint and set at the background image
gg_web_mercator <- countries_sf %>%
  ggplot() +
  geom_sf(fill = "#D2B48C") +
  coord_sf(crs = 3857, expand = FALSE) +
  theme_cjh_map()

gg_robinson <- countries_sf %>%
  ggplot() +
  geom_sf(fill = "#D2B48C") +
  coord_sf(crs = "+proj=robin") +
  theme_cjh_map()

gg_pall_peters <- countries_sf %>%
  ggplot() +
  geom_sf(fill = "#D2B48C") +
  coord_sf(crs = "+proj=cea", expand = FALSE) +
  theme_cjh_map()

# gg_web_mercator %>%
#   gg_save_nicely("images/gg_web_mercator.png")
# 
# gg_robinson %>%
#   gg_save_nicely("images/gg_robinson.png")
# 
# gg_pall_peters %>%
#   gg_save_nicely("images/gg_pall_peters.png")


## ---- eval=TRUE, echo=FALSE, out.width="400px"----------------------------------------------------------------------------------------------------------------

earth <- "http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73909/world.topo.bathy.200412.3x5400x2700.jpg"
globejs(img=earth, 
        atmosphere = TRUE,
        bg = "white",
        width = "400px",
        height = "400px")


## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------------------------------------------------------------------------------
gg_robinson / gg_web_mercator


## -------------------------------------------------------------------------------------------------------------------------------------------------------------
quakes %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  mapview()


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
leaflet() %>%
  addProviderTiles(providers$HERE.satelliteDay)


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
countries_sf %>%
  filter(!name == "Antarctica") %>%
  leaflet() %>%
  addPolygons(fillColor = "white",
              weight = 1,
              fillOpacity = 1,
              color = "black") %>%
  setMapWidgetStyle(list(background= "lightblue"))


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
leaflet() %>%
  addProviderTiles(providers$HERE.satelliteDay)


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
leaflet() %>%
  addProviderTiles(providers$Esri.WorldShadedRelief) %>%
  addMarkers(86.925278, 27.988056, label = "Mount Everest") %>%
  setView(86.925278, 27.988056, zoom = 10)


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
countries_sf %>%
  filter(!name == "Antarctica") %>%
  leaflet() %>%
  addPolygons(fillColor = "white",
              weight = 1,
              fillOpacity = 1,
              color = "black") %>%
  setMapWidgetStyle(list(background= "lightblue"))


## ---- eval=TRUE, echo=FALSE,out.height="200px", out.width="300px"---------------------------------------------------------------------------------------------
leaflet() %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  # addMarkers(31.233333, 30.033333, label = "Samosir") %>%
  setView(31.233333, 30.033333, zoom = 12)


## ---- eval=TRUE, echo=FALSE, out.width="350px"----------------------------------------------------------------------------------------------------------------
countries_sf %>%
  filter(name == "United States") %>%
  ggplot() +
  geom_sf() +
  theme_cjh_map()


## ---- eval=TRUE, echo=FALSE, out.width="350px"----------------------------------------------------------------------------------------------------------------
usa_sf() %>%
  st_union() %>%
  ggplot() +
  geom_sf() +
  theme_cjh_map()


## ---- eval=TRUE, echo = FALSE---------------------------------------------------------------------------------------------------------------------------------
pres_2016 <- pres_results %>%
  filter(year == 2016) %>%
  mutate(winner = if_else(dem > rep, "Democrat", "Republican"))

usa_sf <- usa_sf()
pres_2016_sf <- usa_sf %>%
  left_join(pres_2016,
            by = c("iso_3166_2" = "state"))

ggplot() +
  geom_sf(data = pres_2016_sf,
          aes(fill = winner)) +
  scale_fill_manual(values = c("Democrat" = "#516DA9",
                               "Republican" = "#FF4A49")) +
  theme_void(base_size = 16) +
  labs(title = "States won by <span style='color:#516DA9'>**Hillary Clinton**</span> and <span style='color:#FF4A49'>**Donald Trump**</span> 
       in the 2016 Presidential race") +
  theme(plot.title = element_textbox_simple()) +
  guides(fill = guide_none())


## ---- eval=TRUE, echo=FALSE, fig.dim=c(5, 6.5)----------------------------------------------------------------------------------------------------------------
uk_authority_shp <- read_sf("data/local-authority-shapefiles")

referendum_votes <- read_csv("https://data.london.gov.uk/download/eu-referendum-results/52dccf67-a2ab-4f43-a6ba-894aaeef169e/EU-referendum-result-data.csv") 
referendum_votes <- clean_names(referendum_votes)

referendum_votes <- referendum_votes %>%
  select(area_code, area, electorate, votes_cast, valid_votes, pct_remain, pct_leave)


referendum_votes <- referendum_votes %>%
  mutate(result = case_when(pct_remain > pct_leave ~ "Remain",
                            pct_remain < pct_leave ~ "Leave"))

brexit_by_authority <- uk_authority_shp %>%
  dplyr::inner_join(referendum_votes,
                    by = c("lad17cd" = "area_code")) %>%
  select(area, electorate, result, votes_cast, valid_votes, pct_remain, pct_leave, everything())


brexit_by_authority %>%
  ggplot() +
  geom_sf(aes(fill = result),
          colour = "white",
          lwd = 0.1) +
  scale_fill_manual(values = c("Leave" = "#005ea7", "Remain" = "#ffb632")) +
  theme_void(base_size = 16) +
  labs(title = "Constituencies that voted <span style='color:#005ea7'>**Leave**</span> and <span style='color:#ffb632'>**Remain**</span> in the 2016 Brexit Referendum") +
  theme(plot.title = element_textbox_simple(minwidth = unit(5, "in"),
                                            maxwidth = unit(8, "in"))) +
  guides(fill = guide_none())


## ---- eval=TRUE, echo=FALSE-----------------------------------------------------------------------------------------------------------------------------------
quakes_sf <- quakes %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  mutate(mag = as.numeric(mag)) %>%
  arrange(mag)

pal <- colorNumeric("PRGn", quakes_sf$mag)

label_earthquake <- function(mag, stations){
  paste(
    mag, "on the Richter scale",
    "<br>",
    "Measured by", stations, "stations"
  )
}

quakes_sf %>%
  leaflet() %>%
  addProviderTiles(providers$Esri.OceanBasemap) %>%
  addCircleMarkers(
    fillColor = ~pal(mag),
    # clusterOptions = markerClusterOptions(),
                   radius = ~scales::rescale(mag, c(5, 30)),
    stroke = TRUE,
    weight = 1,
    color = "black",
    fillOpacity = ~scales::rescale(mag, c(0.7, 0.3)),
    popup = ~label_earthquake(mag, stations)
    ) %>%
  addLegend(pal = pal,
            values = ~mag,
            title = "Earthquake magnitude",
            position = "bottomleft")


## ----eval=FALSE, include=FALSE, echo=FALSE, message=FALSE, warning=FALSE--------------------------------------------------------------------------------------
## montereybay %>%
##   sphere_shade(texture="desert") %>%
##   plot_3d(montereybay,zscale=50)
## render_snapshot("images/rayshader-montereybay.png")

