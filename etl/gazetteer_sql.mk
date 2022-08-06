# Load Gazetteer data into a SQL database.

# The table name used in the database begins with "gaz_" instead of matching the input filename
# ("2019_"), so that the table name begins with a letter, so that the table name
# does not need to be quoted when used in a SQL query.

$(TABLE_PROXY_DIR)/gaz_2019_place_national: $(DATA_DIR_SRC)/2019_Gazetteer/2019_Gaz_place_national.txt | $(TABLE_PROXY_DIR)
	@# Gazetteer files have trailing whitespace at the end of each line
	@# which results in the colum name 'INTPTLONG                  '.
	pipenv run bash -c ' \
	    ./etl/trim_trailing_tsv_whitespace.py $< | \
	    sqlite-utils insert --tsv \
	        --pk GEOID $(SQLITE_DB_PATH) $(basename $(notdir $@)) -' \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $@)) \
	  --type USPS text \
	  --type GEOID text \
	  --type ANSICODE text \
	  --type NAME text \
	  --type LSAD text \
	  --type FUNCSTAT text \
	  --type ALAND float \
	  --type AWATER float \
	  --type ALAND_SQMI float \
	  --type AWATER_SQMI float \
	  --type INTPTLAT float \
	  --type INTPTLONG float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $@));" > $@
