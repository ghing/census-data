#!/usr/bin/env python

"""Load 2020 self-response rate tract relationship file into a SQL database"""

import sqlite3
from zipfile import ZipFile

import click
import pandas as pd


@click.command()
@click.argument(
    "rel_path",
    type=click.Path(exists=True),
)
@click.argument(
    "db_path",
    type=click.Path(exists=True),
)
def load_responserate_tract_rel(rel_path, db_path):
    """Load 2020 self-response rate tract relationship file into a SQL database"""
    with ZipFile(rel_path) as zipf:
        with zipf.open("rr_tract_rel.txt") as relf:
            rel_data = pd.read_csv(
                relf,
                dtype={
                    "STATEFP10": "str",
                    "COUNTYFP10": "str",
                    "TRACTCE10": "str",
                    "GEOID10": "str",
                    "AREA10": "float64",
                    "AREALAND10": "float64",
                    "STATEFP20": "str",
                    "COUNTYFP20": "str",
                    "TRACTCE20": "str",
                    "GEOID20": "str",
                    "AREA20": "float64",
                    "AREALAND20": "float64",
                    "AREAPT": "float64",
                    "AREALANDPT": "float64",
                    "AREAPCT10PT": "float64",
                    "AREALANDPCT10PT": "float64",
                    "AREAPCT20PT": "float64",
                    "AREALANDPCT20PT": "float64",
                    "HUCURPCT_T10": "float64",
                    "HU10PCT_T10": "float64",
                    "HUCURPCT_T20": "float64",
                    "HU10PCT_T20": "float64",
                },
            )

    con = sqlite3.connect(db_path)
    rel_data.to_sql("rr_tract_rel", con=con, if_exists="replace")


if __name__ == "__main__":
    load_responserate_tract_rel()  # pylint:disable=no-value-for-parameter
