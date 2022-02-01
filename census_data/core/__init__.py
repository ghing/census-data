"""Core functionality"""

from census import Census
from census_data.eeo import EEOClient

from census_data.pep import IntPopulationClient, PepClient
from census_data.responserate import ResponseRateClient


# pylint: disable=too-few-public-methods
class AugmentedCensus(Census):
    """
    API wrapper client interface with added population estimate support.
    """

    def __init__(self, key, year=None, session=None):
        super().__init__(key, year=year, session=session)

        self.int_population = IntPopulationClient(key, year, session)
        self.pep = PepClient(key, year, session)
        self.responserate = ResponseRateClient(key, year, session)
        self.eeo = EEOClient(key, year, session)
