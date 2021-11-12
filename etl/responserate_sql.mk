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
