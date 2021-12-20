library(sf)
library(tidyverse)

london_sf <- read_sf("data/london_boroughs")

education_data <- read_csv("data/age-when-completed-education.csv")

london_education_sf <- london_sf %>% 
  left_join(education_data,
            by = c("lad11nm" = "area")) %>% 
  group_by(lad11nm) %>% 
  mutate(value = value / sum(value)) 

# ==== data viz ====