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