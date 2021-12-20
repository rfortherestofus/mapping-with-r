library(sf)
library(mapview)
library(leaflet)
library(tidyverse)

london_sf <- read_sf("data/london_boroughs")

education_data <- read_csv("data/age-when-completed-education.csv")

london_school_leavers_sf <- london_sf %>% 
  left_join(education_data,
            by = c("lad11nm" = "area")) %>% 
  filter(age_group == "16 or under")

popup_borough_summary <- function(borough, school_leavers){
  
  pmap(list(borough, school_leavers), function(borough, school_leavers){
    
    if(is.na(school_leavers)){
      
      paste("No data was collected for", borough)
      
    } else {
      
      format_school_leavers <- scales::number(school_leavers, big.mark = ",")
      
      paste(
        "In <b>", borough, "</b>" , format_school_leavers, "of residents left school at 16 or under"
      )
      
    }
    
  })
  
}


# ==== Dataviz ====




# ==== NA position fix ====

css_fix <- "div.info.legend.leaflet-control br {clear: both;}" # CSS to correct spacing
html_fix <- htmltools::tags$style(type = "text/css", css_fix) 

lf_london_school_leavers %>% 
  htmlwidgets::prependContent(html_fix)








