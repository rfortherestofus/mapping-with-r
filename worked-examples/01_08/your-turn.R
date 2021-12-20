library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(countrycode)
library(gapminder)

gapminder_2007 <- gapminder %>% 
  filter(year == 2007)

countries_sf <- countries110 %>%
  st_as_sf()