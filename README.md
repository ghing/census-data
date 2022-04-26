# Census Data

Reusable Census data that can be useful to multiple projects.

When possible, this project uses [census-data-downloader](https://github.com/datadesk/census-data-downloader/) and [census-map-downloader](https://github.com/datadesk/census-map-downloader) to download data.

*Created by Geoff Hing)*

*Reporter: Geoff Hing*

## Project goal

Reproducibly create a repository of frequently-used census data.

## Project notes

### Staff involved

- Geoff Hing: Develop and maintain this project

### Data sources

- American Community Survey
  - URL: https://www.census.gov/programs-surveys/acs
  - Agency: U.S. Census Bureau

- Decennial Census Self-Response Rates
  - URL: https://www.census.gov/data/developers/data-sets/decennial-response-rates.2020.html
  - Agency: U.S. Census Bureau

- Equal Employment Opportunity Tabulation
  - URL: https://www.census.gov/topics/employment/equal-employment-opportunity-tabulation.html
  - Agency: U.S. Census Bureau
  - Technical documentation: https://www2.census.gov/EEO_2014_2018/EEO_FTP_Site_Documentation/ACS2014_2018_EEO_FTP_TECHDOC_Version3.0.pdf
  - Reference spreadsheet: https://www2.census.gov/EEO_2014_2018/EEO_FTP_Site_Documentation/EEOTabulation2014-2018-Documentation-1.31.2022.xlsx
    - This contains descriptions of the occupation codes.

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

