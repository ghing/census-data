#! /usr/bin/env python
# -*- coding: utf-8 -*-
import collections
from census_map_downloader.base import BaseDownloader

# Logging
import logging
logger = logging.getLogger(__name__)


class CbsasDownloader2020(BaseDownloader):
    """
    Download counties.
    """
    PROCESSED_NAME = "cbsas_2020"
    # Docs pg 157 (https://www2.census.gov/geo/pdfs/maps-data/data/tiger/tgrshp2020/TGRSHP2020_TechDoc.pdf)
    FIELD_CROSSWALK = collections.OrderedDict({
        "CSAFP": "csa_fips",
        "CBSAFP": "cbsa_fips",
        "GEOID": "geoid",
        "NAME": "cbsa_name",
        "geometry": "geometry"
    })

    @property
    def url(self):
        return "https://www2.census.gov/geo/tiger/TIGER2020/CBSA/tl_2020_us_cbsa.zip"

    @property
    def zip_name(self):
        return f"tl_2020_us_cbsa.zip"
