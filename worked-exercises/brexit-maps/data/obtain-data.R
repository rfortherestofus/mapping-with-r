library("tidyverse")
library("sf")
library("janitor")
library("leaflet")
library("rmapshaper")
library("readxl")

## ==== Get shapefiles ====
download.file(url = "https://opendata.arcgis.com/datasets/ae90afc385c04d869bc8cf8890bd1bcd_1.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D",
              destfile = "data/original_uk_local_authorities.zip")

unzip(zipfile = "data/original_uk_local_authorities.zip",
      exdir = "data/original_uk_local_authorities")

original_uk_local_authorities <-  read_sf("data/original_uk_local_authorities")

uk_local_authorities <- original_uk_local_authorities %>%
  ms_simplify(keep = 0.05)

dir.create("data/uk_local_authorities")

uk_local_authorities %>%
  filter(str_starts(lad17cd, "E")) %>%
  write_sf("data/uk_local_authorities/local_authorities_england.shp")

uk_local_authorities %>%
  filter(str_starts(lad17cd, "S")) %>%
  write_sf("data/uk_local_authorities/local_authorities_scotland.shp")

uk_local_authorities %>%
  filter(str_starts(lad17cd, "W")) %>%
  write_sf("data/uk_local_authorities/local_authorities_wales.shp")

unlink("data/original_uk_local_authorities.zip")
unlink("data/original_uk_local_authorities/", recursive = TRUE)

## ==== Brexit =====

uk_referendum_votes <- read_csv("https://data.london.gov.uk/download/eu-referendum-results/52dccf67-a2ab-4f43-a6ba-894aaeef169e/EU-referendum-result-data.csv")
uk_referendum_votes <- clean_names(uk_referendum_votes)

uk_referendum_votes <- uk_referendum_votes %>%
  select(area_code, area, votes_cast, remain, leave)

ni_referendum_votes <- read_csv("https://www.opendatani.gov.uk/dataset/9a2f7593-297e-409d-bdac-39ccc172a14e/resource/61cfee40-69f6-444e-bf03-3dd60bd6e1dc/download/eu-referendum-2016-constituency-count-totals.csv")
ni_referendum_votes <- clean_names(ni_referendum_votes)

ni_referendum_votes <- ni_referendum_votes %>%
  filter(!constituency == "TOTAL") %>%
  rename(
    area = constituency,
    votes_cast = number_of_ballot_papers_counted,
    remain = number_of_votes_cast_in_favour_of_remain,
    leave = number_of_votes_cast_in_favour_of_leave
  ) %>%
  select(area, votes_cast, remain, leave)

download.file(url = "https://data.nicva.org/sites/default/files/pc2008_clipped.zip",
              destfile = "data/original_ni_local_authorities.zip")

unzip(zipfile = "data/original_ni_local_authorities.zip",
      exdir = "data/original_ni_local_authorities")


ni_sf <- read_sf("data/original_ni_local_authorities/pc2008/") %>%
  clean_names()

ni_referendum_votes <- ni_sf %>%
  mutate(pc_name = tools::toTitleCase(tolower(pc_name)),
         pc_name = str_replace(pc_name, "and", "&")) %>%
  left_join(ni_referendum_votes,
            by = c("pc_name" = "area")) %>%
  st_drop_geometry() %>%
  select(pc_id:leave) %>%
  rename(area_code = pc_id,
         area = pc_name)

ni_referendum_votes %>%
  bind_rows(uk_referendum_votes) %>%
  write_csv("data/brexit-referendum-results.csv")

unlink("data/original_ni_local_authorities.zip")
unlink("data/original_ni_local_authorities/", recursive = TRUE)

# ## ==== Constituency Population data ====
# 
# download.file("https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fparliamentaryconstituencymidyearpopulationestimates%2fmid2015/sape20dt7mid2015parliconsyoaestimatesunformatted.zip",
#               destfile = "data/original_constituency-population.zip")
# 
# unzip(zipfile = "data/original_constituency-population.zip",
#       exdir = "data/")
# 
# uk_population <- read_excel("SAPE20DT7-mid-2015-parlicon-syoa-estimates-unformatted.xls",
#                             sheet = "Mid-2015 Persons", skip = 3)
# 
# uk_referendum_votes
# 
# uk_population









