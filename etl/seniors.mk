# Seniors
# See https://censusreporter.org/topics/seniors/

# ACS 5-year

# Table B10063: Households With Grandparents Living With Own Grandchildren by Responsibility for Own Grandchildren and Presence of Parent of Grandchildren
$(DATA_DIR_PROCESSED)/acs5_2019_grandparentslivingwithgrandchildren_zctas.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 grandparentslivingwithgrandchildren zctas
