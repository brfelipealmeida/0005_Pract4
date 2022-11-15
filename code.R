#New Project with Git Hub
## new changes
### new changes git
ddjijidjidj
jdijdijdijdijdiidj


Oi
oi2
#Existing code up to here

#ZPE Code from here

#Importing libaries 
library(tidyverse)
library(here)
library(sf)
library(countrycode)
library(tmap)

#Identifying the local path in which the data is located
csv_path <- "../../../Week 4/uss_gis_hw/data/HDR21-22_Composite_indices_complete_time_series.csv"
shp_path <- "../../../Week 4/uss_gis_hw/data/World_Countries_(Generalized)/World_Countries__Generalized_.shp"

#Reading in the csv file
df <- read_csv(here(csv_path), na = " ")

#Identfiying the columns to be used in analysis
df1 <- df %>%
  select(c("iso3", "country", "hdi_2010", "hdi_2019"))

#Calcualting the difference between 2010 and 2019
df2 <- df1 %>%
  mutate("difference"= hdi_2019 - hdi_2010)

#Reading in the shapefile
shape <- read_sf(shp_path)

#Convert country codes to be in same format using countrycode package
#Documentation: https://www.rdocumentation.org/packages/countrycode/versions/1.4.0/topics/countrycode
df3 <- df2 %>%
  mutate(iso2 = countrycode(`iso3`, "iso3c", "iso2c"))

#Merging the shapefile and the csv together
df_m <- shape %>%
  left_join(., 
            df3,
            by = c("ISO" = "iso2"))



#Setting the mapping mode to plotting (allowing for future export)
tmap_mode("plot")

#Starting a new bbox to allow more visually appealing map
bbox_new <- st_bbox(df_m) # current bounding box

xrange <- bbox_new$xmax - bbox_new$xmin # range of x values
yrange <- bbox_new$ymax - bbox_new$ymin # range of y values

# bbox_new[1] <- bbox_new[1] - (0.25 * xrange) # xmin - left
bbox_new[3] <- bbox_new[3] + (0.25 * xrange) # xmax - right
# bbox_new[2] <- bbox_new[2] - (0.25 * yrange) # ymin - bottom
bbox_new[4] <- bbox_new[4] + (1.52 * yrange) # ymax - top

bbox_new <- bbox_new %>%  # take the bounding box ...
  st_as_sfc() # ... and make it a sf polygon


#Assigning the map to a varibale of x (to save it next)
x <- tm_shape(df_m, bbox = bbox_new) + 
  tm_polygons("difference", 
              style="jenks",
              n=5,
              palette="RdYlGn",
              midpoint=0,
              title="Difference",
              alpha = 0.5) + 
  tm_layout(title = "Difference in Gender Inequality\n (2010 to 2019)",
            title.position = c('right', 'top')) +
  tm_view(view.legend.position = c("left", "center"))

#Saving the map to files.
tmap_save(tm=x, filename = "figures/Difference_map.pdf", dpi=300)



