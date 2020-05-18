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
AOI.spatial<-SalmS
Overlap<-0.20

#Subset out only those LUs with >overlap% of their area in AOI - % set in run_all script
# Code modified from here https://rpubs.com/rural_gis/255550
AOI.int <- as_tibble(st_intersection(AOI.spatial,EcoSection))
#add in an area count column to the tibble -
AOI.int$areaArable <- as.single(st_area(AOI.int$geometry))/1000000
AOI.intcomp<-AOI.int %>%
  mutate(areaOverlap=round(areaArable,0)) %>%
  mutate(EcoArea=round(EcoArea,0)) %>%
  mutate(diff=round(areaOverlap/EcoArea*100),0) %>%
  mutate(keepEco=diff>Overlap*100) %>%
  dplyr::select(EcoID, Ecosection,areaOverlap,EcoArea,diff,keepEco)

#Mege those Ecosection that are below the 'Overlap'
SmallEco<-AOI.intcomp %>%
  dplyr::filter(keepEco=='FALSE')

SmallEcoS<-SmallEco$Ecosection
#Visually identifiy largest neighbour

SmallLUT<-data.frame(Ecosection=SmallEco$Ecosection,
                     ToEco=c('Southern Skeena Mountains',#Manson Plateau
                             'Bulkley Basin',#Nazko Upland
                             'Eastern Skeena Mountains', #Northern Omineca Mountains
                             'Eastern Skeena Mountains', #Southern Boreal Plateau
                             'Eastern Skeena Mountains')) #Southern Omineca Mountains

EcoSectionS<-EcoSection %>%
  #st_drop_geometry() %>%
  left_join(SmallLUT) %>%
  mutate(Ecos=ifelse((is.na(ToEco)),Ecosection, ToEco)) %>%
  group_by(Ecos) %>%
  dplyr::summarize(EcoAr=sum(EcoArea, na.rm=TRUE)) %>%
  dplyr::select(Ecosection=Ecos, EcoArea=EcoAr)
EcoSectionS$EcoID <- seq(1, nrow(EcoSectionS))

#mapview(EcoSectionS)
gc()
