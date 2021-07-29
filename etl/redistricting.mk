# ETL pipeline for P.L. 94-171 redistricting data

# Download the Prototype P.L. 94-171 Redistricting Data Summary File
# See https://www.census.gov/programs-surveys/decennial-census/about/rdo/program-management.html#P3
$(DATA_DIR_SRC)/ri2018_2020Style.pl.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/programs-surveys/decennial/rdo/datasets/2018/ri2018_2020Style.pl.zip