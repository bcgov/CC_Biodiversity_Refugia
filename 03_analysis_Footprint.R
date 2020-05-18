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
source('02_clean_Footprint.R')

#Combine Linear rasters portion of human footprint selecting max value
LinearDecay<-max(LinearDecay01,LinearDecay05,LinearDecay10)
writeRaster(LinearDecay, filename=file.path(spatialOutDir,paste("intactLayers/LinearDecay",sep="")), format="GTiff",overwrite=TRUE)

#Make Human Foot Print raster - max of 3 area based weight groups
HF <- max(HF01,HF05,HF10, na.rm=TRUE)
writeRaster(HF, filename=file.path(spatialOutDir,paste("intactLayers/HFootprint",sep="")), format="GTiff",overwrite=TRUE)

#Make Human Foot Print raster - max of Human Footprint and Linear Feature surface
HF_LD <- max(HF, LinearDecay, na.rm=TRUE)
writeRaster(HF_LD, filename=file.path(spatialOutDir,paste("intactLayers/HFootprint_LinearDecay",sep="")), format="GTiff",overwrite=TRUE)




