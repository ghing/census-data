"""
Geography-level downloader classes that expand on the ones offered by
the `census-data-downloader` package.

See
https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/geotypes.py

"""
import logging
import time

from census_data_downloader.core.geotypes import BaseGeoTypeDownloader
import numpy as np
import pandas as pd


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
