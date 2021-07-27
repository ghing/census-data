# ETL pipeline for various U.S. Census bureau data sets

DATA_DIR := data
DATA_DIR_SRC := $(DATA_DIR)/raw
DATA_DIR_MANUAL := $(DATA_DIR)/manual
DATA_DIR_PROCESSED := $(DATA_DIR)/processed
DATA_DIR_PUBLIC :=  $(DATA_DIR)/public

# SQLAlchemy-style URL for connecting to a SQL database
# Currently, only SQLite/Spatialite is supported, but it might make sense to
# support/switch to PostgreSQL.
DB_URL := sqlite:///census_data.db

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
include etl/relationship_files.mk
include etl/responserate.mk
# This needs to go last since it references targets in other makefiles
include etl/sql.mk

# TODO: Is there a set of data that should be downloaded using `make all`

# Create directories for data

$(DATA_DIR_SRC):
	mkdir -p $@

$(DATA_DIR_MANUAL):
	mkdir -p $@

$(DATA_DIR_PROCESSED):
	mkdir -p $@

$(DATA_DIR_PUBLIC):
	mkdir -p $@
