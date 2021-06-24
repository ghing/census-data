"""
Geography-level downloader classes that expand on the ones offered by
the `census-data-downloader` package.

See
https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/geotypes.py

"""
import collections
import logging
import time

from census_data_downloader.core.geotypes import BaseGeoTypeDownloader
import numpy as np
import pandas as pd
from us import states

from census_data.core import AugmentedCensus


logger = logging.getLogger(__name__)


class BlockGroupsDownloader(BaseGeoTypeDownloader):
    """
    Download raw data at the block group level
    """

    slug = "blockgroups"
    raw_geotype = "blockgroup"

    def __init__(self, config, year):
        super().__init__(config, year)

        # Set additional CSV names
        self.raw_county_fips_csv_name = (
            f"{self.config.source}_{self.year}_fips_counties.csv"
        )
        self.raw_county_fips_csv_path = self.config.raw_data_dir.joinpath(
            self.raw_county_fips_csv_name
        )

    def get_raw_data(self):
        """
        Returns the data we want from the API.
        """
        raise NotImplementedError(
            "This method is not implemented because fetching block group data "
            "requires making multiple API requests, one for each county"
        )

    # pylint: disable=no-self-use
    def create_geoid(self, row):
        """Create the unique identifier we prefer for a blockgroup record."""
        return row["state"] + row["county"] + row["tract"] + row["block group"]

    def download_county_fips(self):
        """
        Download a CSV of FIPS codes for every county in the U.S.

        Returns path to CSV.
        """
        # Skip hitting the API if we've already got the file, as long as we're not forcing it.
        if self.raw_county_fips_csv_path.exists() and not self.config.force:
            logger.debug("Raw CSV already exists at %s", self.raw_county_fips_csv_path)
            return self.raw_csv_path

        county_fips = pd.DataFrame(
            self.api.get(
                "NAME", geo={"for": "county:*", "in": "state:*"}, year=self.year
            )
        )

        county_fips.to_csv(self.raw_county_fips_csv_path, index=False, encoding="utf-8")

        # Pause to be polite to the API.
        time.sleep(0.5)

        return self.raw_county_fips_csv_path

    def get_raw_county_blockgroups_csv_name(self, state_fips, county_fips):
        """Returns the raw filename for a particular county"""
        return (
            f"{self.config.source}_{self.year}_{self.config.PROCESSED_TABLE_NAME}_{self.slug}"
            f"_{state_fips}_{county_fips}.csv"
        )

    def download_county_blockgroups(self, state_fips, county_fips):
        """
        Download blockgroup-level ACS data and save to a CSV file.

        Returns the path of the CSV file.

        """
        raw_county_blockgroups_csv_name = self.get_raw_county_blockgroups_csv_name(
            state_fips, county_fips
        )
        raw_county_blockgroups_csv_path = self.config.raw_data_dir.joinpath(
            raw_county_blockgroups_csv_name
        )

        # Skip hitting the API if we've already got the file, as long as we're not forcing it.
        if raw_county_blockgroups_csv_path.exists() and not self.config.force:
            logger.debug(
                "Raw CSV already exists at %s", raw_county_blockgroups_csv_path
            )
            return raw_county_blockgroups_csv_path

        data = self.api.state_county_blockgroup(
            self.api_fields,
            state_fips=state_fips,
            county_fips=county_fips,
            blockgroup="*",
            year=self.year,
        )

        # Convert it to a dataframe
        df = pd.DataFrame.from_records(data)

        # Write it to disk
        logger.debug("Writing raw ACS table to %s", raw_county_blockgroups_csv_path)
        df.to_csv(raw_county_blockgroups_csv_path, index=False, encoding="utf-8")

        # Pause to be polite to the API.
        time.sleep(0.5)

        return raw_county_blockgroups_csv_path

    def download(self):
        """
        Downloads raw data from the Census API.

        Returns path to CSV.
        """
        self.download_county_fips()
        county_fips = pd.read_csv(
            self.raw_county_fips_csv_path,
            dtype={
                "state": "str",
                "county": "str",
            },
        )

        # Define a function that can be called on every row, i.e. for every
        # county.
        def download_and_save_from_row(row):
            self.download_county_blockgroups(row["state"], row["county"])

        county_fips.apply(download_and_save_from_row, axis=1)

    def process(self):
        """
        Converts the raw file to be used by humans.
        Returns path to CSV.
        """
        # Figure out where to write it
        if self.processed_csv_path.exists() and not self.config.force:
            logger.debug("Processed CSV already exists at %s", self.processed_csv_path)
            return self.processed_csv_path

        county_fips = pd.read_csv(
            self.raw_county_fips_csv_path,
            dtype={
                "state": "str",
                "county": "str",
            },
        )

        # Define a function that can be called on every row, i.e. for every
        # county.
        def get_raw_path(row):
            raw_county_blockgroups_csv_name = self.get_raw_county_blockgroups_csv_name(
                row["state"], row["county"]
            )
            return self.config.raw_data_dir.joinpath(raw_county_blockgroups_csv_name)

        raw_paths = county_fips.apply(get_raw_path, axis=1)

        # Combine the processed files into a single DataFrame
        frames = []

        for raw_path in raw_paths:
            county_df = pd.read_csv(raw_path, dtype="str")
            frames.append(county_df)

        df = pd.concat(frames)

        # Get the crosswalk between raw and processed field names
        field_name_mapper = self.get_raw_field_map()

        # Cast numbers to floats
        for field in field_name_mapper.keys():
            if "_" in field and (field.endswith("E") or field.endswith("M")):
                df[field] = df[field].astype(np.float64)

        # Rename fields with humanized names
        df.rename(columns=field_name_mapper, inplace=True)

        # Add a combined GEOID column with a Census unique identifer
        df["geoid"] = df.apply(self.create_geoid, axis=1)

        if hasattr(self.config, "process"):
            df = self.config.process(df)

        # Write it out
        logger.debug("Writing CSV to %s", self.processed_csv_path)
        df.set_index(["geoid", "name"]).to_csv(
            self.processed_csv_path, index=True, encoding="utf-8"
        )

        return self.processed_csv_path


