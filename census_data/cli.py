#!/usr/bin/env python
"""
Command-line interface
"""
import itertools
import os
from pathlib import Path

# We'll use some of the field name crosswalks from this package in our code.
from census_data_downloader.tables import TABLE_LIST
import click
import pandas as pd

from census_data.core import AugmentedCensus
from census_data.core.geotypes import BlockGroupsDownloader, NonACSTractsDownloader
from census_data.tables import (  # pylint:disable=unused-import
    # HACK: Import these classes so they get registered in TABLE_LIST
    HouseholdsGrandparentsLivingWithGrandchildren,
    # HACK: These classes are used explicitly, with logic in the command to
    # select which one to use.
    ResponseRate2020Downloader,
    ResponseRate2010Downloader,
)

CENSUS_API_KEY = os.environ.get("CENSUS_API_KEY")
TABLES_LOOKUP = dict((k.PROCESSED_TABLE_NAME, k) for k in TABLE_LIST)


# TODO: Replace this with a class-based approach to integrate all API-based
# downloads into a single command-line tool, similar to the one provided by
# `census-data-downloader`. This could ultimately enable pushing this
# functionality upstream to that package.
#
# See https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/geotypes.py pylint:disable=line-too-long
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


# Accept a raw_geotype argument to provide a consistent API with the download
# phase, but we don't need to use that variable in this function.
# pylint: disable=unused-argument
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
    # TODO: Support other tables.
    if table != "population":
        raise click.ClickException("Currently only the population table is supported")

    if geotype == "counties":
        raw_geotype = "county"

    elif geotype == "states":
        raw_geotype = "state"

    else:
        # TODO: Support other geographies.
        raise click.ClickException(f"geotype '{geotype}' is not supported")

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
        "Not all data are available for every year. Submit 'all' to get every year."
    ),
)
@click.option("--force", is_flag=True, help="Force the downloading of the data")
def download_acs5_blockgroup(table, data_dir="./", year=None, force=False):
    """
    Download ACS 5-year estimates for block groups

    This functionality is not supported by the `census-data-downloader` tool.

    """
    # HACK: Use some clases from `census_data_downlaoder` to get the list of
    # fields we'll request from the API.
    table_config_klass = TABLES_LOOKUP[table]
    table_config = table_config_klass(years=[year], data_dir=data_dir, force=force)
    # HACK: Add blockgroups to the supported geotype list
    table_config.GEOTYPE_LIST = list(table_config.GEOTYPE_LIST) + ["blockgroups"]
    downloader = BlockGroupsDownloader(table_config, year)
    downloader.download()
    downloader.process()

@click.option(
    "--data-dir",
    nargs=1,
    default="./",
    help="The folder where you want to download the data",
)
@click.option(
    "--year",
    default=2020,
    type=int,
    help=(
        "The years of data to download. By default it gets only the latest year. "
        "Not all data are available for every year. Submit 'all' to get every year."
    ),
)
@click.option("--force", is_flag=True, help="Force the downloading of the data")
@click.command()
def download_responserate_tract(data_dir="./", year=None, force=False):
    """
    Download Decennial Census Self-Response Rates

    This functionality is not supported by the `census-data-downloader` tool.

    """
    # HACK: The 2020 and 2010 response rate tables are similar but have
    # different numbers of fields, so there are two separate classes.
    if year == 2020:
        table_config_klass = ResponseRate2020Downloader

    elif year == 2010:
        table_config_klass = ResponseRate2010Downloader

    table_config = table_config_klass(years=[year], data_dir=data_dir, force=force)
    downloader = NonACSTractsDownloader(table_config, year)
    downloader.download()
    downloader.process()

# Below this line is copied from census_data_downloader.cli
# This essentially creates a parallel version of the `censusdatadownloader`
# command with custom tables added.
@click.group(help="Download Census data and reformat it for humans")
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
        "The years of data to download. By default it gets only the latest "
        "year. Not all data are available for every year. Submit 'all' to get "
        "every year."
    ),
)
@click.option("--force", is_flag=True, help="Force the downloading of the data")
@click.pass_context
def cmd(ctx, table, data_dir="./", year=None, force=False):
    # pylint: disable=missing-function-docstring
    ctx.ensure_object(dict)
    ctx.obj["table"] = table
    ctx.obj["data_dir"] = data_dir
    ctx.obj["year"] = year
    ctx.obj["force"] = force
    try:
        klass = TABLES_LOOKUP[ctx.obj["table"]]
    except KeyError:
        raise click.ClickException("Table not found")  # pylint:disable=raise-missing-from
    ctx.obj["klass"] = klass
    ctx.obj["runner"] = klass(data_dir=data_dir, years=year, force=force)


@cmd.command(help="Download nationwide data")
@click.pass_context
def nationwide(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_nationwide()


@cmd.command(help="Download divisions")
@click.pass_context
def divisions(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_divisions()


@cmd.command(help="Download regions")
@click.pass_context
def regions(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_regions()


@cmd.command(help="Download states")
@click.pass_context
def states(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_states()


@cmd.command(help="Download Congressional districts")
@click.pass_context
def congressionaldistricts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_congressional_districts()


@cmd.command(help="Download statehouse districts")
@click.pass_context
def statelegislativedistricts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_state_legislative_upper_districts()
    ctx.obj["runner"].download_state_legislative_lower_districts()


@cmd.command(help="Download counties in all states")
@click.pass_context
def counties(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_counties()


@cmd.command(help="Download Census-designated places")
@click.pass_context
def places(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_places()


@cmd.command(help="Download urban areas")
@click.pass_context
def urbanareas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_urban_areas()


@cmd.command(help="Download metropolitan statistical areas")
@click.pass_context
def msas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_msas()


@cmd.command(help="Download combined statistical areas")
@click.pass_context
def csas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_csas()


@cmd.command(help="Download public use microdata areas")
@click.pass_context
def pumas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_pumas()


@cmd.command(help="Download New England city and town areas")
@click.pass_context
def nectas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_nectas()


@cmd.command(help="Download combined New England city and town areas")
@click.pass_context
def cnectas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_cnectas()


@cmd.command(
    help="Download American Indian, Alaska Native and Native Hawaiian homelands"
)
@click.pass_context
def aiannhhomelands(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_aiannh_homelands()


@cmd.command(help="Download Census tracts")
@click.pass_context
def tracts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_tracts()


@cmd.command(help="Download ZIP Code tabulation areas")
@click.pass_context
def zctas(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_zctas()


@cmd.command(help="Download unified school districts")
@click.pass_context
def unifiedschooldistricts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_unified_school_districts()


@cmd.command(help="Download elementary school districts")
@click.pass_context
def elementaryschooldistricts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_elementary_school_districts()


@cmd.command(help="Download secondary school districts")
@click.pass_context
def secondaryschooldistricts(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_secondary_school_districts()


@cmd.command(help="Download Alaska Native regional corporations")
@click.pass_context
def alaskanative(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_alaska_native()


@cmd.command(help="Download county subdivisions")
@click.pass_context
def countysubdivision(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_county_subdivision()


@cmd.command(help="Download everything from everywhere")
@click.pass_context
def everything(ctx):
    # pylint: disable=missing-function-docstring
    ctx.obj["runner"].download_everything()
