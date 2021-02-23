# Boundaries

# County boundaries

$(DATA_DIR_PROCESSED)/counties_2018.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) counties

# Tract boundaries

$(DATA_DIR_PROCESSED)/tracts_2010.geojson: | $(DATA_DIR_PROCESSED)
	censusmapdownloader --data-dir $(DATA_DIR) tracts
