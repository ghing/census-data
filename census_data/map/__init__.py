"""Custom map downloader based on census-map-downloader"""

from .geotypes.cbsas import CbsasDownloader2020

__all__ = (
    "CbsasDownloader2020",
)
