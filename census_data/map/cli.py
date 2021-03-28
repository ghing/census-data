# TODO: Remove this once
# https://github.com/datadesk/census-map-downloader/pull/24 is
# merged and
# https://github.com/datadesk/census-map-downloader/7 and
# https://github.com/datadesk/census-map-downloader/8 are
# implemented.
import click

import census_data.map


@click.group(help="Easily download U.S. census maps")
@click.option(
    "--data-dir",
    nargs=1,
    default="./",
    help="The folder where you want to download the data"
)
@click.pass_context
def cmd(ctx, data_dir="./"):
    ctx.ensure_object(dict)
    ctx.obj['data_dir'] = data_dir

@cmd.command(help="Download metropolitan/micropolitan statistical areas")
@click.pass_context
def cbsas(ctx):
    obj = census_data.map.CbsasDownloader2020(data_dir=ctx.obj['data_dir'])
    obj.run()

@cmd.command(help="Download counties")
@click.pass_context
def counties(ctx):
    obj = census_data.map.CountiesDownloader2020(data_dir=ctx.obj['data_dir'])
    obj.run()

@cmd.command(help="Download tracts")
@click.pass_context
def tracts(ctx):
    obj = census_data.map.TractsDownloader2020(data_dir=ctx.obj['data_dir'])
    obj.run()

@cmd.command(help="Download ZCTAs")
@click.pass_context
def zctas(ctx):
    obj = census_data.map.ZctasDownloader2020(data_dir=ctx.obj['data_dir'])
    obj.run()
