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


order_age_groups <- c("Still in education",
                      "16 or under",
                      "17-19",
                      "20-23",
                      "24+")

london_education_sf %>% 
  mutate(age_group = fct_relevel(age_group, order_age_groups)) %>% 
  ggplot() +
  geom_sf(aes(fill = value)) +
  scale_fill_viridis_c() +
  facet_wrap(~age_group) +
  theme_void() +
  theme(strip.background = element_rect(fill = "pink"))
