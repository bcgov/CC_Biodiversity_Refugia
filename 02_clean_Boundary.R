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

#Subset data for testing
AOI <- SalmS

EcoSectionIN <- EcoS %>%
  mutate(EcoArea=GEOMETRY_A/1000000) %>%
  st_intersection(AOI) %>%
  mutate(Ecosection=ECOSECTI_1) %>%
  dplyr::select(Ecosection,EcoArea)

#Merge Coastal ecosections:
CoastalEcoS<-data.frame(Ecosection=c("Hecate Lowland","Dixon Entrance","Hecate Strait","North Coast Fjords",
               "Queen Charlotte Sound"))
CoastalES<-EcoSectionIN %>%
  dplyr::filter(Ecosection %in% CoastalEcoS$Ecosection) %>%
  st_union() %>%
  st_as_sf() %>%
  mutate(Ecosection='Coastal')

#mapview(CoastalES)

EcoSection<-EcoSectionIN %>%
  #st_drop_geometry() %>%
  mutate(Ecos=ifelse((Ecosection %in% CoastalEcoS$Ecosection),'Coastal', Ecosection)) %>%
  group_by(Ecos) %>%
  dplyr::summarize(EcoAr=sum(EcoArea, na.rm=TRUE)) %>%
  dplyr::select(Ecosection=Ecos, EcoArea=EcoAr)
EcoSection$EcoID <- seq(1, nrow(EcoSection))

#mapview(EcoSection)

