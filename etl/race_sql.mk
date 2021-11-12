# Table B03002: Hispanic or Latino Origin by Race, tracts
$(TABLE_PROXY_DIR)/acs5_2019_race_tracts: $(DATA_DIR_PROCESSED)/acs5_2019_race_tracts.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type geoid text \
	  --type name text \
	  --type universe float \
	  --type universe_annotation text \
	  --type universe_moe float \
	  --type universe_moe_annotation text \
	  --type white_alone float \
	  --type white_alone_annotation text \
	  --type white_alone_moe float \
	  --type white_alone_moe_annotation text \
	  --type black_alone float \
	  --type black_alone_annotation text \
	  --type black_alone_moe float \
	  --type black_alone_moe_annotation text \
	  --type american_indian_and_alaska_native float \
	  --type american_indian_and_alaska_native_annotation text \
	  --type american_indian_and_alaska_native_moe float \
	  --type american_indian_and_alaska_native_moe_annotation text \
	  --type asian_alone float \
	  --type asian_alone_annotation text \
	  --type asian_alone_moe float \
	  --type asian_alone_moe_annotation text \
	  --type native_hawaiian_and_pacific_islander float \
	  --type native_hawaiian_and_pacific_islander_annotation text \
	  --type native_hawaiian_and_pacific_islander_moe float \
	  --type native_hawaiian_and_pacific_islander_moe_annotation text \
	  --type other_alone float \
	  --type other_alone_annotation text \
	  --type other_alone_moe float \
	  --type other_alone_moe_annotation text \
	  --type two_or_more_races float \
	  --type two_or_more_races_annotation text \
	  --type two_or_more_races_moe float \
	  --type two_or_more_races_moe_annotation text \
	  --type latino_alone float \
	  --type latino_alone_annotation text \
	  --type latino_alone_moe float \
	  --type latino_alone_moe_annotation text \
	  --type state text \
	  --type county text \
	  --type tract text \
	  --type asians_all float \
	  --type asians_all_moe float \
	  --type other_all float \
	  --type other_all_moe float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@

# Table B03002: Hispanic or Latino Origin by Race, zctas
$(TABLE_PROXY_DIR)/acs5_2019_race_zctas: $(DATA_DIR_PROCESSED)/acs5_2019_race_zctas.csv | $(TABLE_PROXY_DIR)
	pipenv run sqlite-utils insert --csv --pk geoid $(SQLITE_DB_PATH) $(basename $(notdir $<)) $< \
	&& pipenv run sqlite-utils transform $(SQLITE_DB_PATH) $(basename $(notdir $<)) \
	  --type geoid text \
	  --type name text \
	  --type universe float \
	  --type universe_annotation text \
	  --type universe_moe float \
	  --type universe_moe_annotation text \
	  --type white_alone float \
	  --type white_alone_annotation text \
	  --type white_alone_moe float \
	  --type white_alone_moe_annotation text \
	  --type black_alone float \
	  --type black_alone_annotation text \
	  --type black_alone_moe float \
	  --type black_alone_moe_annotation text \
	  --type american_indian_and_alaska_native float \
	  --type american_indian_and_alaska_native_annotation text \
	  --type american_indian_and_alaska_native_moe float \
	  --type american_indian_and_alaska_native_moe_annotation text \
	  --type asian_alone float \
	  --type asian_alone_annotation text \
	  --type asian_alone_moe float \
	  --type asian_alone_moe_annotation text \
	  --type native_hawaiian_and_pacific_islander float \
	  --type native_hawaiian_and_pacific_islander_annotation text \
	  --type native_hawaiian_and_pacific_islander_moe float \
	  --type native_hawaiian_and_pacific_islander_moe_annotation text \
	  --type other_alone float \
	  --type other_alone_annotation text \
	  --type other_alone_moe float \
	  --type other_alone_moe_annotation text \
	  --type two_or_more_races float \
	  --type two_or_more_races_annotation text \
	  --type two_or_more_races_moe float \
	  --type two_or_more_races_moe_annotation text \
	  --type latino_alone float \
	  --type latino_alone_annotation text \
	  --type latino_alone_moe float \
	  --type latino_alone_moe_annotation text \
	  --type asians_all float \
	  --type asians_all_moe float \
	  --type other_all float \
	  --type other_all_moe float \
	&& sqlite3 -csv $(SQLITE_DB_PATH) "SELECT COUNT(*) FROM $(basename $(notdir $<));" > $@