
<a id="devex-badge" rel="Exploration" href="https://github.com/BCDevExchange/assets/blob/master/README.md"><img alt="Being designed and built, but in the lab. May change, disappear, or be buggy." style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/exploration.svg" title="Being designed and built, but in the lab. May change, disappear, or be buggy." /></a>
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# CC\_Biodiversity\_Refugia

This repository presents 2 analysis; 1) generates a macro refugia
layering using BEC 1970 and BEC 2080 identifying equivalent areas; and
2) Intactness classifying human area and linear disturbance, ranking
them according to their severity. A third Enduring Features is in
development.

### Data

For the macro refugia analysis current and 2080 modelled BEC were used -
from: Wang, Tongli, Elizabeth M. Campbell, Gregory A. O’Neill, and Sally
N. Aitken. 2012. “Projecting Future Distributions of Ecosystem Climate
Niches: Uncertainties and Management Applications.” Forest Ecology and
Management 279 (September): 128–40.
<https://doi.org/10.1016/j.foreco.2012.05.034>.
(<https://cfcg.forestry.ubc.ca/projects/climate-data/climatebcwna/>)

For Intactness the analysis uses the Skeena East Environmental
Stewardship Initiative (ESI) Area as a case-study. Previoulsy compiled
Forest Age, Logging Year, Human Footprint, railroads, pipelines, hydro
transmission corridors and road type where used. Methods are available
on request.

### Usage

There are 3 sets core scripts that are required for analysis, each set
(macroRefugia, Footprint, EnduringFeatures) needs to be run in order:

  - 01\_load.R
  - 01\_load\_macroRefugia.R
  - 01\_load\_Footprint.R
  - 01\_load\_EnduringFeatures.R
  - 02\_clean\_macroRefugia.R
  - 02\_clean\_Footprint.R
  - 02\_clean\_EnduringFeatures.R
  - 03\_analysis\_BECoverlap.R
  - 03\_analysis\_Footprint.R
  - 04\_output\_macroRefugia.R

### Project Status

This project is part of Climate Change and Biodiversity assessment being
led by the Ministry of Environment and Climate Change Strategy’s
Ecosystem Branch. The analysis is exploratory and will be added to and
updated over the coming months.

### Getting Help or Reporting an Issues

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/CC_Biodiversity_Refugia/issues/).

### How to Contribute

If you would like to contribute, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2020 Province of British Columbia
    
    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

This repository is maintained by
[ENVEcosystems](https://github.com/orgs/bcgov/teams/envecosystems/members).
