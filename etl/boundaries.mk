# Boundaries

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) counties

# TODO: Switch to censusmapdownloader once
# https://github.com/datadesk/census-map-downloader/pull/24 is
# merged.
$(DATA_DIR_PROCESSED)/counties_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) counties

# Metropolitan/micropolitan statistical area boundaries

# TODO: Switch to main-line censusmapdownloader once I bring this functionality
# in as part of https://github.com/datadesk/census-map-downloader/issues/7
$(DATA_DIR_PROCESSED)/cbsas_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) cbsas

# Tract boundaries

# TODO: Switch to main-line censusmapdownloader once I bring this functionality
# in as part of https://github.com/datadesk/census-map-downloader/issues/8
$(DATA_DIR_PROCESSED)/tracts_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) tracts

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) tracts

# ZCTA boundaries
# `censusmapdownloader` creates a separate GeoJSON file for each state's
# ZCTAs, so target the shapefile instead.
$(DATA_DIR_SRC)/tl_2020_us_zcta510.shp: | $(DATA_DIR_SRC)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) zctas

$(DATA_DIR_SRC)/tl_2010_us_zcta510.shp: | $(DATA_DIR_SRC)
	censusmapdownloader --data-dir $(DATA_DIR) zctas
