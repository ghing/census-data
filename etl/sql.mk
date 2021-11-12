# ETL pipeline to load census data into a SQL database
# Currently SQLite/Spatialite is supported, but it might make sense to
# support/switch to PostgreSQL

ifeq (sqlite:///,$(findstring sqlite:///,$(DB_URL)))
	SQLITE_DB_PATH = $(subst sqlite:///,,$(DB_URL))
endif

# Directory that contains files corresponding to database tables
# since make uses the filesystem to determine whether or not a rule has been
# run. I don't love this hack, but I think it's preferable to running a
# command that short circuits every time the table already exists, as is
# done in the technique described here:
# https://mojodna.net/2015/01/07/make-for-data-using-make.html
TABLE_PROXY_DIR := $(DATA_DIR_PROCESSED)/db_tables

.PHONY: clean_table_proxy clean_sql_db

include etl/boundaries_sql.mk
include etl/employment_sql.mk
include etl/race_sql.mk
include etl/redistricting_sql.mk
include etl/relationship_files_sql.mk
include etl/responserate_sql.mk
include etl/sf1_2010_sql.mk

# Create directories for data

# Create the directory that will hold the text files that
# indicate that database tables have been created.
$(TABLE_PROXY_DIR):
	mkdir -p $(TABLE_PROXY_DIR)

# Cleanup

# Delete all files that tell make that a table has been created
clean_table_proxy:
	if test -d $(TABLE_PROXY_DIR); then \
	  rm -rf $(TABLE_PROXY_DIR); \
	fi

# Delete the entire spatial database
clean_sql_db:
	rm -f $(SQLITE_DB_PATH)
