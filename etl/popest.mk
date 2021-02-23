# Population estimates

$(DATA_DIR_PROCESSED)/pep_2019_population_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run downloadpep --data-dir $(DATA_DIR) --year 2019 population states 

$(DATA_DIR_PROCESSED)/pep_2019_population_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run downloadpep --data-dir $(DATA_DIR) --year 2019 population counties
