# ACS 5-year

# Table B03002: Hispanic or Latino Origin by Race, zctas
$(DATA_DIR_PROCESSED)/acs5_2019_race_zctas.csv: | $(DATA_DIR_PROCESSED)
	pipenv run censusdatadownloader --data-dir $(DATA_DIR) --year 2019 race zctas

# Table B03002: Hispanic or Latino Origin by Race, tracts
$(DATA_DIR_PROCESSED)0/acs5_2019_race_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run censusdatadownloader --data-dir $(DATA_DIR) --year 2019 race tracts

$(DATA_DIR_PROCESSED)/acs5_2018_race_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run censusdatadownloader --data-dir $(DATA_DIR) --year 2018 race tracts

# Table B03002: Hispanic or Latino Origin by Race, block groups 
$(DATA_DIR_PROCESSED)/acs5_2018_race_blockgroups.csv: | $(DATA_DIR_PROCESSED)
	pipenv run downloadacs5bg --data-dir $(DATA_DIR) --year 2018 race
