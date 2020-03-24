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

source('header.R')
source('01_load_macroRefugia.R')

#Subset data for testing
AOI <- ws %>%
    filter(SUB_SUB_DRAINAGE_AREA_NAME == "Bulkley")
#AOI <- bc
AOI <- BCr

ws <- readRDS(file = 'tmp/ws') %>%
  st_intersection(AOI)

bec_sf <- readRDS(file= 'tmp/bec_sf') %>%
  st_intersection(AOI)
saveRDS(bec_sf, file = 'tmp/bec_sf')

BEC1970<-readRDS(file= 'tmp/BEC1970PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC1970, file = 'tmp/BEC1970')
writeRaster(BEC1970, filename=file.path(spatialOutDir,paste("BEC1970",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

BEC2080<-readRDS(file= 'tmp/BEC2080PS') %>%
  mask(AOI) %>%
  crop(AOI)
saveRDS(BEC2080, file = 'tmp/BEC2080')
writeRaster(BEC2080, filename=file.path(spatialOutDir,paste("BEC2080",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

####Other load stuff
#if(!is.null(subzones)){
#  bec_sf <- dplyr::filter(bec_sf, as.character(MAP_LABEL) %in% subzones)
#  study_area <- st_intersection(study_area, bec_sf) %>% # The AOI is trimmed according to the bec_sf zones included
#    summarise()
#  st_write(study_area, file.path(res_folder, "AOI.gpkg"), delete_layer = TRUE)
#}
