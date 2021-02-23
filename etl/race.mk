# ACS 5-year

# Table B03002: Hispanic or Latino Origin by Race, tracts
$(DATA_DIR_PROCESSED)/acs5_2018_race_tracts.csv: | $(DATA_DIR_PROCESSED)
	censusdatadownloader --data-dir $(DATA_DIR) --year 2018 race tracts

# Table B03002: Hispanic or Latino Origin by Race, block groups 
$(DATA_DIR_PROCESSED)/acs5_2018_race_blockgroups.csv: | $(DATA_DIR_PROCESSED)
	downloadacs5bg --data-dir $(DATA_DIR) --year 2018 race