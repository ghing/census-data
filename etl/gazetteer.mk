# Gazetteer files

# National Counties Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_counties_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_counties_national.zip

# Files are touched after unzipping to freshen their dates, so that they are newer than the source .zip file.
# `unzip` sets the file timestamp to match the time within the zip file. This would result in the `unzip` recipe
# running every time (due to its .zip dependency being out of date).
$(DATA_DIR_SRC)/2019_Gaz_counties_national.txt: %.txt: %.zip
	unzip -o $< $(notdir $@) -d $(dir $@)
	touch --no-create $@

# National County Subdivisions Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_cousubs_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_cousubs_national.zip

$(DATA_DIR_SRC)/2019_Gaz_cousubs_national.txt: %.txt: %.zip
	unzip -o $< $(notdir $@) -d $(dir $@)
	touch --no-create $@

# National Places Gazetteer File
$(DATA_DIR_SRC)/2019_Gaz_place_national.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2019_Gazetteer/2019_Gaz_place_national.zip

$(DATA_DIR_SRC)/2019_Gaz_place_national.txt: %.txt: %.zip
	unzip -o $< $(notdir $@) -d $(dir $@)
	touch --no-create $@
