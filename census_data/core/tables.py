"""
A base class that governs how to download and process tables from a Census API table.
"""
from census_data_downloader.core import decorators
from census_data_downloader.core.tables import BaseTableConfig

from census_data.core import geotypes


class NonACSBaseTableConfig(BaseTableConfig):
    """
    Configures how to download and process tables from the Census API.
    """

    def get_raw_field_crosswalk(self, year=None):  # pylint:disable=unused-argument
        """Returns a crosswalk between raw and standardized field names"""
        return self.RAW_FIELD_CROSSWALK  # pylint:disable=no-member

    def get_field_types(self, year=None):  # pylint:disable=unused-argument
        """Returns the field types"""
        return self.FIELD_TYPES  # pylint:disable=no-member

    #
    # Geotype downloaders
    #

    @decorators.downloader
    def download_nationwide(self):
        """
        Download nationwide data.
        """
        return geotypes.NonACSNationwideDownloader

    @decorators.downloader
    def download_states(self):
        """
        Download data for all states.
        """
        return geotypes.NonACSStatesDownloader

    @decorators.downloader
    def download_tracts(self):
        """
        Download data for all Census tracts in the provided state.
        """
        return geotypes.NonACSTractsDownloader

    # TODO: Implement other methods that return non-ACS downloader classes
