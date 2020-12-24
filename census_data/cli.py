"""
Command-line interface
"""
import itertools
import os
from pathlib import Path

import click
import pandas as pd

from census_data.core import AugmentedCensus


CENSUS_API_KEY = os.environ.get("CENSUS_API_KEY")


def download_pep(raw_geotype, year, raw_csv_path):
    """Download population estimates"""
    census = AugmentedCensus(CENSUS_API_KEY)

    if year >= 2010:
        pop_resp = census.pep.get(
            (
                "NAME",
                "POP",
            ),
            {"for": f"{raw_geotype}:*"},
            year=year,
        )
    else:
        pop_resp = census.int_population.get(
            ("GEONAME", "POP"), {"for": f"{raw_geotype}:*"}, year=year
        )

    data = pd.DataFrame(pop_resp)

    data.to_csv(raw_csv_path, index=False, encoding="utf-8")


def process_pep(raw_geotype, year, raw_csv_path, processed_csv_path):
    """Process population estimates"""
    data = pd.read_csv(raw_csv_path)

    # See
    # https://api.census.gov/data/2019/pep/population/variables/DATE_CODE.json
    date_code_map = {
        1: "2010-04-01",
        2: "2010-04-01",
        3: "2010-07-01",
        4: "2011-07-01",
        5: "2012-07-01",
        6: "2013-07-01",
        7: "2014-07-01",
        8: "2015-07-01",
        9: "2016-07-01",
        10: "2017-07-01",
        11: "2018-07-01",
        12: "2019-07-01",
    }

    if year >= 2010:
        data = (
            data
            # Only use the 7/1 population estimates, even for 2010.
            # If you don't do this filtering, you get 3 estimates for
            # 2010: one for the 4/1/2010 Census population, one for
            # the 4/1/2010 population estimate base and one for the
            # 7/1/2010 population estimate.
            [lambda df: df["DATE_CODE"] >= 3]
            .copy()
            .assign(DATE_CODE=lambda df: df["DATE_CODE"].map(date_code_map))
            .rename(
                columns={
                    "NAME": "name",
                    "POP": "population",
                    "DATE_CODE": "estimate_date",
                }
            )
        )
    else:
        data = data.drop(columns=["DATE_", "state"]).rename(
            columns={"GEONAME": "state", "POP": "population"}
        )

    data.to_csv(processed_csv_path, index=False, encoding="utf-8")


@click.argument("geotype", nargs=1, required=True)
# Provide a table argument to make the API the same as census-data-downloader,
# but right now, we only support the population table.
@click.argument("table", nargs=1, required=True)
@click.option(
    "--data-dir",
    nargs=1,
    default="./",
    help="The folder where you want to download the data",
)
@click.option(
    "--year",
    default=None,
    type=int,
    help=(
        "The years of data to download. By default it gets only the latest year. "
        "Not all data are available for every year. Submit 'all' to get every "
        "year."
    ),
)
@click.option("--force", is_flag=True, help="Force the downloading of the data")
@click.command()
def download_pep_cmd(table, geotype, data_dir="./", year=None, force=False):
    """Download population estimates"""
    # TODO: Move some of this logic into a class, similar to
    # https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/geotypes.py
    if geotype not in ("counties",):
        # TODO: Support other geographies.
        raise click.ClickException(f"geotype '{geotype}' is not supported")

    raw_geotype = "county"

    year_list = list(itertools.chain(range(2008, 2020)))
    if year is None:
        year = year_list[-1]

    if year not in year_list:
        raise click.ClickException(f"Data not available for year '{year}'")

    raw_data_dir = Path(data_dir) / "raw"
    raw_csv_name = f"pep_{year}_population_{geotype}.csv"
    raw_csv_path = raw_data_dir / raw_csv_name
    processed_data_dir = Path(data_dir) / "processed"
    processed_csv_name = raw_csv_name
    processed_csv_path = processed_data_dir / processed_csv_name

    if not raw_csv_path.exists() or force:
        download_pep(raw_geotype, year, raw_csv_path)

    if not processed_csv_path.exists() or force:
        process_pep(raw_geotype, year, raw_csv_path, processed_csv_path)
