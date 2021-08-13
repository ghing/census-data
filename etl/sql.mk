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

# Load ACS estimates

# Table B03002: Hispanic or Latino Origin by Race, tracts
$(TABLE_PROXY_DIR)/acs5_2019_race_tracts: $(DATA_DIR_PROCESSED)/acs5_2019_race_tracts.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type geoid text \
	  --type name text \
	  --type universe float \
	  --type universe_annotation text \
	  --type universe_moe float \
	  --type universe_moe_annotation text \
	  --type white_alone float \
	  --type white_alone_annotation text \
	  --type white_alone_moe float \
	  --type white_alone_moe_annotation text \
	  --type black_alone float \
	  --type black_alone_annotation text \
	  --type black_alone_moe float \
	  --type black_alone_moe_annotation text \
	  --type american_indian_and_alaska_native float \
	  --type american_indian_and_alaska_native_annotation text \
	  --type american_indian_and_alaska_native_moe float \
	  --type american_indian_and_alaska_native_moe_annotation text \
	  --type asian_alone float \
	  --type asian_alone_annotation text \
	  --type asian_alone_moe float \
	  --type asian_alone_moe_annotation text \
	  --type native_hawaiian_and_pacific_islander float \
	  --type native_hawaiian_and_pacific_islander_annotation text \
	  --type native_hawaiian_and_pacific_islander_moe float \
	  --type native_hawaiian_and_pacific_islander_moe_annotation text \
	  --type other_alone float \
	  --type other_alone_annotation text \
	  --type other_alone_moe float \
	  --type other_alone_moe_annotation text \
	  --type two_or_more_races float \
	  --type two_or_more_races_annotation text \
	  --type two_or_more_races_moe float \
	  --type two_or_more_races_moe_annotation text \
	  --type latino_alone float \
	  --type latino_alone_annotation text \
	  --type latino_alone_moe float \
	  --type latino_alone_moe_annotation text \
	  --type state text \
	  --type county text \
	  --type tract text \
	  --type asians_all float \
	  --type asians_all_moe float \
	  --type other_all float \
	  --type other_all_moe float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Table B03002: Hispanic or Latino Origin by Race, zctas
$(TABLE_PROXY_DIR)/acs5_2019_race_zctas: $(DATA_DIR_PROCESSED)/acs5_2019_race_zctas.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type geoid text \
	  --type name text \
	  --type universe float \
	  --type universe_annotation text \
	  --type universe_moe float \
	  --type universe_moe_annotation text \
	  --type white_alone float \
	  --type white_alone_annotation text \
	  --type white_alone_moe float \
	  --type white_alone_moe_annotation text \
	  --type black_alone float \
	  --type black_alone_annotation text \
	  --type black_alone_moe float \
	  --type black_alone_moe_annotation text \
	  --type american_indian_and_alaska_native float \
	  --type american_indian_and_alaska_native_annotation text \
	  --type american_indian_and_alaska_native_moe float \
	  --type american_indian_and_alaska_native_moe_annotation text \
	  --type asian_alone float \
	  --type asian_alone_annotation text \
	  --type asian_alone_moe float \
	  --type asian_alone_moe_annotation text \
	  --type native_hawaiian_and_pacific_islander float \
	  --type native_hawaiian_and_pacific_islander_annotation text \
	  --type native_hawaiian_and_pacific_islander_moe float \
	  --type native_hawaiian_and_pacific_islander_moe_annotation text \
	  --type other_alone float \
	  --type other_alone_annotation text \
	  --type other_alone_moe float \
	  --type other_alone_moe_annotation text \
	  --type two_or_more_races float \
	  --type two_or_more_races_annotation text \
	  --type two_or_more_races_moe float \
	  --type two_or_more_races_moe_annotation text \
	  --type latino_alone float \
	  --type latino_alone_annotation text \
	  --type latino_alone_moe float \
	  --type latino_alone_moe_annotation text \
	  --type asians_all float \
	  --type asians_all_moe float \
	  --type other_all float \
	  --type other_all_moe float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Load self-response rates

$(TABLE_PROXY_DIR)/responserate_2020_responserate_tracts: $(DATA_DIR_PROCESSED)/responserate_2020_responserate_tracts.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type avg_cumulative float \
	  --type avg_cumulative_internet float \
	  --type max_cumulative_internet float \
	  --type med_cumulative_internet float \
	  --type min_cumulative_internet float \
	  --type max_cumulative float \
	  --type med_cumulative float \
	  --type min_cumulative float \
	  --type cumulative float \
	  --type internet float \
	  --type avg_daily float \
	  --type avg_daily_internet float \
	  --type max_daily_internet float \
	  --type med_daily_internet float \
	  --type min_daily_internet float \
	  --type max_daily float \
	  --type med_daily float \
	  --type min_daily float \
	  --type daily float \
	  --type daily_internet float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

$(TABLE_PROXY_DIR)/responserate_2010_responserate_tracts: $(DATA_DIR_PROCESSED)/responserate_2010_responserate_tracts.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type cumulative float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Load 2020 self-response rate tract relationship file

$(TABLE_PROXY_DIR)/rr_tract_rel.txt: $(DATA_DIR_SRC)/rr_tract_rel.zip | $(TABLE_PROXY_DIR)
	pipenv run ./etl/load_responserate_tract_rel.py $< $(SQLITE_DB_PATH) \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

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

# Load Prototype P.L. 94-171 Redistricting Data Summary File

