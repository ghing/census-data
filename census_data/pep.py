"""Census API wrappers for population estimates"""

from census.core import (
    APIKeyError,
    CensusException,
    Client,
    float_or_str,
    list_or_str,
    lru_cache,
    retry_on_transient_error,
    supported_years,
)


def date_for_year(year=None, base_year=2000):
    """
    Convert year to date code

    Convert year to date code for the 2000-2010 Intercensals population
    estimates.

    This endpoint is different from the ACS endpoints as it doesn't have a
    year in the endpoint URL.

    Instead, years are specified by a code passed as a `DATE_` URL parameter.

    Returns the code corresponding to an estimate date for the specified year.

    Note that there are two estimates for 2000.

    """
    if year is None:
        return None

    if base_year == 2000:
        codes = [
            [1, 2],
            [3],
            [4],
            [5],
            [6],
            [7],
            [8],
            [9],
            [10],
            [11],
            [12],
        ]

    else:
        codes = [
            [1, 2, 3],
            [4],
            [5],
            [6],
            [7],
            [8],
            [9],
            [10],
            [11],
            [12],
        ]

    date_for_year_map = {}

    for i, code in enumerate(codes):
        date_for_year_map[base_year + i] = code

    return date_for_year_map[year]


class PepClientBase(Client):
    """
    Base class for API wrappers for population estimates.

    """

    date_code_field = "DATE_CODE"
    default_vintage = None
    dataset = None

    @supported_years()
    def fields(self, year=None, flat=False):
        """Get fields and data types for an endpoint"""
        if year is None:
            year = self.default_year

        data = {}

        fields_url = self.definitions_url % (self.default_vintage, self.dataset)

        resp = self.session.get(fields_url)
        obj = resp.json()

        if flat:

            for key, elem in obj["variables"].items():
                if key in ["for", "in"]:
                    continue
                data[key] = "{}: {}".format(elem["concept"], elem["label"])

        else:

            data = obj["variables"]
            if "for" in data:
                data.pop("for", None)
            if "in" in data:
                data.pop("in", None)

        return data

    # pylint: disable=unused-argument
    def tables(self, year=None):
        """
        Returns a list of the data tables available from this source.
        """
        tables_url = self.groups_url % (self.default_vintage, self.dataset)

        resp = self.session.get(tables_url)

        # Pass it out
        return resp.json()["groups"]

    @lru_cache(maxsize=1024)
    def _field_type(self, field, year):
        url = self.definition_url % (self.default_vintage, self.dataset, field)
        resp = self.session.get(url)

        types = {
            "fips-for": str,
            "fips-in": str,
            "int": float_or_str,
            "float": float,
            "string": str,
        }

        if resp.status_code == 200:
            predicate_type = resp.json().get("predicateType", "string")
            return types[predicate_type]

        return str

    # pylint: disable=arguments-differ
    @retry_on_transient_error
    def query(self, fields, geo, year=None, **kwargs):
        """Returns data from endpoint"""
        if year is None:
            year = self.default_year

        fields = list_or_str(fields)

        url = self.endpoint_url % (self.default_vintage, self.dataset)

        params = {
            "get": ",".join(fields),
            "for": geo["for"],
            "key": self._key,
        }

        if year is not None:
            params[self.date_code_field] = date_for_year(
                year, base_year=year - (year % 10)
            )

        if "in" in geo:
            params["in"] = geo["in"]

        resp = self.session.get(url, params=params)

        if resp.status_code == 200:
            try:
                data = resp.json()
            except ValueError as ex:
                if "<title>Invalid Key</title>" in resp.text:
                    raise APIKeyError(" ".join(resp.text.splitlines())) from ex

                raise ex

            headers = data.pop(0)
            types = [self._field_type(header, year) for header in headers]
            results = [
                {
                    header: (cast(item) if item is not None else None)
                    for header, cast, item in zip(headers, types, d)
                }
                for d in data
            ]
            return results

        if resp.status_code == 204:
            return []

        raise CensusException(resp.text)


class IntPopulationClient(PepClientBase):
    """
    API wrapper for the 2000-2010 Intercensals population estimates.

    See
    https://www.census.gov/data/developers/data-sets/popest-popproj/popest.2000-2010_Intercensals.html
    """

    default_vintage = 2000
    date_code_field = "DATE_"
    default_year = 2000
    dataset = "pep/int_population"

    years = (
        2000,
        2001,
        2002,
        2003,
        2004,
        2005,
        2006,
        2007,
        2008,
        2009,
        2010,
    )


# pylint: disable=too-few-public-methods
class PepClient(PepClientBase):
    """
    API wrapper for Population Estimates

    See
    https://www.census.gov/data/developers/data-sets/popest-popproj/popest.Vintage_2019.html

    The API design changed in 2015, so this client only supports 2015 onward.

    TODO: Support 2013, 2014.

    """

    default_vintage = 2019
    default_year = 2019
    dataset = "pep/population"

    years = (
        2010,
        2011,
        2012,
        2013,
        2014,
        2015,
        2016,
        2017,
        2018,
        2019,
    )

    @lru_cache(maxsize=1024)
    def _field_type(self, field, year):
        if field == "POP":
            # For some reason
            # https://api.census.gov/data/2019/pep/population/variables/POP.json
            # doesn't include a data type.
            #
            # Force an integer type.
            return int

        return super()._field_type(field, year)
