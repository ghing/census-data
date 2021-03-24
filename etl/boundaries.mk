# Boundaries

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) counties

# Metropolitan/micropolitan statistical area boundaries

$(DATA_DIR_PROCESSED)/cbsas_2020.geojson: | $(DATA_DIR_PROCESSED)
	pipenv run mycensusmapdownloader --data-dir $(DATA_DIR) cbsas

# Tract boundaries

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) tracts

# ZCTA boundaries
$(DATA_DIR_PROCESSED)/zctas_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) zctas
