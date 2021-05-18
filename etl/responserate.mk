# ETL pipeline for Decennial Census Self-Response Rates
# See https://www.census.gov/data/developers/data-sets/decennial-response-rates.2020.html

$(DATA_DIR_PROCESSED)/responserate_2020_population_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run downloadresponseratetract  --data-dir $(DATA_DIR) --year 2020

$(DATA_DIR_PROCESSED)/responserate_2010_population_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run downloadresponseratetract  --data-dir $(DATA_DIR) --year 2010
