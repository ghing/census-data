"""
Census API wrapper for decennial census self-response rates.

See https://www.census.gov/data/developers/data-sets/responserateennial-response-rates.2020.html

"""


from census.core import (
    Client,
    supported_years,
)


class ResponseRateClient(Client):
    """
    API client for Decennial Census Self-Response Rates (2020, 2010)

    See https://www.census.gov/data/developers/data-sets/decennial-response-rates.2020.html

    """

    dataset = "responserate"
    default_year = 2020
    years = (
        2010,
        2020,
    )

    def _switch_endpoints(self, year):

        self.endpoint_url = 'https://api.census.gov/data/%s/dec/%s'
        self.definitions_url = 'https://api.census.gov/data/%s/dec/%s/variables.json'
        self.definition_url = 'https://api.census.gov/data/%s/dec/%s/variables/%s.json'
        self.groups_url = 'https://api.census.gov/data/%s/dec/%s/groups.json'

    def tables(self, *args, **kwargs):
        self._switch_endpoints(kwargs.get('year', self.default_year))
        return super(ResponseRateClient, self).tables(*args, **kwargs)

    def get(self, *args, **kwargs):
        self._switch_endpoints(kwargs.get('year', self.default_year))
        return super(ResponseRateClient, self).get(*args, **kwargs)        

    @supported_years()
    def state_county_subdivision(self, fields, state_fips,
                                 county_fips, subdiv_fips, **kwargs):
        return self.get(fields, geo={
            'for': 'county subdivision:{}'.format(subdiv_fips),
            'in': 'state:{} county:{}'.format(state_fips, county_fips),
        }, **kwargs)

    @supported_years()
    def state_county_tract(self, fields, state_fips,
                           county_fips, tract, **kwargs):
        return self.get(fields, geo={
            'for': 'tract:{}'.format(tract),
            'in': 'state:{} county:{}'.format(state_fips, county_fips),
        }, **kwargs)
