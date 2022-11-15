
# Read the packages

library(tidyverse)
library(sf)
library(here)
library(janitor)
library(countrycode)
library(tmap)

#Read CSV

    GenderData <- read_csv(here("Data", "HDR21-22_Composite_indices_complete_time_series.csv"),
                         locale = locale(encoding = "latin1"),
                         na = " ", skip = 0)
    
# Read shapefile
    
    World <- st_read("Data/World_Countries_(Generalized)/World_Countries__Generalized_.shp")

    
#Select Columns
    
    GenderData2 <- GenderData %>%
      clean_names() %>%
      select(iso3, country, gii_2010, gii_2019) %>%
      mutate(differ=gii_2019 - gii_2010) %>%
      mutate(iso_code=countrycode(country, origin = 'country.name', destination = 'iso2c'))
    
#Join data
    
    Finaldata <- World %>%
    clean_names() %>%
      left_join(.,
                GenderData2,
                by = c("iso" = "iso_code"))
  
#plot the map
    
    tmap_mode("plot")
    Finaldata %>%
      qtm(.,fill = "differ")
    
      