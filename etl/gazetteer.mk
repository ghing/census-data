# Gazetteer files

# National Counties Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_counties_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_counties_national.zip

# National County Subdivisions Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_cousubs_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_cousubs_national.zip

# National Places Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_place_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_place_national.zip
