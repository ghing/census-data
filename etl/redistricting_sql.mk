# Load Prototype P.L. 94-171 Redistricting Data Summary File

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