-rw-rw-r--  3.0 unx  9271054 tx defN 21-Jul-26 08:36 az000032020.pl

# Load geographic header
$(TABLE_PROXY_DIR)/pl94171_2020_geo: $(DATA_DIR_SRC)/az2020.pl.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS pl94171_2020_geo;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_pl94171_2020_geo.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2020.pl.zip azgeo2020.pl \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/azgeo2020.pl pl94171_2020_geo" \
	&& rm -f $(DATA_DIR_SRC)/azgeo2020.pl \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM pl94171_2020_geo;" > $@

# Load file 1
$(TABLE_PROXY_DIR)/pl94171_2020_00001: $(DATA_DIR_SRC)/az2020.pl.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS pl94171_2020_00001;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_pl94171_2020_00001.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2020.pl.zip az000012020.pl \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000012020.pl pl94171_2020_00001" \
	&& rm -f $(DATA_DIR_SRC)/az000012020.pl \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM pl94171_2020_00001;" > $@

# Load file 2
$(TABLE_PROXY_DIR)/pl94171_2020_00002: $(DATA_DIR_SRC)/az2020.pl.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS pl94171_2020_00002;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_pl94171_2020_00002.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2020.pl.zip az000022020.pl \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000022020.pl pl94171_2020_00002" \
	&& rm -f $(DATA_DIR_SRC)/az000022020.pl \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM pl94171_2020_00002;" > $@

# Load file 3
$(TABLE_PROXY_DIR)/pl94171_2020_00003: $(DATA_DIR_SRC)/az2020.pl.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS pl94171_2020_00003;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_pl94171_2020_00003.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2020.pl.zip az000032020.pl \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000032020.pl pl94171_2020_00003" \
	&& rm -f $(DATA_DIR_SRC)/az000032020.pl  \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM pl94171_2020_00003;" > $@

# Create a view for the commonly used columns
$(TABLE_PROXY_DIR)/pl94171_2020_standard.view: $(TABLE_PROXY_DIR)/pl94171_2020_00003
	sqlite3 $(SQLITE_DB_PATH) "DROP VIEW IF EXISTS pl94171_2020_standard;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_view_pl94171_2020_standard.sql \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM pl94171_2020_standard;" > $@

# Load 2010 SF1 

# Load geographic header
$(TABLE_PROXY_DIR)/sf1_2010_geo: $(DATA_DIR_PROCESSED)/azgeo2010.sf1.csv $(DATA_DIR_PROCESSED)/rigeo2010.sf1.csv | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS sf1_2010_geo;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_sf1_2010_geo.sql \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_PROCESSED)/azgeo2010.sf1.csv sf1_2010_geo" \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_PROCESSED)/rigeo2010.sf1.csv sf1_2010_geo" \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM sf1_2010_geo;" > $@

# Load file 3
# This has a lot of the race/ethnicity variables
$(TABLE_PROXY_DIR)/sf1_2010_00003: $(DATA_DIR_SRC)/az2010.sf1.zip $(DATA_DIR_SRC)/ri2010.sf1.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS sf1_2010_00003;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_sf1_2010_00003.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2010.sf1.zip az000032010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000032010.sf1 sf1_2010_00003" \
	&& rm -f $(DATA_DIR_SRC)/az000032010.sf1 \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/ri2010.sf1.zip ri000032010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/ri000032010.sf1 sf1_2010_00003" \
	&& rm -f $(DATA_DIR_SRC)/ri000032010.sf1 \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM sf1_2010_00003;" > $@

# Load file 6
# This has information about group quarters population
$(TABLE_PROXY_DIR)/sf1_2010_00006: $(DATA_DIR_SRC)/az2010.sf1.zip $(DATA_DIR_SRC)/ri2010.sf1.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS sf1_2010_00006;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_sf1_2010_00006.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2010.sf1.zip az000062010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000062010.sf1 sf1_2010_00006" \
	&& rm -f $(DATA_DIR_SRC)/az000062010.sf1 \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/ri2010.sf1.zip ri000062010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/ri000062010.sf1 sf1_2010_00006" \
	&& rm -f $(DATA_DIR_SRC)/ri000062010.sf1 \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM sf1_2010_00006;" > $@

# Load file 44
# This has a lot of the housing unit variables
$(TABLE_PROXY_DIR)/sf1_2010_00044: $(DATA_DIR_SRC)/az2010.sf1.zip $(DATA_DIR_SRC)/ri2010.sf1.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS sf1_2010_00044;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_sf1_2010_00044.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/az2010.sf1.zip az000442010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/az000442010.sf1 sf1_2010_00044" \
	&& rm -f $(DATA_DIR_SRC)/az000442010.sf1 \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/ri2010.sf1.zip ri000442010.sf1 \
	&& sqlite3 -csv -separator ',' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/ri000442010.sf1 sf1_2010_00044" \
	&& rm -f $(DATA_DIR_SRC)/ri000442010.sf1 \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM sf1_2010_00044;" > $@

# Load 2010 to 2020 tabulation block relationship file
$(TABLE_PROXY_DIR)/tab2010_tab2020: $(DATA_DIR_SRC)/TAB2010_TAB2020_ST04.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS tab2010_tab2020;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_tab2010_tab2020.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/TAB2010_TAB2020_ST04.zip tab2010_tab2020_st04_az.txt \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/tab2010_tab2020_st04_az.txt tab2010_tab2020" \
	&& rm -f $(DATA_DIR_SRC)/tab2010_tab2020_st04_az.txt \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM tab2010_tab2020;" > $@

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
