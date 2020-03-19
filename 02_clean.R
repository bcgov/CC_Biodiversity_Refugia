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

#Subset data for testing
AOI <- ws %>%
    filter(SUB_SUB_DRAINAGE_AREA_NAME == "Bulkley")
#AOI <- bc

Age_file <- file.path("tmp/Age")
if (!file.exists(Age_file)) {

Age <- raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','Age.tif')) %>%
    mask(AOI)
saveRDS(Age, file = 'tmp/Age')

ws <- readRDS(file = 'tmp/ws') %>%
  st_intersection(AOI)

LForm<-raster(file.path('/Users/darkbabine/Dropbox (BVRC)/_dev/Bears/GB_Data/data/Landform',"LForm.tif")) %>%
  mask(AOI)
saveRDS(LForm, file = 'tmp/LForm')
LForm_LUT <- readRDS(file= 'tmp/LForm_LUT')

bec_sf <- readRDS(file= 'tmp/bec_sf') %>%
  st_intersection(AOI)
saveRDS(bec_sf, file = 'tmp/bec_sf')

LandCover <- raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','LandCover.tif')) %>%
  mask(AOI)
saveRDS(LandCover, file = 'tmp/LandCover')

LandCover_LUT <- readRDS(file= 'tmp/LandCover_LUT')

ExtensiveFootprint <- raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','ExtensiveFootprint.tif')) %>%
  mask(AOI)
saveRDS(ExtensiveFootprint, file = 'tmp/ExtensiveFootprint')

ExtensiveFootprint_LUT <- readRDS(file= 'tmp/ExtensiveFootprint_LUT')

BEC1970<-readRDS(file= 'tmp/BEC1970PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC1970, file = 'tmp/BEC1970')

BEC2080<-readRDS(file= 'tmp/BEC2080PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC2080, file = 'tmp/BEC2080')
writeRaster(BEC2080, filename=file.path(spatialOutDir,paste("BEC2080",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)


#mapview(BEC2080) + mapview(BEC1970)

BECbrick<-stack(BEC1970,BEC2080)
names(BECbrick) <- c('BEC1970','BEC2080')
saveRDS(BECbrick, file = file.path('tmp/BECbrick'))

} else {
  ws <- readRDS(file = 'tmp/ws')
  bec_sf <- readRDS(file= 'tmp/bec_sf')
  LForm <- readRDS(file = 'tmp/LForm')
  LForm_LUT <- readRDS(file= 'tmp/LForm_LUT')
  LandCover <- readRDS(file= 'tmp/LandCover')
  LandCover_LUT <- readRDS(file= 'tmp/LandCover_LUT')
  ExtensiveFootprint <- readRDS(file= 'tmp/ExtensiveFootprint')
  ExtensiveFootprint_LUT <- readRDS(file= 'tmp/ExtensiveFootprint_LUT')
  Age <- readRDS(file= 'tmp/Age')
  BEC1970 <- readRDS(file= 'tmp/BEC1970')
  BEC2080 <- readRDS(file= 'tmp/BEC2080')
}
