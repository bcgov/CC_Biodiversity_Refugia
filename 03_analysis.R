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

#Compare BEC from 1970 to 2080 - Zone, Sub-Zone and Variant

### Zone
#Compare Zone from 1970 to 2080
#Change rasters to be of Zone instead of default Variant
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,ZONEn)
BEC1970z<- raster::subs(BEC1970, subsBEC)
writeRaster(BEC1970z, filename=file.path(spatialOutDir,paste("BEC1970z",sep="")), format="GTiff",overwrite=TRUE)

subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,ZONEn)
BEC2080z<- raster::subs(BEC2080, subsBEC)
writeRaster(BEC2080z, filename=file.path(spatialOutDir,paste("BEC2080z",sep="")), format="GTiff",overwrite=TRUE)

#Crosstab to see extent of overlap
#create LUT for each year
BEC1970z_LUT<-BEC1970z %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(ZONEn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(ZONEn.1=ZONEn) %>%
  dplyr::summarise(ZONE=first(ZONE)) %>%
  rbind(data.frame(ZONEn.1=NA, ZONE=NA))

BEC2080z_LUT<-BEC2080z %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(ZONEn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(ZONEn.2=ZONEn) %>%
  dplyr::summarise(ZONE=first(ZONE)) %>%
  rbind(data.frame(ZONEn.2=NA, ZONE=NA))

#need to add NA case since many non-analogue between years
BEC1970_2080z<-raster::crosstab(BEC1970z, BEC2080z, long=TRUE, useNA=TRUE) %>%
  left_join(BEC1970z_LUT) %>%
  dplyr::rename(BEC1970=ZONE) %>%
  left_join(BEC2080z_LUT) %>%
  dplyr::rename(BEC2080=ZONE) %>%
  dplyr::select(BEC1970n=ZONEn.1, BEC1970, BEC2080n=ZONEn.2, BEC2080, Freq)

sum(BEC1970_2080z$Freq)

#Find which and the number of overlaps between years
macroRefugiaZ <- BEC1970_2080z %>%
  dplyr::filter_(~as.character(BEC1970) == as.character(BEC2080))
#Calculate % of overlap between 1970 and 2080
sum(macroRefugiaZ$Freq)/sum(BEC1970_2080z$Freq)*100

### Sub-Zone
#Compare Sub=Zone from 1970 to 2080
#Change rasters to be of Sub-Zone
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,SUBZn)
BEC1970sz<- raster::subs(BEC1970, subsBEC)
writeRaster(BEC1970sz, filename=file.path(spatialOutDir,paste("BEC1970sz",sep="")), format="GTiff",overwrite=TRUE)

subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,SUBZn)
BEC2080sz<- raster::subs(BEC2080, subsBEC)
writeRaster(BEC2080sz, filename=file.path(spatialOutDir,paste("BEC2080sz",sep="")), format="GTiff",overwrite=TRUE)

#Crosstab to see extent of overlap
#create LUT for each year
BEC1970sz_LUT<-BEC1970sz %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(SUBZn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(SUBZn.1=SUBZn) %>%
  dplyr::summarise(SUBZ=first(SUBZ)) %>%
  rbind(data.frame(SUBZn.1=NA, SUBZ=NA))

BEC2080sz_LUT<-BEC2080sz %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(SUBZn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(SUBZn.2=SUBZn) %>%
  dplyr::summarise(SUBZ=first(SUBZ)) %>%
  rbind(data.frame(SUBZn.2=NA, SUBZ=NA))

#need to add NA case since many non-analogue between years
BEC1970_2080sz<-raster::crosstab(BEC1970sz, BEC2080sz, long=TRUE, useNA=TRUE) %>%
  left_join(BEC1970sz_LUT) %>%
  dplyr::rename(BEC1970=SUBZ) %>%
  left_join(BEC2080sz_LUT) %>%
  dplyr::rename(BEC2080=SUBZ) %>%
  dplyr::select(BEC1970n=SUBZn.1, BEC1970, BEC2080n=SUBZn.2, BEC2080, Freq)

sum(BEC1970_2080sz$Freq)

#Find which and the number of overlaps between years
macroRefugiaSZ <- BEC1970_2080sz %>%
  dplyr::filter_(~as.character(BEC1970) == as.character(BEC2080))
#Calculate % of overlap between 1970 and 2080
sum(macroRefugiaSZ$Freq)/sum(BEC1970_2080sz$Freq)*100

### Variant
#Compare Variant from 1970 to 2080
#Change rasters to be of Variant
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,VARn)
BEC1970v<- raster::subs(BEC1970, subsBEC)
writeRaster(BEC1970v, filename=file.path(spatialOutDir,paste("BEC1970v",sep="")), format="GTiff",overwrite=TRUE)

subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,VARn)
BEC2080v<- raster::subs(BEC2080, subsBEC)
writeRaster(BEC2080v, filename=file.path(spatialOutDir,paste("BEC2080v",sep="")), format="GTiff",overwrite=TRUE)

