# ETL pipeline for Equal Employment Opportunity Tabulation
# See https://www.census.gov/topics/employment/equal-employment-opportunity-tabulation.html

# Download table ALL1W from the API

$(DATA_DIR_PROCESSED)/eeo_2018_occupation_by_sex_race_for_worksite_geo_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2018 occupation_by_sex_race_for_worksite_geo nationwide

$(DATA_DIR_PROCESSED)/eeo_2018_occupation_by_sex_race_for_worksite_geo_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2018 occupation_by_sex_race_for_worksite_geo states

$(DATA_DIR_PROCESSED)/eeo_2018_occupation_by_sex_race_for_worksite_geo_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2018 occupation_by_sex_race_for_worksite_geo counties

$(DATA_DIR_PROCESSED)/eeo_2018_occupation_by_sex_race_for_worksite_geo_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2018 occupation_by_sex_race_for_worksite_geo places 
