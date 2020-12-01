# Census Data

Reusable Census data that can be useful to multiple projects.

*Created by Geoff Hing (<ghing@apmreports.org>)*

*Reporter: Geoff Hing (<ghing@apmreports.org>)*

## Project goal

Reproducibly create a repository of frequently-used census data.

## Project notes

### Staff involved

*TK: List people & contact info for people involved in the project*

[Responsibility matrix](url-to-responsibility matrix)

[HIRUFF Q&A](url-to-hiruff)

### Data sources

- Census Gazeteer Files
  - URL: https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html
  - Agency: U.S. Census Bureau
  - The U.S. Gazetteer Files provide a listing of all geographic areas for selected geographic area types. The files include geographic identifier codes, names, area measurements, and representative latitude and longitude coordinates. The representative coordinates are an "internal point" that, unlike a centroid, is gauranteed to be inside the geometry.

## Technical

*TK: Instructions on how to bootstrap project, run ETL processes, etc.*

### Assumptions

- [datadesk/census-data-downloader](https://github.com/datadesk/census-data-downloader/)

### Project setup instructions

After cloning the git repo:

`datakit data pull` to rerieve the data files.

Open `census-data.Rproj` in RStudio.

*TK: For more complex or unusual projects additional directions follow*

## Data notes

*Add important caveats, limitations, and source contact info here.*
