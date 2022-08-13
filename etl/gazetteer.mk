# Gazetteer files

GAZETTEER_AREA_TYPES = counties_national cosubs_national place_national
GAZETTEER_YEARS = 2019 2020 2021

define GAZETTEER_DATASET_RULES 
# GAZETTEER_DATASET_RULES - Targets for downloading and extracting raw
# gazetteer datasets.
# Parameters:
#   - $1 = Year
#   - $2 = Area Type
#
# Files are touched after unzipping to freshen their dates, so that they are newer than the source .zip file.
# `unzip` sets the file timestamp to match the time within the zip file. This would result in the `unzip` recipe
# running every time (due to its .zip dependency being out of date).
$(DATA_DIR_SRC)/$(1)_Gaz_$(2).txt: $(DATA_DIR_SRC)/$(1)_Gaz_$(2).zip
	unzip -o $$< $$(notdir $$@) -d $$(dir $$@)
	touch --no-create $$@

$(DATA_DIR_SRC)/$(1)_Gaz_$(2).zip: | $(DATA_DIR_SRC)
	wget -O $$(@) https://www2.census.gov/geo/docs/maps-data/data/gazetteer/$1_Gazetteer/$1_Gaz_$2.zip
endef

# Create .txt and .zip rules for the Gazetteer Files that are available
# in the defined area types and years. This creates rules in the form
# of data/raw/2021_Gaz_place_national.txt.
$(foreach YEAR, $(GAZETTEER_YEARS),  \
  $(foreach TYPE, $(GAZETTEER_AREA_TYPES), \
  $(eval $(call GAZETTEER_DATASET_RULES,$(YEAR),$(TYPE))) \
  ) \
)
