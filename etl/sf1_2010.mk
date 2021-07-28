# 2010 Census Summary File 1
# See https://www.census.gov/data/datasets/2010/dec/summary-file-1.html

# Download SF1 data
# TODO: Add rules for additional states
$(DATA_DIR_SRC)/az2010.sf1.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/census_2010/04-Summary_File_1/Arizona/az2010.sf1.zip