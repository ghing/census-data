# ETL pipeline for various U.S. Census bureau data sets

DATA_DIR := data
DATA_DIR_SRC := $(DATA_DIR)/raw
DATA_DIR_MANUAL := $(DATA_DIR)/manual
DATA_DIR_PROCESSED := $(DATA_DIR)/processed
DATA_DIR_PUBLIC :=  $(DATA_DIR)/public

SHARED_DATA :=

# Rules to download different types of data are broken out into individual
# makefiles.
# I roughly try to follow the topic areas from Census Reporter:
# https://censusreporter.org/topics/
include etl/race.mk
include etl/popest.mk
include etl/boundaries.mk
include etl/gazetteer.mk
include etl/seniors.mk

# Create directories for data

$(DATA_DIR_SRC):
	mkdir -p $@

$(DATA_DIR_MANUAL):
	mkdir -p $@

$(DATA_DIR_PROCESSED):
	mkdir -p $@

$(DATA_DIR_PUBLIC):
	mkdir -p $@
