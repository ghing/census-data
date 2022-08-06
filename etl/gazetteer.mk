# Gazetteer files

GAZETTEER_AREA_TYPES = counties_national cosubs_national place_national
GAZETTEER_YEARS = 2019 2020 2021

# Defines list of Gazetteer Files that are available for the defined
# area types and years. Files in this list have the directory
# prefix "$(YEAR)_Gazetteer/", which is how the files are stored
# on census.gov.
# This pattern is carried forward when storing them in the raw data
# directory because there is no trivial way to flatten the file structure
# on disk (in $(DATA_DIR_SRC)), but maintain it in the wget call.
GAZETTEER_FILES_ZIPS = $(foreach YEAR, $(GAZETTEER_YEARS),  \
					    $(foreach TYPE, $(GAZETTEER_AREA_TYPES), \
    					$(YEAR)_Gazetteer/$(YEAR)_Gaz_$(TYPE).zip \
	    				) \
		    		   )
GAZETTEER_FILES_TXT = $(GAZETTEER_FILES_ZIPS:.zip=.txt)

# Files are touched after unzipping to freshen their dates, so that they are newer than the source .zip file.
# `unzip` sets the file timestamp to match the time within the zip file. This would result in the `unzip` recipe
# running every time (due to its .zip dependency being out of date).
$(addprefix $(DATA_DIR_SRC)/,$(GAZETTEER_FILES_TXT)): %.txt: %.zip
	unzip -o $< $(notdir $@) -d $(dir $@)
	touch --no-create $@

# Because raw Gazetteer files are stored in a hierarchy that matches
# the URL on census.gov, a `mkdir` is performed to ensure the destination
# sub-directory exists.
# The $(patubst) call removes the $(DATA_DIR_SRC) prefix from the target name.
$(addprefix $(DATA_DIR_SRC)/,$(GAZETTEER_FILES_ZIPS)): | $(DATA_DIR_SRC)
	mkdir -p "$(dir $@)"
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/gazetteer/$(patsubst $(DATA_DIR_SRC)/%,%,$@)

