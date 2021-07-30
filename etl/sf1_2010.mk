# 2010 Census Summary File 1
# See https://www.census.gov/data/datasets/2010/dec/summary-file-1.html

# Download SF1 data
# TODO: Add rules for additional states
$(DATA_DIR_SRC)/az2010.sf1.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/census_2010/04-Summary_File_1/Arizona/az2010.sf1.zip

$(DATA_DIR_SRC)/ri2010.sf1.zip: | $(DATA_DIR_SRC)
	wget -O $@ https://www2.census.gov/census_2010/04-Summary_File_1/Rhode_Island/ri2010.sf1.zip

# Download schema for geographic header file
$(DATA_DIR_SRC)/census2010_geo_schema.csv: | $(DATA_DIR_SRC)
	wget -O $@ https://raw.githubusercontent.com/wireservice/ffs/master/us/census/census2010_geo_schema.csv

# Convert geographic header to CSV
$(DATA_DIR_PROCESSED)/azgeo2010.sf1.csv: $(DATA_DIR_SRC)/az2010.sf1.zip | $(DATA_DIR_PROCESSED)
	unzip -c -qq $< azgeo2010.sf1 | iconv -f iso-8859-1 -t utf-8 | in2csv -f fixed -s data/raw/census2010_geo_schema.csv | tail -n +2 > $@

$(DATA_DIR_PROCESSED)/rigeo2010.sf1.csv: $(DATA_DIR_SRC)/ri2010.sf1.zip | $(DATA_DIR_PROCESSED)
	unzip -c -qq $< rigeo2010.sf1 | iconv -f iso-8859-1 -t utf-8 | in2csv -f fixed -s data/raw/census2010_geo_schema.csv | tail -n +2 > $@