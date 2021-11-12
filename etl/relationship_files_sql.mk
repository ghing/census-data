# Load 2010 to 2020 tabulation block relationship file
$(TABLE_PROXY_DIR)/tab2010_tab2020: $(DATA_DIR_SRC)/TAB2010_TAB2020_ST04.zip | $(TABLE_PROXY_DIR)
	sqlite3 $(SQLITE_DB_PATH) "DROP TABLE IF EXISTS tab2010_tab2020;" \
	&& sqlite3 $(SQLITE_DB_PATH) < etl/create_table_tab2010_tab2020.sql \
	&& unzip -d $(DATA_DIR_SRC) $(DATA_DIR_SRC)/TAB2010_TAB2020_ST04.zip tab2010_tab2020_st04_az.txt \
	&& sqlite3 -csv -separator '|' $(SQLITE_DB_PATH) ".import $(DATA_DIR_SRC)/tab2010_tab2020_st04_az.txt tab2010_tab2020" \
	&& rm -f $(DATA_DIR_SRC)/tab2010_tab2020_st04_az.txt \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM tab2010_tab2020;" > $@