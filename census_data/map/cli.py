import click


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
