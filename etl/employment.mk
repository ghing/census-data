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

# Table B23025: Employment Status
$(DATA_DIR_PROCESSED)/acs5_2019_employmentstatus_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 employmentstatus places 

$(DATA_DIR_PROCESSED)/acs5_2019_employmentstatus_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 employmentstatus counties 

$(DATA_DIR_PROCESSED)/acs5_2019_employmentstatus_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 employmentstatus states 

# Table C24080: Sex by Class of Worker for the Civilian Population
$(DATA_DIR_PROCESSED)/acs5_2019_classofworker_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 classofworker places 

$(DATA_DIR_PROCESSED)/acs5_2019_classofworker_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 classofworker counties 

$(DATA_DIR_PROCESSED)/acs5_2019_classofworker_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 classofworker states 