# ETL pipeline for relationship files

# 2010 Census Tabulation Block to 2020 Census Tabulation Block Relationship Files
# See https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html

# TODO: Download additional block relationship files
BLOCK_RELATIONSHIP_FILES_2010_2020_PATHS = $(addprefix $(DATA_DIR_SRC)/, \
	TAB2010_TAB2020_ST01.zip \
	TAB2010_TAB2020_ST02.zip \
	TAB2010_TAB2020_ST04.zip \
	TAB2010_TAB2020_ST05.zip \
	TAB2010_TAB2020_ST06.zip \
	TAB2010_TAB2020_ST08.zip \
	TAB2010_TAB2020_ST09.zip \
	TAB2010_TAB2020_ST10.zip \
	TAB2010_TAB2020_ST12.zip \
	TAB2010_TAB2020_ST13.zip \
	TAB2010_TAB2020_ST14.zip \
	TAB2010_TAB2020_ST16.zip \
	TAB2010_TAB2020_ST17.zip \
	TAB2010_TAB2020_ST18.zip \
	TAB2010_TAB2020_ST19.zip \
	TAB2010_TAB2020_ST20.zip \
	TAB2010_TAB2020_ST21.zip \
	TAB2010_TAB2020_ST22.zip \
	TAB2010_TAB2020_ST23.zip \
	TAB2010_TAB2020_ST24.zip \
	TAB2010_TAB2020_ST25.zip \
	TAB2010_TAB2020_ST26.zip \
	TAB2010_TAB2020_ST27.zip \
	TAB2010_TAB2020_ST28.zip \
	TAB2010_TAB2020_ST29.zip \
	TAB2010_TAB2020_ST30.zip \
	TAB2010_TAB2020_ST31.zip \
	TAB2010_TAB2020_ST32.zip \
	TAB2010_TAB2020_ST33.zip \
	TAB2010_TAB2020_ST34.zip \
	TAB2010_TAB2020_ST35.zip \
	TAB2010_TAB2020_ST36.zip \
	TAB2010_TAB2020_ST37.zip \
	TAB2010_TAB2020_ST38.zip \
	TAB2010_TAB2020_ST39.zip \
	TAB2010_TAB2020_ST40.zip \
	TAB2010_TAB2020_ST41.zip \
	TAB2010_TAB2020_ST42.zip \
	TAB2010_TAB2020_ST44.zip \
	TAB2010_TAB2020_ST45.zip \
	TAB2010_TAB2020_ST46.zip \
	TAB2010_TAB2020_ST47.zip \
	TAB2010_TAB2020_ST48.zip \
	TAB2010_TAB2020_ST49.zip \
	TAB2010_TAB2020_ST50.zip \
	TAB2010_TAB2020_ST51.zip \
	TAB2010_TAB2020_ST53.zip \
	TAB2010_TAB2020_ST54.zip \
	TAB2010_TAB2020_ST55.zip \
	TAB2010_TAB2020_ST56.zip \
)

# Download 2010 to 2020 block relationship files
$(DATA_DIR_SRC)/TAB2010_TAB2020_%.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/geo/docs/maps-data/data/rel2020/t10t20/$(notdir $@)