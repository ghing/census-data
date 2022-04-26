# Load population estimate data into a SQL database

$(TABLE_PROXY_DIR)/pep_2019_population_states: $(DATA_DIR_PROCESSED)/pep_2019_population_states.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk state $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type name text \
	  --type population float \
	  --type estimate_date text \
	  --type state text \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

$(TABLE_PROXY_DIR)/pep_2019_population_counties: $(DATA_DIR_PROCESSED)/pep_2019_population_counties.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk state --pk county $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type name text \
	  --type population float \
	  --type estimate_date text \
	  --type state text \
	  --type county text \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

$(TABLE_PROXY_DIR)/pep_2019_population_places: $(DATA_DIR_PROCESSED)/pep_2019_population_places.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk state --pk place $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type name text \
	  --type population float \
	  --type estimate_date text \
	  --type state text \
	  --type place text \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@
