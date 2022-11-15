# read csv
# add new column
#merge with shapefile


library(sf)
library(here)
library(terra)
library(countrycode)
library(dplyr)
library(tidyverse)
library(janitor)

#read the data

    GlobalGender <- read.csv(here:here("Data", "HDR21-22_Composite_indices_complete_time_series.csv"))
                       
  
    
#read shapefile
    
    
 Worldmap <- st_read("Data/World_Countries_(Generalized)/World_Countries__Generalized_.shp")


#Create a new columns with the difference

 GlobalGender2<- GlobalGender %>%
   clean_names()%>%
   select(iso3, country, gii_2019, gii_2010)%>%
   mutate(diff=gii_2019-gii_2010)
    
#merge the shapefile
    
    
    
    
#Plot the map