class NonACSBaseGeoTypeDownloader(BaseGeoTypeDownloader):
    """
    Base class for downloading raw data from the Census API for non-ACS enpoints.

    Expects a TableConfig instance and year as input.

    """

    # pylint: disable=too-many-instance-attributes
    YEAR_LIST = [
        2020,
    ] + BaseGeoTypeDownloader.YEAR_LIST

    slug = "nationwide"
    raw_geotype = "us"

    def __init__(self, config, year):
        """
        Constructor

        This completely overrides the base class as it provides a hook for using a custom
        API client class.

        """
        # pylint: disable=super-init-not-called
        # Set the input variables
        self.config = config
        self.year = year

        # Connect to the Census API for the provided source
        self.api = self.get_api_client(year=year)

        # Validate the year
        if self.year not in self.YEAR_LIST:
            raise NotImplementedError(
                "Census API does not support this year for this geotype"
            )

        # Validate the geotype
        valid_geotype_slugs = [gt.replace("_", "") for gt in self.config.GEOTYPE_LIST]
        if self.slug not in valid_geotype_slugs:
            raise NotImplementedError(
                f"Data only available for {', '.join(self.config.GEOTYPE_LIST)}"
            )

        # Prepare raw field list
        self.api_fields = self.get_api_fields()

        # Set the CSV names
        self.raw_csv_name = f"{self.config.source}_{self.year}_{self.config.PROCESSED_TABLE_NAME}_{self.slug}.csv"  # pylint: disable=line-too-long
        self.raw_csv_path = self.config.raw_data_dir.joinpath(self.raw_csv_name)
        self.processed_csv_name = f"{self.config.source}_{self.year}_{self.config.PROCESSED_TABLE_NAME}_{self.slug}.csv"  # pylint: disable=line-too-long
        self.processed_csv_path = self.config.processed_data_dir.joinpath(
            self.processed_csv_name
        )

    def get_api_client(self, year):
        """Returns a Census API client"""
        return getattr(
            AugmentedCensus(self.config.CENSUS_API_KEY, year=year), self.config.source
        )

    def get_raw_field_map(self):
        """
        Returns a crosswalk between the raw API fields and our processed humanized field names.

        Unlike the ACS, these tables won't have table names or estimate or
        annotation suffixes.

        """
        field_map = collections.OrderedDict({"NAME": "name"})
        try:
            raw_field_crosswalk = self.config.get_raw_field_crosswalk(self.year)

        except AttributeError:
            raw_field_crosswalk = self.config.RAW_FIELD_CROSSWALK

        for field_id, field_name in raw_field_crosswalk.items():
            field_map[field_id] = field_name

        return field_map

    def get_field_type_map(self):
        """
        Returns a map of type definitions for fields.

        If present, it takes these from the `get_field_types()` method of the
        table configuration.

        Otherwise, it assumes an ACS table and uses the raw field suffixes to
        determine numeric fields.

        """
        field_type_map = {}

        if hasattr(self.config, "get_field_types"):
            # The table configuration class has the field types defined.
            # Use these.
            for field_id, field_type in self.config.get_field_types(self.year).items():
                field_type_map[field_id] = field_type

            return field_type_map

        # No field types are defined, use the default behavior for ACS tab
        # Default behavior for ACS tables, the most common use case
        for field in self.config.RAW_FIELD_CROSSWALK.items():
            if "_" in field and (field.endswith("E") or field.endswith("M")):
                field_type_map[field] = pd.np.float64

        return field_type_map

    def process(self):
        """
        Converts the raw file to be used by humans.
        Returns path to CSV.
        """
        # Figure out where to write it
        if self.processed_csv_path.exists() and not self.config.force:
            logger.debug("Processed CSV already exists at %s", self.processed_csv_path)
            return self.processed_csv_path

        # Read in the raw CSV of data from the ACS
        df = pd.read_csv(self.raw_csv_path, dtype=str)

        # Get the crosswalk between raw and processed field names
        field_name_mapper = self.get_raw_field_map()

        # Get the field types
        field_types = self.get_field_type_map()

        # Cast numbers to floats and do other type conversions
        for field, field_type in field_types.items():
            df[field] = df[field].astype(field_type)

        # Rename fields with humanized names
        df.rename(columns=field_name_mapper, inplace=True)

        # Add a combined GEOID column with a Census unique identifer
        df["geoid"] = df.apply(self.create_geoid, axis=1)

        if hasattr(self.config, "process"):
            df = self.config.process(df)

        # Write it out
        logger.debug("Writing CSV to %s", self.processed_csv_path)
        df.set_index(["geoid", "name"]).to_csv(
            self.processed_csv_path, index=True, encoding="utf-8"
        )
        return self.processed_csv_path


