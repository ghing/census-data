# Employment data 
# See https://censusreporter.org/topics/employment/

# ACS 5-year

# Table Table C24010: Sex by Occupation for the Civilian Employed Population 16 Years and Over
$(DATA_DIR_PROCESSED)/acs5_2019_occupation_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 occupation places 

$(DATA_DIR_PROCESSED)/acs5_2019_occupation_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 occupation counties

$(DATA_DIR_PROCESSED)/acs5_2019_occupation_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 occupation states