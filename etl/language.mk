# ACS 5-year

# Table C16001: Language Spoken at Home, tracts
$(DATA_DIR_PROCESSED)/acs5_2019_languageshortform_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 languageshortform tracts

# Table B16001: Language Spoken at Home by Ability to Speak English
# 2015 is the last year this level of detail was available
$(DATA_DIR_PROCESSED)/acs5_2015_languagelongform_tracts.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2015 languagelongform2015 tracts