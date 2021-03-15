# library("raster")
library("tidyverse")
library("stars")
library("lubridate")
library("glue")
library("furrr")
library("rgeoboundaries")

## ==== setup data acquisition ====

daily_weather_tib <- tibble(
  date = seq(as_date("2015/01/01"), as_date("2015/01/31"), "day")) %>% 
  mutate(year = year(date),
         formatted_date = as.character(date),
         formatted_date = str_replace_all(formatted_date, "-", "")) %>% 
  mutate(daily_rain = "daily_rain",
         min_temp = "min_temp",
         max_temp = "max_temp") %>% 
  pivot_longer(daily_rain:max_temp,
               names_to = "variable") %>% 
  select(-value)

daily_weather_tib <- daily_weather_tib %>% 
  mutate(data_url = glue("https://s3-ap-southeast-2.amazonaws.com/silo-open-data/daily/{variable}/{year}/{formatted_date}.{variable}.tif"))

dir.create("data/silo_australia_daily_weather")

daily_weather_tib <- daily_weather_tib %>% 
  mutate(data_file = file.path("data/silo_australia_daily_weather", glue("{date}_{variable}.tif")))

## guarantee dates in order

daily_weather_tib <- daily_weather_tib %>% 
  arrange(date)

## limit to max_temp only for simple example dataset

daily_weather_tib <- daily_weather_tib %>%
  filter(variable == "max_temp")

## ==== download files in parallel ====

plan(multisession)

daily_weather_tib %>% 
  select(data_url, data_file) %>% 
  future_pwalk(~download.file(.x, .y))

## ==== read in files ====

australia_daily_max_temp_2015_jan <- daily_weather_tib %>% 
  filter(variable == "max_temp") %>% 
  select(data_file) %>% 
  map(~read_stars(.x)) %>% 
  reduce(c)

australia_daily_max_temp_2015_jan <- australia_daily_max_temp_2015_jan %>% 
  st_redimension() %>% 
  st_set_dimensions(3, values = daily_weather_tib$date, name = "time")

names(australia_daily_max_temp_2015_jan) <- "max_temp"

## ==== export and tidy up ====

australia_daily_max_temp_2015_jan %>% 
  write_stars("data/australia_daily_max_temp_2015_jan.tif")

unlink("data/silo_australia_daily_weather", recursive = TRUE)

daily_weather_tib %>% 
  select(date) %>% 
  distinct() %>% 
  mutate(band_index = row_number()) %>% 
  select(band_index, date) %>% 
  write_csv("data/band-details_australia_daily_max_temp_2015_jan.csv")

## ==== Alaska Data ====

australia_regions <- gb_adm1("AUS")

australia_regions %>% 
  write_sf("data/australia-shapefiles/australia.shp")