class NonACSBaseStateLevelGeoTypeDownloader(NonACSBaseGeoTypeDownloader):
    """
    Download and stitch together raw data the Census API only provides state by state.
    """

    def get_api_filter(self, state):
        """
        Returns an API filter to retrieve the correct data for the provided state.
        """
        return {"for": f"{self.raw_geotype}:*", "in": f"state: {state.fips}"}

    def get_raw_data(self):
        """
        Returns the data we want from the API.
        """
        api_data = []
        for state in states.STATES:
            logger.debug(
                "Downloading %s %s data from the raw %s table in %s for the %d %s count",
                self.slug,
                self.config.PROCESSED_TABLE_NAME,
                self.config.RAW_TABLE_NAME,
                state,
                self.year,
                self.config.source,
            )
            # Get the raw data
            api_filter = self.get_api_filter(state)
            state_data = self.api.get(self.api_fields, api_filter)
            api_data.extend(state_data)
        return api_data

    def create_geoid(self, row):
        return row["state"] + row[self.raw_geotype]


class NonACSTractsDownloader(NonACSBaseStateLevelGeoTypeDownloader):
    """
    Download raw data at the tract level.
    """

    slug = "tracts"
    raw_geotype = "tract"

    def create_geoid(self, row):
        return row["state"] + row["county"] + row[self.raw_geotype]
