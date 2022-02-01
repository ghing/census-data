"""
Census API wrapper for the Equal Employment Opportunity Tabulation

See https://www.census.gov/topics/employment/equal-employment-opportunity-tabulation.html

"""

from census.core import Client, merge


class EEOClient(Client):
    """
        API client for the Equal Employment Opportunity Tabulation

        See https://www.census.gov/topics/employment/equal-employment-opportunity-tabulation.html

    Variables: https://api.census.gov/data/2018/acs/acs5/eeo/variables.html

    """

    dataset = "eeo"

    default_year = 2018
    years = (2018,)

    def _switch_endpoints(self, year):  # pylint: disable=unused-argument
        self.endpoint_url = "https://api.census.gov/data/%s/acs/acs5/%s"
        self.definitions_url = (
            "https://api.census.gov/data/%s/acs/acs5/%s/variables.json"
        )
        self.definition_url = (
            "https://api.census.gov/data/%s/acs/acs5/%s/variables/%s.json"
        )
        self.groups_url = "https://api.census.gov/data/%s/acs/acs5/%s/groups.json"

    def tables(self, *args, **kwargs):
        self._switch_endpoints(kwargs.get("year", self.default_year))
        return super().tables(*args, **kwargs)

    @classmethod
    def eeo_chunks(cls, fields, n=48):  # pylint: disable=invalid-name
        """Get groups of no more than 50 fields making sure that each includes EEO and GEO_ID"""
        for i in range(0, len(fields), n):
            chunk = fields[i : i + n]

            if "EEO" not in chunk:
                if isinstance(chunk, list):
                    chunk = ["EEO"] + chunk
                elif isinstance(fields, tuple):
                    chunk = ("EEO",) + chunk

            if isinstance(chunk, list):
                chunk += ["GEO_ID"]
            elif isinstance(fields, tuple):
                chunk += ("GEO_ID",)

            yield chunk

    @classmethod
    def eeo_sort(cls, results):
        """Sort results by GEO_ID, then EEO"""
        # The secondary sort comes first
        # See https://docs.python.org/3/howto/sorting.html#sort-stability-and-complex-sorts
        results_sorted = sorted(
            results, key=lambda x: x["EEO"] if x["EEO"] is not None else ""
        )
        results_sorted = sorted(results_sorted, key=lambda x: x["GEO_ID"])

        return results_sorted

    def get(self, fields, geo, year=None, **kwargs):
        """
        The API only accepts up to 50 fields on each query.
        Chunk requests, and use the unique GEO_ID to match up the chunks
        in case the responses are in different orders.
        GEO_ID is not reliably present in pre-2010 requests.
        """
        self._switch_endpoints(kwargs.get("year", self.default_year))

        # The grouping needs to be modified from the base class
        # implementation because, unlike with the ACS tables, there's one
        # record per occupation (`EEO` field) and geography rather than
        # just one row per geography.
        all_results = (
            self.eeo_sort(
                self.query(chunk_fields, geo, year, sort_by_geoid=False, **kwargs)
            )
            for chunk_fields in self.eeo_chunks(fields)
        )
        merged_results = [merge(result) for result in zip(*all_results)]

        return merged_results
