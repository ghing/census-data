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

# ogr2ogr command explanation
#
# Many of these rules use the `ogr2ogr` command to load data from GeoJSON
# or shapefiles. This is a description of some of the arguments that are
# used in these rules:
#
# `-f SQLite`: Output  is a SQLite database
# `-a_srs "EPSG:4269"`: Set the output spatial reference system to
#   4269. I'm not sure if this is absolutely needed, but since the
#   input is GeoJSON and the SRS is defined less explicitely than
#   in a shapefile, it doesn't hurt.
# `-nlt MULTIPOLYGON`: The created layer (database table) should
#   have a geometry type of MULTIPOLYGON. This is needed because the
#   GeoJSON includes features of both POLYGON and MULTIPOLYGON. I
#   think this will case the POLYGONS into MULTIPOLYGONS.
# `-dsco SPATIALITE=yes`: `-dsco` provides format-specific dataset
#   creation options. We're using SQLite's spatial extensions, so
#   specify this.
# `-nln ...`: Set the layer name from the input filename. So, if
#   the input filename is `counties_2020.geojson` the layer (database
#   table) will be `counties_2020`. We use make variables and
#   functions to get the table name from the filename.
# `-update -append`: I think `-update` is required so that the
#   database is not re-created each time. I'm not sure if `-append`
#   is needed, and may cause problems if the same GeoJSON file
#   is loaded multiple times without first dropping the table.
#
# Load metropolitan/micropolitan statistical area (CBSA) boundaries:
$(TABLE_PROXY_DIR)/cbsas_2020: $(DATA_DIR_PROCESSED)/cbsas_2020.geojson | $(TABLE_PROXY_DIR)
	ogr2ogr -f SQLite -a_srs "EPSG:4269" -nlt MULTIPOLYGON -dsco SPATIALITE=yes -nln $(basename $(notdir $<)) $(SQLITE_DB_PATH) -update -append $< \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Load county boundaries
$(TABLE_PROXY_DIR)/counties_2020: $(DATA_DIR_PROCESSED)/counties_2020.geojson | $(TABLE_PROXY_DIR)
	ogr2ogr -f SQLite -a_srs "EPSG:4269" -nlt MULTIPOLYGON -dsco SPATIALITE=yes -nln $(basename $(notdir $<)) $(SQLITE_DB_PATH) -update -append $< \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Load tract boundaries
$(TABLE_PROXY_DIR)/tracts_2020: $(DATA_DIR_PROCESSED)/tracts_2020.geojson | $(TABLE_PROXY_DIR)
	ogr2ogr -f SQLite -a_srs "EPSG:4269" -nlt MULTIPOLYGON -dsco SPATIALITE=yes -nln $(basename $(notdir $<)) $(SQLITE_DB_PATH) -update -append $< \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

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
