# ETL pipeline for various U.S. Census bureau data sets

DATA_DIR := data
DATA_DIR_SRC := $(DATA_DIR)/raw 
DATA_DIR_MANUAL := $(DATA_DIR)/manual
DATA_DIR_PROCESSED := $(DATA_DIR)/processed
DATA_DIR_PUBLIC :=  $(DATA_DIR)/public

SHARED_DATA :=

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	censusdatadownloader --data-dir $(DATA_DIR) --year 2018 counties

# Tract boundaries

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusdatadownloader --data-dir $(DATA_DIR) --year 2010 tracts

# Create directories for data

$(DATA_DIR_SRC):
	mkdir -p $@

$(DATA_DIR_MANUAL):
	mkdir -p $@

$(DATA_DIR_PROCESSED):
	mkdir -p $@

$(DATA_DIR_PUBLIC):
	mkdir -p $@
