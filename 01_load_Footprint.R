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

ExtensiveFootprint<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','ExtensiveFootprint.tif'))
saveRDS(ExtensiveFootprint, file = 'tmp/ExtensiveFootprint')

ExtensiveFootprint_LUT <- read_csv(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/LUT','ExtensiveFootprintStatsTableRows.csv'))
saveRDS(ExtensiveFootprint_LUT, file = 'tmp/ExtensiveFootprint_LUT')

#ESI.Human.Footprint.Indices.2.xlsx
Footprint_LUT <- read_excel(file.path(DataDir,'ESI.Human.Footprint.Indices.3.xlsx'),sheet=3)

colName<-Footprint_LUT[1,] %>%
  mutate_all(funs(gsub("[[:punct:]]", "", .))) %>%
  mutate_all(funs(gsub(" ", "_", .)))  %>%
  mutate_all(funs(gsub("__", "_", .)))  %>%
  mutate_all(funs(gsub("___", "_", .)))  %>%
  unlist()

colnames(Footprint_LUT)<-colName
Footprint_LUT<-Footprint_LUT[2:32,]

Human_LUT<-data.frame(Human_Footprint = Footprint_LUT$Human_Footprint) %>%
  left_join(ExtensiveFootprint_LUT)

#Raster roads
RoadType<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','roadType.tif'))
saveRDS(RoadType, file = 'tmp/roadType')

RoadType_LUT <- read_csv(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/LUT','RoadType_LUT.csv'))
saveRDS(RoadType_LUT, file = 'tmp/RoadType_LUT')

#Raster rail
RailRoads<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','RailRoads.tif'))
saveRDS(RailRoads, file = 'tmp/RailRoads')

#Raster pipeline
Pipe<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','Pipe_PrinceRupertGasTransmissionLtd.tif'))
saveRDS(Pipe, file = 'tmp/Pipe')

#Raster HydroTransmission
HydroTransmission<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','HydroTransmission.tif'))
saveRDS(HydroTransmission, file = 'tmp/HydroTransmission')

#Land Cover
LandCover<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','LandCover.tif'))
LandCover_LUT <- read_excel(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/LUT','LandCoverLookUp_LUT.xlsx'),sheet=1)
saveRDS(LandCover, file = 'tmp/LandCover_LUT')

#Forest Age
Age<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','Age.tif'))
saveRDS(Age, file = 'tmp/Age')

#Year of logging
LogYear<-
  raster(file.path(ESIDir,'Data/DataScience/SkeenaESI_LandCover_Age_Human_Footprint/OutRaster','LogYear.tif'))