#Crosstab to see extent of overlap
#create LUT for each year
BEC1970v_LUT<-BEC1970v %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(VARn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(VARn.1=VARn) %>%
  dplyr::summarise(VAR=first(VAR)) %>%
  rbind(data.frame(VARn.1=NA, VAR=NA))

BEC2080v_LUT<-BEC2080v %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(VARn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(VARn.2=VARn) %>%
  dplyr::summarise(VAR=first(VAR)) %>%
  rbind(data.frame(VARn.2=NA, VAR=NA))

#need to add NA case since many non-analogue between years
BEC1970_2080v<-raster::crosstab(BEC1970v, BEC2080v, long=TRUE, useNA=TRUE) %>%
  left_join(BEC1970v_LUT) %>%
  dplyr::rename(BEC1970=VAR) %>%
  left_join(BEC2080v_LUT) %>%
  dplyr::rename(BEC2080=VAR) %>%
  dplyr::select(BEC1970n=VARn.1, BEC1970, BEC2080n=VARn.2, BEC2080, Freq)

sum(BEC1970_2080v$Freq)

#Find which and the number of overlaps between years
macroRefugiaV <- BEC1970_2080v %>%
  dplyr::filter_(~as.character(BEC1970) == as.character(BEC2080))
#Calculate % of overlap between 1970 and 2080
sum(macroRefugiaV$Freq)/sum(BEC1970_2080v$Freq)*100

### Group
#Compare BEC groups from 1970 to 2080
#Change rasters to be of Groups
subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,Groupn)
BEC1970g<- raster::subs(BEC1970, subsBEC)
writeRaster(BEC1970g, filename=file.path(spatialOutDir,paste("BEC1970g",sep="")), format="GTiff",overwrite=TRUE)

subsBEC<-BEC_LUT[!(is.na(BEC_LUT$ID)),] %>%
  dplyr::select(ID,Groupn)
BEC2080g<- raster::subs(BEC2080, subsBEC)
writeRaster(BEC2080g, filename=file.path(spatialOutDir,paste("BEC2080g",sep="")), format="GTiff",overwrite=TRUE)

#Crosstab to see extent of overlap
#create LUT for each year
BEC1970g_LUT<-BEC1970g %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(Groupn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(Groupn.1=Groupn) %>%
  dplyr::summarise(BECgroup=first(BECgroup)) %>%
  rbind(data.frame(Groupn.1=NA, BECgroup=NA))

BEC2080g_LUT<-BEC2080g %>%
  unique() %>%
  data.frame() %>%
  dplyr::rename(Groupn ='.') %>%
  left_join(BEC_LUT) %>%
  group_by(Groupn.2=Groupn) %>%
  dplyr::summarise(BECgroup=first(BECgroup)) %>%
  rbind(data.frame(Groupn.2=NA, BECgroup=NA))

#need to add NA case since many non-analogue between years
BEC1970_2080g<-raster::crosstab(BEC1970g, BEC2080g, long=TRUE, useNA=TRUE) %>%
  left_join(BEC1970g_LUT) %>%
  dplyr::rename(BEC1970=BECgroup) %>%
  left_join(BEC2080g_LUT) %>%
  dplyr::rename(BEC2080=BECgroup) %>%
  dplyr::select(BEC1970n=Groupn.1, BEC1970, BEC2080n=Groupn.2, BEC2080, Freq)

sum(BEC1970_2080g$Freq)

#Find which and the number of overlaps between years
macroRefugiaG <- BEC1970_2080g %>%
  dplyr::filter_(~as.character(BEC1970) == as.character(BEC2080))
#Calculate % of overlap between 1970 and 2080
sum(macroRefugiaG$Freq)/sum(BEC1970_2080g$Freq)*100

#Output data as a multi-tabbed spreadsheet
XtabSummary<- data.frame(c('Zone','SubZone','Variant','Group'),
                         c(sum(macroRefugiaZ$Freq)/sum(BEC1970_2080z$Freq)*100,
                           sum(macroRefugiaSZ$Freq)/sum(BEC1970_2080sz$Freq)*100,
                           sum(macroRefugiaV$Freq)/sum(BEC1970_2080v$Freq)*100,
                           sum(macroRefugiaG$Freq)/sum(BEC1970_2080g$Freq)*100))
colnames(XtabSummary)<-c('BECscale','pcOverlap')


#mapview(BEC1970z,maxpixels =  4308570)+mapview(BEC2080z,maxpixels =  4308570)

#Write out results into a multi-tab spreadsheet
BECxData<-list(XtabSummary, BEC1970_2080v,macroRefugiaV, BEC1970_2080sz,macroRefugiaSZ, BEC1970_2080z,macroRefugiaZ)
BECDataNames<-c('XtabSummary','VariantXtab','VariantOverlap','SubZoneXtab','SubZoneOverlap','ZoneXtab','ZoneOverlap')

WriteXLS(BECxData,file.path(dataOutDir,paste('BECxData.xlsx',sep='')),SheetNames=BECDataNames)



