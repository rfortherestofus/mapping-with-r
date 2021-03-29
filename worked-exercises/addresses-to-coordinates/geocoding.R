library("tidyverse")
library("readxl")
library("janitor")
library("tidygeocoder")
library("sf")
library("mapview")

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses") %>%
  clean_names()


