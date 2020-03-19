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

# bring in BC boundary
bc <- bcmaps::bc_bound()
Prov_crs<-crs(bc)
#Prov_crs<-"+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"

#Provincial BEC 1970 and 2080
BEC1970P<-raster(file.path(RefugiaSpatialDir, 'BEC_zone_1970/BEC_zone.tif')) %>%
  projectRaster(crs=Prov_crs, method='ngb')
saveRDS(BEC1970P,file='tmp/BEC1970P')
#Check raster in Q compare with vector BEC
writeRaster(BEC1970P, filename=file.path(spatialOutDir,paste("BEC1970P",sep="")), format="GTiff",overwrite=TRUE)

BEC1970P_LUT <- read.dbf(file.path(RefugiaSpatialDir, "BEC_zone_1970/BEC_zone.tif.vat.dbf"),as.is=TRUE)

BEC2080P<-raster(file.path(RefugiaSpatialDir, 'BEC_zone_2080s/BEC_zone_2080s.tif')) %>%
  projectRaster(crs=Prov_crs, method='ngb')
saveRDS(BEC2080P,file='tmp/BEC2080P')

BEC2080P_LUT <- read.dbf(file.path(RefugiaSpatialDir, "BEC_zone_2080s/BEC_zone_2080s.tif.vat.dbf"),as.is=TRUE)

#Make new universal LUT since values different in 2 rasters
BEC_LUT<-BEC1970P_LUT %>%
  full_join(BEC2080P_LUT,by='VAR') %>%
  mutate(ID = 1:n()) %>%
  mutate(VARn = ID) %>%
  transform(SUBZn=as.integer(factor(SUBZ))) %>%
  transform(ZONEn=as.integer(factor(ZONE.x))) %>%
  dplyr::select(ID, V1970 = VALUE.x, V2080 = VALUE.y, ZONEn, ZONE=ZONE.x, SUBZn, SUBZ, VARn, VAR)

#Reclass rasters so values are the same for Variants
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$V1970)),] %>%
  dplyr::select(V1970,ID)
BEC1970PS <- raster::subs(BEC1970P, subsBEC)
saveRDS(BEC1970PS,file='tmp/BEC1970PS')
writeRaster(BEC1970PS, filename=file.path(spatialOutDir,paste("BEC1970PS",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

subsBEC<-BEC_LUT[!(is.na(BEC_LUT$V2080)),] %>%
  dplyr::select(V2080,ID)
BEC2080PS <- raster::subs(BEC2080P, subsBEC)
saveRDS(BEC2080PS,file='tmp/BEC2080PS')
writeRaster(BEC2080PS, filename=file.path(spatialOutDir,paste("BEC2080PS",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

#Read in BEC grouping spredsheet -BECv11_SubzoneVariant_Groups.xlsx
BECgroupSheets<- excel_sheets(file.path(DataDir,'BECv11_SubzoneVariant_Groups.xlsx'))
BECgroupSheetsIn<-read_excel(file.path(DataDir,'BECv11_SubzoneVariant_Groups.xlsx'),
                             sheet = BECgroupSheets[2])
#Make a data frame for the data
BECGroup_LUT<-data.frame(VARns=BECgroupSheetsIn$`BEC Unit`,
                         BECgroup=BECgroupSheetsIn$GROUP, stringsAsFactors = FALSE)
#Trim whitespace in BEC_LUT bec labels so can match to Group_LUT
BEC_LUT$VARns<-gsub(" ", "", BEC_LUT$VAR, fixed = TRUE)
#Join to BEC_LUT
BEC_LUT<-BEC_LUT %>%
  left_join(BECGroup_LUT)
#Assign NAs groups to ZONEs
  BEC_LUT$BECgroup[is.na(BEC_LUT$BECgroup)] <-
    paste(as.character(BEC_LUT$ZONE[is.na(BEC_LUT$BECgroup)]),'_missing',sep='')
BEC_LUT<-BEC_LUT %>%
  transform(Groupn=as.integer(factor(BECgroup)))


# Download BEC - # Gets bec_sf zone shape and filters the desired subzones
bec_sf <- bec(class = "sf")# %>%
  #st_intersection(study_area)
saveRDS(bec_sf, file = "tmp/bec_sf")

ws <- get_layer("wsc_drainages", class = "sf") %>%
  select(SUB_DRAINAGE_AREA_NAME, SUB_SUB_DRAINAGE_AREA_NAME) %>%
  filter(SUB_DRAINAGE_AREA_NAME %in% c("Nechako", "Skeena - Coast"))
st_crs(ws)<-3005
saveRDS(ws, file = "tmp/ws")

#Read in Landform file and mask to ESI area
LForm<-
  #raster(file.path('../GB_Data/data/Landform',"Landform_BCAlbs.tif")) %>%
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

ExtensiveFootprint<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','ExtensiveFootprint.tif'))
saveRDS(ExtensiveFootprint, file = 'tmp/ExtensiveFootprint')

ExtensiveFootprint_LUT <- read_csv(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/LUT','ExtensiveFootprintStatsTableRows.csv'))
saveRDS(ExtensiveFootprint_LUT, file = 'tmp/ExtensiveFootprint_LUT')

#Other load stuff
if(!is.null(subzones)){
  bec_sf <- dplyr::filter(bec_sf, as.character(MAP_LABEL) %in% subzones)
  study_area <- st_intersection(study_area, bec_sf) %>% # The AOI is trimmed according to the bec_sf zones included
    summarise()
  st_write(study_area, file.path(res_folder, "AOI.gpkg"), delete_layer = TRUE)

#ESI boundary - for testing, etc.
ESI_file <- file.path("tmp/ESI")
if (!file.exists(ESI_file)) {
  #Load ESI boundary
  ESIin <- read_sf(file.path(ESIDir,'Data/Skeena_ESI_Boundary'), layer = "ESI_Skeena_Study_Area_Nov2017") %>%
    st_transform(3005)
  ESI <- st_cast(ESIin, "MULTIPOLYGON")
  saveRDS(ESI, file = ESI_file)
} else
  ESI<-readRDS(file = ESI_file)

study_area <- ESI


