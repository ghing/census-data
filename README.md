# Census Data

Reusable Census data that can be useful to multiple projects.

*Created by Geoff Hing (<ghing@apmreports.org>)*

*Reporter: Geoff Hing (<ghing@apmreports.org>)*

## Project goal

Reproducibly create a repository of frequently-used census data.

## Project notes

### Staff involved

- Geoff Hing <ghing@apmreports.org>: Develop and maintain this project

### Data sources

- American Community Survey
  - URL: https://www.census.gov/programs-surveys/acs
  - Agency: U.S. Census Bureau

- Gazeteer Files
  - URL: https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html
  - Agency: U.S. Census Bureau
  - The U.S. Gazetteer Files provide a listing of all geographic areas for selected geographic area types. The files include geographic identifier codes, names, area measurements, and representative latitude and longitude coordinates. The representative coordinates are an "internal point" that, unlike a centroid, is gauranteed to be inside the geometry.

- Population Estimates
  - URL: https://www.census.gov/data/developers/data-sets/popest-popproj/popest.html
  - Agency: U.S. Census Bureau

- TIGER/Line Shapefiles
  - URL: https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html
  - Agency: U.S. Census Bureau

## Technical

### Assumptions

- Python 3.6+ (I developed this with 3.9)
- Pipenv
- [datadesk/census-data-downloader](https://github.com/datadesk/census-data-downloader/)
- [datadesk/census-map-downloader](https://github.com/datadesk/census-map-downloader)
- GNU Make

### Project setup instructions

After cloning the git repo, and changing directory to the project directory, install the Python dependencies:

```
pipenv install
```

### Census data downloader

Most of the heavy lifting is done by the L.A. Times Data Desk's [census-data-downloader](https://github.com/datadesk/census-data-downloader/) tool. When we need to download something that's not supported by this tool, we still try to follow the tool's conventions in terms of file naming and interface to command-line tools.


## Downloading data

Downloading data is handled by make rules.

### American Community Survey

Download racial demographics (technically [Table B03002](https://censusreporter.org/tables/B03002/): Hispanic or Latino Origin by Race) by census tract:

```
make data/processed/acs5_2018_race_tracts.csv
```

and by block group:

```
make data/processed/acs5_2018_race_blockgroups.csv
```

Download Table B10063: Households With Grandparents Living With Own Grandchildren by Responsibility for Own Grandchildren and Presence of Parent of Grandchildren by ZCTA:

```
make data/processed/acs5_2019_grandparentslivingwithgrandchildren_zctas.csv
```

### Gazeteer files

Download county gazeteer files:

```
make data/raw/2019_Gaz_counties_national.zip
```

Download county subdivision gazeteer files:

```
make data/raw/2019_Gaz_cousubs_national.zip
```

Download census places gazeteer files:

```
make data/raw/2019_Gaz_place_national.zip
```

### Geography boundaries

Download county boundaries:

```
make data/processed/counties_2018.geojson
```

Download tract boundaries:

```
make data/processed/tracts_2010.geojson
```

### Population estimates

Download county population estimates:

```
make data/processed/pep_2019_population_counties.csv
```

Download state population estimates:

```
make data/processed/pep_2019_population_states.csv
```

## Data notes

*Add important caveats, limitations, and source contact info here.*
