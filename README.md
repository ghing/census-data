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

- Census Gazeteer Files
  - URL: https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html
  - Agency: U.S. Census Bureau
  - The U.S. Gazetteer Files provide a listing of all geographic areas for selected geographic area types. The files include geographic identifier codes, names, area measurements, and representative latitude and longitude coordinates. The representative coordinates are an "internal point" that, unlike a centroid, is gauranteed to be inside the geometry.

- Population Estimates
  - URL: https://www.census.gov/data/developers/data-sets/popest-popproj/popest.html
  - See `~/workspace/apm_reports/covid-19-public-health/covid19_public_health/census.py`

- American Community Survey

## Technical

### Assumptions

- Python 3.6+ (I developed this with 3.9)
- Pipenv
- [datadesk/census-data-downloader](https://github.com/datadesk/census-data-downloader/)
- GNU Make

### Project setup instructions

After cloning the git repo, and changing directory to the project directory, install the Python dependencies:

```
pipenv install
```

## Data notes

*Add important caveats, limitations, and source contact info here.*
