# Boundaries

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run yensusmapdownloader --year 2018 --data-dir $(DATA_DIR) counties

$(DATA_DIR_PROCESSED)/counties_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run censusmapdownloader --year 2020 --data-dir $(DATA_DIR) counties

# Metropolitan/micropolitan statistical area boundaries

# TODO: Switch to main-line censusmapdownloader once I bring this functionality
# in as part of https://github.com/datadesk/census-map-downloader/issues/7
$(DATA_DIR_PROCESSED)/cbsas_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) cbsas

# Tract boundaries

$(DATA_DIR_PROCESSED)/tracts_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run censusmapdownloader --year 2020 --data-dir $(DATA_DIR) tracts

$(DATA_DIR_PROCESSED)/tracts_2019.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run censusmapdownloader --year 2019 --data-dir $(DATA_DIR) tracts

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run censusmapdownloader --year 2010 --data-dir $(DATA_DIR) tracts

# ZCTA boundaries
$(DATA_DIR_SRC)/tl_2020_us_zcta510.shp: | $(DATA_DIR_SRC)
	pipenv run censusmapdownloader --year 2020 --data-dir $(DATA_DIR) zctas

$(DATA_DIR_SRC)/tl_2010_us_zcta510.shp: | $(DATA_DIR_SRC)
	pipenv run censusmapdownloader --year 2010 --data-dir $(DATA_DIR) zctas
