# Copyright 2020 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source("header.R")
source('0l_load.R')

#Read in Landform file and mask to ESI area
LForm<-
  raster(file.path('/Users/darkbabine/Dropbox (BVRC)/_dev/Bears/GB_Data/data/Landform',"LForm.tif"))
#mapview(LForm, maxpixels =  271048704)

#LFormFlat[!(LFormFlat[] %in% c(1000,5000,6000,7000,8000))]<-NA

#      ID	Landform	colour
#   1000	 Valley	 #358017
#   2000	 Hilltop in Valley	 #f07f21
#   3000	 Headwaters	 #7dadc3
#   4000	 Ridges and Peaks	 #ebebf1
#   5000	 Plains	 #c9de8d
#   6000	 Local Ridge in Plain	 #f0b88a
#   7000	 Local Valley in Plain	 #4cad25
#   8000	 Gentle Slopes	 #bbbbc0
#   9000	 Steep Slopes	 #8d8d91

LForm_LUT <- data.frame(LFcode = c(1000,2000,3000,4000,5000,6000,7000,8000,9000),
                        Landform = c('Valley','Hilltop in Valley','Headwaters','Ridges and Peaks',
                                     'Plains','Local Ridge in Plain','Local Valley in Plain',
                                     'Gentle Slopes','Steep Slopes'),
                        colourC = c('#358017','#f07f21','#7dadc3','#ebebf1','#c9de8d','#f0b88a',
                                    '#4cad25','#bbbbc0','#8d8d91'))
saveRDS(LForm_LUT, file = 'tmp/LForm_LUT')

LandCover<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','LandCover.tif'))
LandCover_LUT <- read_excel(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/LUT','LandCoverLookUp_LUT.xlsx'),sheet=1)
saveRDS(LandCover, file = 'tmp/LandCover_LUT')

Age<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','Age.tif'))
saveRDS(Age, file = 'tmp/Age')

ws <- get_layer("wsc_drainages", class = "sf") %>%
  select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME) %>%
  filter(SUB_DRAINAGE_AREA_NAME %in% c("Nechako", "Skeena - Coast"))
st_crs(ws)<-3005
saveRDS(ws, file = "tmp/ws")

#Load ESI supporting wetland data
Wet_gdb <-file.path(WetspatialDir,'Wetland_Assessment_Level1_InputData.gdb')
wet_list <- st_layers(Wet_gdb)

#Load ESI Wetlands
WetW_gdb <-file.path(WetspatialDir,'Wetland_T1','Skeena_ESI_T1_Wetland_20191219.gdb')
#wet_list <- st_layers(Wet_gdb)
Wetlands <- readOGR(dsn=WetW_gdb, layer = "Skeena_ESI_T1_Wetland_20191219") %>%
  as('sf')
st_crs(ws)<-3005
saveRDS(Wetlands, file = 'tmp/Wetlands')