- Crosswalk between 2020 Census self-response tracts and current tracts
  - URL: https://www2.census.gov/geo/maps/DC2020/SR20/
  - agency: u.s. census bureau
  - [CENSUS 2020 SELF-RESPONSE DATA: QUESTIONS AND ANSWERS](https://www.gc.cuny.edu/Page-Elements/Academics-Research-Centers-Initiatives/Centers-and-Institutes/Center-for-Urban-Research/CUR-research-initiatives/Census-2020/Census-2020-Self-Response-Data-Questions-and-Answers) has some useful notes about this crosswalk

- 2010 Census Tabulation Block to 2020 Census Tabulation Block Relationship Files
  - URL: https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html
  - Agency: U.S. Census Bureau

- 2010 Census Summary File 1
  - URL: https://www.census.gov/data/datasets/2010/dec/summary-file-1.html
  - Agency: U.S. Census Bureau
  - Documentation: https://www2.census.gov/programs-surveys/decennial/2010/technical-documentation/complete-tech-docs/summary-file/sf1.pdf
  - This was really helpful in providing SQL for creating tables: https://sproke.blogspot.com/2012/01/importing-2010-sf1-census-in-postgresql.html
  - I found the [API variable documentation](https://api.census.gov/data/2010/dec/sf1/variables.html), particularly the pages for groups (for example this one for [P3](https://api.census.gov/data/2010/dec/sf1/groups/P3.html)) to be helpful for understanding the variable names.

- Prototype P.L. 94-171 Redistricting Data Summary File
  - URL: https://www.census.gov/programs-surveys/decennial-census/about/rdo/program-management.html#P3
  - Agency: U.S. Census Bureau
  - Documentation: https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf

## Technical

### Assumptions

- Python 3.6+ (I developed this with 3.9)
- Pipenv
- GNU Make
- `ogr2ogr` (for loading data into a SQL database)

### What's in here?

- `Makefile`: Main file used by GNU make to download and process data.
- `census_data.db`: Spatialite database that will be created if you run some of the make commands to load other data into a table.
- `etl`: Extract, transform and load (ETL) scripts.
  - `etl/*.mk`: Makefiles that are included in the top-level `Makefile` to handle specific parts of the ETL pipeline.
  - `etl/sql.mk`: Make rules for loading data into a SQL database. 
- `census_data`: A Python package that includes custom code (including command-line tools) to download and process data that isn't available using the `censusdatadownloader` and `censusmapdownloader` tools.

### Why make?

As Mike Bostock puts it, "Makefiles are machine-readable documentation that make your workflow reproducible."

Makefiles are not the most frequently-discussed concepts for working with data and journalism, but make is available on many platforms and it's more straightforward than other data pipeline tools. Critically, make provides a way to say "build this output only if this previous step has been built" (and will build that previous step if needed. It will also rebuild outputs if an input has been changed/updated.

While the syntax of makefiles and their quirks take some getting used to, the files clearly describe the dependencies between different data sets in a way that would be complex and time-consuming to document.

Other data journalism (or adjacent) resources using `make`:

- [Making Data, the DataMade Way](https://github.com/datamade/data-making-guidelines)
- [Why Use Make](https://bost.ocks.org/mike/make/) (Mike Bostock)

### Project setup instructions

After cloning the git repo, and changing directory to the project directory, install the Python dependencies:

```
pipenv install
```

If you're updating this codebase and want to run the code formatter and linter using git pre-commit hooks, install the development dependencies:

```
pipenv install --dev
```

and set up the git hook scripts:

```
pipenv run pre-commit install
```

### Census data downloader

Most of the heavy lifting is done by the L.A. Times Data Desk's [census-data-downloader](https://github.com/datadesk/census-data-downloader/) tool. When we need to download something that's not supported by this tool, we still try to follow the tool's conventions in terms of file naming and interface to command-line tools.

## Downloading data

Downloading data is handled by make rules.

### American Community Survey

Download racial demographics (technically [Table B03002](https://censusreporter.org/tables/B03002/): Hispanic or Latino Origin by Race) by census tract:

```
make data/processed/acs5_2019_race_tracts.csv
```

and by block group:

```
make data/processed/acs5_2019_race_blockgroups.csv
```

and by ZIP code tabulation area (ZCTA):

```
make data/processed/acs5_2019_race_zctas.csv
```

Download Table B10063: Households With Grandparents Living With Own Grandchildren by Responsibility for Own Grandchildren and Presence of Parent of Grandchildren by ZCTA:

```
make data/processed/acs5_2019_grandparentslivingwithgrandchildren_zctas.csv
```

Download Table B14007: School Enrollment by Detailed Level of School:

```
make data/processed/acs5_2019_school_enrollment_detailed_nationwide.csv
make data/processed/acs5_2019_school_enrollment_detailed_states.csv
make data/processed/acs5_2019_school_enrollment_detailed_counties.csv
make data/processed/acs5_2019_school_enrollment_detailed_places.csv
```

There are also racial iterations of this table that can be downloaded. The racial slugs are `white`, `black`, `american_indian_and_alaska_native`, `asian`, `native_hawaiian_and_pacific_islander_nationwide`, `other`, `two_or_more_races`, `white_nh` and `latino`. For example, to download the iterated table for Black people:

```
make data/processed/acs5_2019_school_enrollment_detailed_black_nationwide.csv
make data/processed/acs5_2019_school_enrollment_detailed_black_states.csv
make data/processed/acs5_2019_school_enrollment_detailed_black_counties.csv
make data/processed/acs5_2019_school_enrollment_detailed_black_places.csv
```

Download Table C24010: Sex by Occupation for the Civilian Population:

```
make data/processed/acs5_2019_occupation_places.csv 
make data/processed/acs5_2019_occupation_counties.csv
make data/processed/acs5_2019_occupation_states.csv
```

Download Table B23025: Employment Status:

```
make data/processed/acs5_2019_employmentstatus_places.csv 
make data/processed/acs5_2019_employmentstatus_counties.csv 
make data/processed/acs5_2019_employmentstatus_states.csv
```

Download Table B16001: Language Spoken at Home by Ability to Speak English

Note that this is only available at the tract level for 2015 (and possibly before).

```
make data/processed/acs5_2015_languagelongform2015_tracts.csv 
```

Download Table C16001: Language Spoken at Home

```
make data/processed/acs5_2019_languageshortform_tracts.csv
```

Download Table C24080: Sex by Class of Worker for the Civilian Population:

```
make data/processed/acs5_2019_classofworker_places.csv 
make data/processed/acs5_2019_classofworker_counties.csv 
make data/processed/acs5_2019_classofworker_states.csv
```

### Equal Employment Opportunity Tabulation

Download table ALL1W: Detailed Census Occupation by Sex and Race/ethnicity for Worksite Geography:

```
make data/processed/eeo_2018_occupation_by_sex_race_for_worksite_geo_nationwide.csv
make data/processed/eeo_2018_occupation_by_sex_race_for_worksite_geo_states.csv
make data/processed/eeo_2018_occupation_by_sex_race_for_worksite_geo_counties.csv
make data/processed/eeo_2018_occupation_by_sex_race_for_worksite_geo_places.csv
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
make data/processed/counties_2020.geojson
```

```
make data/processed/counties_2018.geojson
```

Download metropolitan/micropolitan statistical area (CBSA) boundaries:

```
make data/processed/cbsas_2020.geojson
```

Download tract boundaries:

Tracts are drawn for the decennial census, but you can download tract files for many years in-between. Why is this?

The [TIGER/Line Technical Documentation](https://www2.census.gov/geo/pdfs/maps-data/data/tiger/tgrshp2020/TGRSHP2020_TechDoc_Ch3.pdf) says:

> Current geography may differ from 2010 Census geography due to changes from several sources: in the case of census tracts and block groups, the most common changes are splitting or merging 2010 entities to accommodate population changes in the past decade. Small boundary changes to statistical entities may also follow feature update or align disparate geographic entities for database hygiene. For example, if a street feature that acts as a census tract boundary moves, then the census tract boundary will move as well. In addition, census tract boundaries may change to maintain comparability with related geographies (e.g., incorporated places).

```
make data/processed/tracts_2020.geojson
```

```
make data/processed/tracts_2010.geojson
```

### Population estimates

Download place population estimates:

```
make data/processed/pep_2019_population_places.csv
```

Download county population estimates:

```
make data/processed/pep_2019_population_counties.csv
```

Download state population estimates:

```
make data/processed/pep_2019_population_states.csv
```

### Relationship files

Download [2010 Census Tabulation Block to 2020 Census Tabulation Block Relationship Files](https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html):

```
make data/raw/TAB2010_TAB2020_ST04.zip
```

Note that there is one file per state.

### Decennial census self-response rates

```
make data/processed/responserate_2020_population_tracts.csv
```

```
make data/processed/responserate_2010_population_tracts.csv
```

### 2010 Census Summary File 1 (SF1)

```
make data/raw/az2010.sf1.zip
```

### Prototype P.L. 94-171 Redistricting Data Summary File

```
make data/raw/ri2018_2020Style.pl.zip 
```

## Loading data into a SQL database

It seems like a common task for this data will be to join data together, whether it's joining multiple ACS tables, or joining ACS table data to boundaries. While it's possible to do this in R or GeoPandas, a SQL database seems like a natural fit for these kinds of operations.

Some of the most common data tables that are downloaded and processed using make rules that use `censusdatadownloader` or `censusmapdownloader` can be loaded into a SQL database using a command like:

```
make data/processed/db_tables/counties_2020
```

See the makefile `etl/sql.mk` for supported data.

I've implemented an experimental feature that includes make rules for loading commonly used data into a Spatialite database. I chose Spatialite because it's supported by QGIS, the [sf R package](https://github.com/r-spatial/sf/blob/master/tests/read.R#L69) and [geopandas](https://geopandas.org/reference/geopandas.read_postgis.html) (tl;dr `read_postgis()` can read from any SQLAlchemy-supported database, not just POSTGIS). More importantly, since SQLite/Spatialite store the entire database in a single file, it's possible for someone with more technical skills to create a database pre-populated with this data and then someone who knows SQL can download a copy and use it. Also, I've found that installing and running SQLite/Spatialite is easier than running PostgreSQL/PostGIS.

However, PostGIS remains the most widely-supported and robust spatial database program so it might make sense to eventually add support for PostGIS, or if we run into limitations with Spatialite, switch entirely to PostGIS.

I also made a command, `createsqliteloadcmd` that is part of this package, that outputs a sample `sqlite-utils` command that loads an ACS CSV into the database and sets the correct types for the columns based on the naming convention. This is useful for creating new makefiles for loading CSVs into the SQL database.

## Data notes

### Useful references

- [Census Regions and Divisions of the United States](https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf)
- [Hierarchy Diagrams](https://www.census.gov/programs-surveys/geography/guidance/hierarchy.html)
  - ["The spine"](https://www2.census.gov/geo/pdfs/reference/geodiagram.pdf)

### Suppression of ACS tables for smaller geographies

Some tables, such as [B16001](https://censusreporter.org/tables/B16001/) aren't available for smaller geographies such as ZCTAs or tracts. However, some tables' data at those geographies [may have been available in the past](https://www.census.gov/programs-surveys/acs/technical-documentation/user-notes/2017-02.html). For example, table B16001 is available at the tract level in the 2015 5-year estimates. h/t Ryan Pitts for this information.

Joe Germuska also told me, "more generally, Census specifically disclaims certain geography classes (summary levels) for certain tables, but only documents it in Excel files." You can find an example of these Excel files in the [technical documentation for the 2019 ACS products](https://www2.census.gov/programs-surveys/acs/summary_file/2019/documentation/tech_docs/).
