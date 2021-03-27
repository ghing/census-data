#! /usr/bin/env python
# -*- coding: utf-8 -*-
# TODO: Remove this once
# https://github.com/datadesk/census-map-downloader/issues/8 is
# implemented.
import collections
from census_map_downloader.base import BaseStateDownloader, BaseStateListDownloader

# Logging
import logging
logger = logging.getLogger(__name__)


class StateTractsDownloader2020(BaseStateDownloader):
    """
    Download 2020 tracts for a single state.
    """
    YEAR = 2020
    PROCESSED_NAME = f"tracts_{YEAR}"
    # Docs pg 57 (https://www2.census.gov/geo/pdfs/maps-data/data/tiger/tgrshp2018/TGRSHP2018_TechDoc_Ch3.pdf)
    FIELD_CROSSWALK = collections.OrderedDict({
        "STATEFP": "state_fips",
        "COUNTYFP": "county_fips",
        "TRACTCE": "tract_id",
        "GEOID": "geoid",
        "NAME": "tract_name",
        "geometry": "geometry"
    })

    @property
    def url(self):
        return self.state.shapefile_urls("tract")

    @property
    def zip_name(self):
        return f"tl_2010_{self.state.fips}_tract.zip"

    @property
    def url(self):
        return f"https://www2.census.gov/geo/tiger/TIGER2020/TRACT/{self.zip_name}"

    @property
    def zip_name(self):
        return f"tl_2020_{self.state.fips}_tract.zip"

    @property
    def zip_folder(self):
        return f"tl_2020_{self.state.fips}_tract"

    @property
    def geojson_name(self):
        return f"{self.PROCESSED_NAME}_{self.state.abbr.lower()}.geojson"


class TractsDownloader2020(BaseStateListDownloader):
    """
    Download all 2020 tracts in the United States.
    """
    YEAR = 2020
    PROCESSED_NAME = f"tracts_{YEAR}"
    DOWNLOADER_CLASS = StateTractsDownloader2020
