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
source('01_load_Footprint.R')

#Prepare linear features for intactness
#Reclassify Age - Age 0-20, 20-50, >50 - each group gets a different weight
recA<-c(0,20,1,20,50,2,50,1000,3)
  AgeClassed<-reclassify(Age, rcl=matrix(recA,ncol=3,byrow=TRUE), right=FALSE, include.lowest=TRUE)

#Set LandCover such that shows forest
  recLY<-c(2018-20,2018,1,2018-50,2018-20,2,1915,2018-50,3)
  LogYearClassed<-reclassify(LogYear, rcl=matrix(recLY,ncol=3,byrow=TRUE), right=FALSE, include.lowest=TRUE)

#Reclass RESULTS roads based on Year Logged
  Rdlt20 <- ((RoadType == 14 & LogYearClassed==1) | RoadType == 18 & LogYearClassed ==1)
  Rdlt50 <- ((RoadType == 14 & LogYearClassed==2) | RoadType == 18 & LogYearClassed ==2)
  Rdgt50 <- ((RoadType == 14 & LogYearClassed==3) | RoadType == 18 & LogYearClassed ==3)

# Generate a seperate raster for each weight
  #1.0 weigt linear features
  RoadType10a <- (RoadType == 1 | RoadType == 2 | RoadType == 3 | RoadType == 9 | RoadType == 10 |
                    RoadType == 11 | RoadType == 16)
#Combine with RESULTS age roads and RailRoads
  T10<- Reduce("+",list(RoadType10a, Rdlt20, RailRoads))
  #Set all to 1
  T10[T10 >= 1]<-1
  writeRaster(T10, filename=file.path(spatialOutDir,paste("T10",sep="")), format="GTiff",overwrite=TRUE)
#Use gridDistance function to create a surface of distance from road in meters
  T10_gd<-gridDistance(T10,origin=1)

#0.5 weigt linear features
  RoadType05a <- (RoadType == 6 | RoadType == 15 | RoadType == 17)
  #Combine with RESULTS age roads
  T05<- Reduce("+",list(RoadType05a, Rdlt50, Pipe, HydroTransmission))
  T05[T05 >= 1]<-1
  writeRaster(T05, filename=file.path(spatialOutDir,paste("T05",sep="")), format="GTiff",overwrite=TRUE)
#Use gridDistance function to create a surface of distance from road in meters
  T05_gd<-gridDistance(T05,origin=1)

#0.1 weigt linear features
     RoadType01a <- (RoadType == 5)
     #Combine with RESULTS age roads
     T01<- Reduce("+",list(RoadType01a, Rdgt50))
     T01[T01 >= 1]<-1
     writeRaster(T01, filename=file.path(spatialOutDir,paste("T01",sep="")), format="GTiff",overwrite=TRUE)
#Use gridDistance function to create a surface of distance from road in meters
     T01_gd<-gridDistance(T01,origin=1)

#Make a vector for reclass weights for linear decline
recl_10<-c(1.0, .50, .25, .125, .0625, .03125, .0156, .0078, .0039, .00195, 0)
recL_10<-c(0,100,recl_10[1],100,200,recl_10[2],200,300,recl_10[3],
                300,400,recl_10[4],400,500,recl_10[5],500,600,recl_10[6],
                 600,700,recl_10[7],700,800,recl_10[8],800,900,recl_10[9],
                 900,1000, recl_10[10],1000,1000000,recl_10[11])
recl_05<-recl_10*0.5
recL_05<-c(0,100,recl_05[1],100,200,recl_05[2],200,300,recl_05[3],
           300,400,recl_05[4],400,500,recl_05[5],500,600,recl_05[6],
           600,700,recl_05[7],700,800,recl_05[8],800,900,recl_05[9],
           900,1000, recl_05[10],1000,1000000,recl_05[11])
recl_01<-recl_10*0.1
recL_01<-c(0,100,recl_01[1],100,200,recl_01[2],200,300,recl_01[3],
           300,400,recl_01[4],400,500,recl_01[5],500,600,recl_01[6],
           600,700,recl_01[7],700,800,recl_01[8],800,900,recl_01[9],
           900,1000, recl_01[10],1000,1000000,recl_01[11])

#Use linear decline matrix and reclassify the linear rasters weighted as 1
LinearDecay10 <-reclassify(T10_gd, rcl=  matrix(recL_10,ncol=3,byrow=TRUE)
                           , right=FALSE, include.lowest=TRUE)
writeRaster(LinearDecay10, filename=file.path(spatialOutDir,paste("LinearDecay10",sep="")), format="GTiff",overwrite=TRUE)

#Use linear decline matrix and reclassify the linear rasters weighted as 0.5
LinearDecay05 <-reclassify(T05_gd, rcl=  matrix(recL_05,ncol=3,byrow=TRUE)
                           , right=FALSE, include.lowest=TRUE)
writeRaster(LinearDecay05, filename=file.path(spatialOutDir,paste("LinearDecay05",sep="")), format="GTiff",overwrite=TRUE)

#Use linear decline matrix and reclassify the linear rasters weighted as 0.1
LinearDecay01 <-reclassify(T01_gd, rcl=  matrix(recL_01,ncol=3,byrow=TRUE)
                           , right=FALSE, include.lowest=TRUE)
writeRaster(LinearDecay01, filename=file.path(spatialOutDir,paste("LinearDecay01",sep="")), format="GTiff",overwrite=TRUE)

#Set Log Year such that shows forest that has been logged
recLY<-c(2018-20,2018,1,2018-50,2018-20,2,1915,2018-50,3)
LogYearClassed<-reclassify(LogYear, rcl=matrix(recLY,ncol=3,byrow=TRUE), right=FALSE, include.lowest=TRUE)
writeRaster(LogYearClassed, filename=file.path(spatialOutDir,paste("LogYearClassed",sep="")), format="GTiff",overwrite=TRUE)

#1 weight area features
HF10 <- (ExtensiveFootprint == -1 | ExtensiveFootprint == -5 |
           ExtensiveFootprint == -6 | ExtensiveFootprint == -7 |
           ExtensiveFootprint == -8 | LogYearClassed == 1)

HF10[HF10 >=1] <-1
writeRaster(HF10, filename=file.path(spatialOutDir,paste("HF10",sep="")), format="GTiff",overwrite=TRUE)

#0.05 weight area features
HF05 <- (ExtensiveFootprint == -2 | ExtensiveFootprint == -3 |
           ExtensiveFootprint == -4 | LogYearClassed == 2)
HF05[HF05 >=1] <-0.5
writeRaster(HF05, filename=file.path(spatialOutDir,paste("HF05",sep="")), format="GTiff",overwrite=TRUE)

#0.01 weight area features
HF01 <- (LogYearClassed ==3)
HF01[HF01 >=1] <-0.1
writeRaster(HF01, filename=file.path(spatialOutDir,paste("HF01",sep="")), format="GTiff",overwrite=TRUE)


