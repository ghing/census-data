# ETL pipeline for various U.S. Census bureau data sets

DATA_DIR := data
DATA_DIR_SRC := $(DATA_DIR)/raw
DATA_DIR_MANUAL := $(DATA_DIR)/manual
DATA_DIR_PROCESSED := $(DATA_DIR)/processed
DATA_DIR_PUBLIC :=  $(DATA_DIR)/public

SHARED_DATA :=

# ACS 5-year

# Table B03002: Hispanic or Latino Origin by Race
$(DATA_DIR_PROCESSED)/acs5_2018_race_tracts.csv: | $(DATA_DIR_PROCESSED)
	censusdatadownloader --data-dir $(DATA_DIR) --year 2018 race tracts

# Boundaries

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) counties

# Tract boundaries

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) tracts

# Gazetteer files

# National Counties Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_counties_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_counties_national.zip

# National County Subdivisions Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_cousubs_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_cousubs_national.zip

# National Places Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_place_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_place_national.zip

# Create directories for data

$(DATA_DIR_SRC):
	mkdir -p $@

$(DATA_DIR_MANUAL):
	mkdir -p $@

$(DATA_DIR_PROCESSED):
	mkdir -p $@

$(DATA_DIR_PUBLIC):
	mkdir -p $@
