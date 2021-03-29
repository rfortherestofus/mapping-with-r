library("tidyverse")
library("sf")
library("tidycensus")
library("mapview")
library("tigris")

us_cd_20m <- read_sf("data/us-congressional-districts")

vars_census_2010 <- load_variables(2010, dataset = "sf1")

vars_census_2010 %>%
  View()


vars_census_2010 %>%
  filter(name == "P001001")

get_decennial(geography = "state", variables = "P001001", geometry = TRUE) %>%
  mapview()


vars_census_2010 %>% 
  filter(concept == "TOTAL POPULATION")

tenure_vars <- vars_census_2010 %>% 
  filter(concept == "TENURE",
         label != "Total")

tenure_cd_census_2010 <- get_decennial(geography = "congressional district", 
                                       variables = , 
                                       year = 2010)

tenure_cd_census_2010 <- get_decennial(geography = "congressional district", variables = c("H004002", "H004003", "H004004"), year = 2010)

tenure_cd_census_2010 <- tenure_cd_census_2010 %>%
  pivot_wider(names_from = variable,
              values_from = value) %>%
  rename(mortgage_or_loan = H004002,
         owned_outright = H004003,
         rented = H004004) %>%
  mutate(rented_percent = rented / {mortgage_or_loan + owned_outright + rented})

us_cd_sf %>%
  left_join(tenure_cd_census_2010,
            by = "GEOID") %>%
  filter(!STATEFP %in% c("02", "72", "15")) %>%
  mapview(zcol = "rented_percent")



age_vars <- vars_census_2010 %>%
  filter(str_detect(label, "Total!!Renter occupied!!Householder "),
         concept == "TENURE BY AGE OF HOUSEHOLDER")

age_cd_census_2010 <- get_decennial(geography = "congressional district", variables = c("H017013", "H017014", "H017015", "H017016", "H017017", "H017018", 
                                                                                            "H017019", "H017020", "H017021"), 
                                           year = 2010)

age_cd_census_2010 <- age_cd_census_2010 %>%
  pivot_wider(names_from = variable) %>%
  rename(age_15_to_24 = H017013,
         age_25_to_34 = H017014,
         age_35_to_44 = H017015,
         age_45_to_54 = H017016,
         age_55_to_59 = H017017,
         age_60_to_64 = H017018,
         age_65_to_74 = H017019,
         age_75_to_85 = H017020,
         age_85_plus = H017021)

us_cd_sf %>%
  left_join(age_cd_census_2010,
            by = "GEOID") %>%
  mapview(zcol = "age_85_plus")









