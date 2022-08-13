# Load Gazetteer data into a SQL database.

# The table name used in the database begins with "gaz_" instead of matching the input filename
# ("2019_"), so that the table name begins with a letter, so that the table name
# does not need to be quoted when used in a SQL query.

GAZETTEER_AREA_TYPES = counties_national cosubs_national place_national
GAZETTEER_YEARS = 2019 2020 2021

define GAZETTEER_LOAD_DATA_RULE
# GAZETTEER_LOAD_DATA_RULE - Load raw gazetteer dataset into database.
# Parameters:
#   - $1 = Year
#   - $2 = Area Type
$(TABLE_PROXY_DIR)/gaz_$1_$2: $(DATA_DIR_SRC)/$1_Gaz_$2.txt | $(TABLE_PROXY_DIR)
	@echo "$$@"
	@echo "$$^"
	@# Gazetteer files have trailing whitespace at the end of each line
	@# which results in the colum name 'INTPTLONG                  '.
	pipenv run bash -c ' \
	    ./etl/trim_trailing_tsv_whitespace.py $$< | \
	    sqlite-utils insert --tsv \
	        --pk GEOID $(SQLITE_DB_PATH) $$(basename $$(notdir $$@)) -' \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $$(basename $$(notdir $$@)) \
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
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $$(basename $$(notdir $$@));" > $$@
endef

$(foreach YEAR, $(GAZETTEER_YEARS),  \
  $(foreach TYPE, $(GAZETTEER_AREA_TYPES), \
  $(eval $(call GAZETTEER_LOAD_DATA_RULE,$(YEAR),$(TYPE))) \
  ) \
)
