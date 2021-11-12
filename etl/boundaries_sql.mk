# Load boundaries

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

$(TABLE_PROXY_DIR)/tracts_2019: $(DATA_DIR_PROCESSED)/tracts_2019.geojson | $(TABLE_PROXY_DIR)
	ogr2ogr -f SQLite -a_srs "EPSG:4269" -nlt MULTIPOLYGON -dsco SPATIALITE=yes -nln $(basename $(notdir $<)) $(SQLITE_DB_PATH) -update -append $< \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Load ZCTA boundaries
# `censusmapdownloader` makes one GeoJSON file per state, so load from the
# shapefile instead.
# TODO: Deal with the fact that the fields aren't renamed in the shapefile
# like they are in the GeoJSON.
$(TABLE_PROXY_DIR)/zctas_2020: $(DATA_DIR_SRC)/tl_2020_us_zcta510.shp | $(TABLE_PROXY_DIR)
	ogr2ogr -f SQLite -a_srs "EPSG:4269" -nlt MULTIPOLYGON -dsco SPATIALITE=yes -nln zctas_2020 $(SQLITE_DB_PATH) -update -append $< \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM zctas_2020;" > $@