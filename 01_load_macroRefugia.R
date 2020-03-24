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
source('01_load.R')

#Provincial BEC 1970 and 2080
#Read in rasters and put into Albers projection and resample to 100m and allign with provincial raster
BEC1970<-raster(file.path(RefugiaSpatialDir, 'BEC_zone_1970/BEC_zone.tif')) %>% #EPSG=4326 - GCS_WGS_1984
  projectRaster(crs=Prov_crs, method='ngb') %>%
  raster::resample(BCr, method='ngb')
#Check raster for size and values
#cellStats((BEC1970PinP3>0),sum)
#unique(BEC1970PinP3)
#mapview(BEC1970PinP3)
saveRDS(BEC1970P,file='tmp/BEC1970P')
#Check raster in Q compare with vector BEC
writeRaster(BEC1970P, filename=file.path(spatialOutDir,paste("BEC1970P",sep="")), format="GTiff",overwrite=TRUE)

#can also use - BEC1970P_LUTs <- levels(BEC1970Pin)
BEC1970P_LUT <- read.dbf(file.path(RefugiaSpatialDir, "BEC_zone_1970/BEC_zone.tif.vat.dbf"),as.is=TRUE)

BEC2080P<-raster(file.path(RefugiaSpatialDir, 'BEC_zone_2080s/BEC_zone_2080s.tif')) %>%
  projectRaster(crs=Prov_crs, method='ngb') %>%
  raster::resample(BCr, method='ngb')

saveRDS(BEC2080P,file='tmp/BEC2080P')
#Check raster for size and values
#cellStats((BEC2080P>0),sum)
#unique(BEC2080P)

BEC2080P_LUT <- read.dbf(file.path(RefugiaSpatialDir, "BEC_zone_2080s/BEC_zone_2080s.tif.vat.dbf"),as.is=TRUE)

#Make new universal LUT since values different in 2 rasters
BEC_LUT1<-BEC1970P_LUT %>%
  full_join(BEC2080P_LUT,by='VAR') %>%
  mutate(ID = 1:n()) %>%
  mutate(VARn = ID) %>%
  transform(SUBZn=as.integer(factor(SUBZ))) %>%
  transform(ZONEn=as.integer(factor(ZONE.x))) %>%
  dplyr::select(ID, V1970 = VALUE.x, V2080 = VALUE.y, ZONEn, ZONE=ZONE.x, SUBZn, SUBZ, VARn, VAR)

#Reclass rasters so values are the same for Variants
subsBEC<-BEC_LUT1[!(is.na(BEC_LUT1$V1970)),] %>%
  dplyr::select(V1970,ID)
BEC1970PS <- raster::subs(BEC1970P, subsBEC)
saveRDS(BEC1970PS,file='tmp/BEC1970PS')
writeRaster(BEC1970PS, filename=file.path(spatialOutDir,paste("BEC1970PS",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

subsBEC<-BEC_LUT1[!(is.na(BEC_LUT1$V2080)),] %>%
  dplyr::select(V2080,ID)
BEC2080PS <- raster::subs(BEC2080P, subsBEC)
saveRDS(BEC2080PS,file='tmp/BEC2080PS')
writeRaster(BEC2080PS, filename=file.path(spatialOutDir,paste("BEC2080PS",sep="")), format="GTiff",overwrite=TRUE, RAT=TRUE)

#Read in BEC grouping spredsheet -BECv11_SubzoneVariant_Groups.xlsx
BECgroupSheets<- excel_sheets(file.path(DataDir,'BECv11_SubzoneVariant_GroupsV2.xlsx'))
BECgroupSheetsIn<-read_excel(file.path(DataDir,'BECv11_SubzoneVariant_GroupsV2.xlsx'),
                             sheet = BECgroupSheets[2])
#Make a data frame for the data
BECGroup_LUT<-data.frame(VARns=BECgroupSheetsIn$`BEC Unit`,
                         BECgroup=BECgroupSheetsIn$GROUP, stringsAsFactors = FALSE)
#Trim whitespace in BEC_LUT bec labels so can match to Group_LUT
BEC_LUT1$VARns<-gsub(" ", "", BEC_LUT1$VAR, fixed = TRUE)
#Join to BEC_LUT
BEC_LUT2<-BEC_LUT1 %>%
  left_join(BECGroup_LUT)
#pull out records with NAs and make excel spreadsheet
BECmissing <- BEC_LUT2[is.na(BEC_LUT2$BECgroup),] %>%
  dplyr::select(ID,ZONE,SUBZ,VAR,BECgroup)
WriteXLS(BECmissing,file.path(dataOutDir,paste('BECmissing.xlsx',sep='')))

#Assign NAs groups to ZONEs
  BEC_LUT2$BECgroup[is.na(BEC_LUT2$BECgroup)] <-
    paste(as.character(BEC_LUT2$ZONE[is.na(BEC_LUT2$BECgroup)]),'_missing',sep='')
BEC_LUT<-BEC_LUT2 %>%
  transform(Groupn=as.integer(factor(BECgroup)))

# Download BEC - # Gets bec_sf zone shape and filters the desired subzones
bec_sf <- bec(class = "sf")# %>%
  #st_intersection(study_area)
saveRDS(bec_sf, file = "tmp/bec_sf")

