"""
Table configurations for census-data-downloader

See
https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/tables.py
and modules in
https://github.com/datadesk/census-data-downloader/tree/master/census_data_downloader/tables

"""

import collections
from census_data_downloader.core.tables import BaseTableConfig
from census_data_downloader.core.decorators import register

import numpy as np


@register
class HouseholdsGrandparentsLivingWithGrandchildren(BaseTableConfig):
    """ACS Table B10063"""
    PROCESSED_TABLE_NAME = (
        "grandparentslivingwithgrandchildren"  # Your humanized table name
    )
    UNIVERSE = "households"  # The universe value for this table
    RAW_TABLE_NAME = "B10063"  # The id of the source table
    RAW_FIELD_CROSSWALK = collections.OrderedDict(
        {
            # A crosswalk between the raw field name and our humanized field name.
            "001": "universe",
            "002": "grandparent_living_w_grandchildren",
            "003": "grandparent_responsible_for_own_grandchildren",
            "004": "no_parent_of_grandchildren_present",
            "005": "other_grandparents",
            "006": "grandparent_not_responsible_for_own_grandchildren",
            "007": "without_grandparents_living_with_grandchildren",
        }
    )

@register
class ResponseRate2020Downloader(BaseTableConfig):
    """
    Decennial Census Self-Response Rates 2020

    See https://www.census.gov/data/developers/data-sets/decennial-response-rates.2020.html

    """
    YEAR_LIST = [2020,]
    PROCESSED_TABLE_NAME = "responserate"
    UNIVERSE = "households" # This might actually be addresses
    RAW_TABLE_NAME = "responserate"
    RAW_FIELD_CROSSWALK = collections.OrderedDict({
        "CAVG": "avg_cumulative",
        "CINTAVG": "avg_cumulative_internet",
        "CINTMAX": "max_cumulative_internet",
        "CINTMED": "med_cumulative_internet",
        "CINTMIN": "min_cumulative_internet",
        "CMAX": "max_cumulative",
        "CMED": "med_cumulative",
        "CMIN": "min_cumulative",
        "CRRALL": "cumulative",
        "CRRINT": "internet",
        "DAVG": "avg_daily",
        "DINTAVG": "avg_daily_internet",
        "DINTMAX": "max_daily_internet",
        "DINTMED": "med_daily_internet",
        "DINTMIN": "min_daily_internet",
        "DMAX": "max_daily",
        "DMED": "med_daily",
        "DMIN": "min_daily",
        "DRRALL": "daily",
        "DRRINT": "daily_internet",
        "RESP_DATE": "resp_date",
    })
    FIELD_TYPES = {
        "CAVG": np.float64,
        "CINTAVG": np.float64,
        "CINTMAX": np.float64,
        "CINTMED": np.float64,
        "CINTMIN": np.float64,
        "CMAX": np.float64,
        "CMED": np.float64,
        "CMIN": np.float64,
        "CRRALL": np.float64,
        "CRRINT": np.float64,
        "DAVG": np.float64,
        "DINTAVG": np.float64,
        "DINTMAX": np.float64,
        "DINTMED": np.float64,
        "DINTMIN": np.float64,
        "DMAX": np.float64,
        "DMED": np.float64,
        "DMIN": np.float64,
        "DRRALL": np.float64,
        "DRRINT": np.float64,
    }

    def __init__(   # pylint:disable=too-many-arguments
        self,
        api_key=None,
        source="responserate",
        years=None,
        data_dir=None,
        force=False
    ):
        super().__init__(api_key, source, years, data_dir, force)


@register
class ResponseRate2010Downloader(BaseTableConfig):
    """
    Decennial Census Self-Response Rates 2010

    See https://www.census.gov/data/developers/data-sets/decennial-response-rates.2010.html

    """
    YEAR_LIST = [2010,]
    PROCESSED_TABLE_NAME = "responserate"
    UNIVERSE = "households" # This might actually be addresses
    RAW_TABLE_NAME = "responserate"
    RAW_FIELD_CROSSWALK = collections.OrderedDict({
        "FSRR2010": "cumulative",
    })
    FIELD_TYPES = {
        "FSRR2010": np.float64,
    }

    def __init__(   # pylint:disable=too-many-arguments
        self,
        api_key=None,
        source="responserate",
        years=None,
        data_dir=None,
        force=False
    ):
        super().__init__(api_key, source, years, data_dir, force)
