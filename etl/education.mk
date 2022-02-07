# ACS 5-year tables related to education

# Table B14007: School Enrollment by Detailed Level of School
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed places 

# Table B14007A: School Enrollment by Detailed Level of School (White Alone) 
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white places 

# Table B14007B: School Enrollment by Detailed Level of School (Black or African American Alone)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_black_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_black nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_black_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_black states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_black_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_black counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_black_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_black places 

# Table B14007C: School Enrollment by Detailed Level of School (American Indian and Alaska Native Alone)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_american_indian_and_alaska_native_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_american_indian_and_alaska_native nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_american_indian_and_alaska_native_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_american_indian_and_alaska_native states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_american_indian_and_alaska_native_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_american_indian_and_alaska_native counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_american_indian_and_alaska_native_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_american_indian_and_alaska_native places 

# Table B14007D: School Enrollment by Detailed Level of School (Asian Alone)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_asian_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_asian nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_asian_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_asian states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_asian_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_asian counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_asian_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_asian places 

# Table B14007E: School Enrollment by Detailed Level of School (Native Hawaiian and Other Pacific Islander Alone)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_native_hawaiian_and_pacific_islander_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_native_hawaiian_and_pacific_islander nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_native_hawaiian_and_pacific_islander_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_native_hawaiian_and_pacific_islander states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_native_hawaiian_and_pacific_islander_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_native_hawaiian_and_pacific_islander counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_native_hawaiian_and_pacific_islander_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_native_hawaiian_and_pacific_islander places 

# Table B14007F: School Enrollment by Detailed Level of School (Some Other Race Alone)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_other_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_other nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_other_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_other states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_other_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_other counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_other_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_other places 

# Table B14007G: School Enrollment by Detailed Level of School (Two or More Races)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_two_or_more_races_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_two_or_more_races nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_two_or_more_races_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_two_or_more_races states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_two_or_more_races_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_two_or_more_races counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_two_or_more_races_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_two_or_more_races places 

# Table B14007H: School Enrollment by Detailed Level of School (White Alone, Not Hispanic or Latino)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_nh_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white_nh nationwide 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_nh_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white_nh states 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_nh_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white_nh counties 

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_white_nh_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_white_nh places 

# Table B14007I: School Enrollment by Detailed Level of School (Hispanic or Latino)
$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_latino_nationwide.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_latino nationwide

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_latino_states.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_latino states

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_latino_counties.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_latino counties

$(DATA_DIR_PROCESSED)/acs5_2019_school_enrollment_detailed_latino_places.csv: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusdatadownloader --data-dir $(DATA_DIR) --year 2019 school_enrollment_detailed_latino places
