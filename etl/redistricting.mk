# ETL pipeline for P.L. 94-171 redistricting data

# Download the 2020 P.L. 94-171 Redistricting Data Summary File data (legacy format)
# See https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html

# Arizona
$(DATA_DIR_SRC)/az2020.pl.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/Arizona/az2020.pl.zip