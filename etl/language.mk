# ACS 5-year

# Table C16001: Language Spoken at Home, tracts
$(DATA_DIR_PROCESSED)/acs5_2019_languageshortform_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 languageshortform tracts