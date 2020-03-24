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

#Read layers generated from 03_analysis_BECoverlap.R
BEC1970z<-raster(file.path(spatialOutDir,paste("BEC1970z.tif",sep="")))
BEC2080z<-raster(file.path(spatialOutDir,paste("BEC2080z.tif",sep="")))

#mapview(BEC1970z,maxpixels =  4308570)+mapview(BEC2080z,maxpixels =  4308570)
#Identify where BEC zones are the identical between 2080 and 1970
BECOverz <- BEC2080z==BEC1970z
cellStats(BECOverz,sum)
writeRaster(BECOverz, filename=file.path(spatialOutDir,paste("BECOverz",sep="")), format="GTiff",overwrite=TRUE)

#Identify where BEC sub zones are the identical between 2080 and 1970
BECOversz <- BEC2080sz==BEC1970sz
cellStats(BECOversz,sum)
writeRaster(BECOversz, filename=file.path(spatialOutDir,paste("BECOversz",sep="")), format="GTiff",overwrite=TRUE)

#Identify where BEC groups are the identical between 2080 and 1970
BECOverg <- BEC2080g==BEC1970g
cellStats(BECOverg,sum)
writeRaster(BECOverg, filename=file.path(spatialOutDir,paste("BECOverg",sep="")), format="GTiff",overwrite=TRUE)

#Identify where BEC sub-zone variants are the identical between 2080 and 1970
BECOverv <- BEC2080v==BEC1970v
cellStats(BECOversz,sum)
writeRaster(BECOverv, filename=file.path(spatialOutDir,paste("BECOverv",sep="")), format="GTiff",overwrite=TRUE)


