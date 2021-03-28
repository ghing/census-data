# TODO: Remove this once 
# https://github.com/datadesk/census-map-downloader/7 and
# https://github.com/datadesk/census-map-downloader/8 are
# implemented.
from .geotypes.cbsas import CbsasDownloader2020
from .geotypes.counties import CountiesDownloader2020
from .geotypes.tracts import TractsDownloader2020
from .geotypes.zctas import ZctasDownloader2020


__all__ = (
    "CbsasDownloader2020",
    "CountiesDownloader2020",
    "TractsDownloader2020",
    "ZctasDownloader2020",
)
