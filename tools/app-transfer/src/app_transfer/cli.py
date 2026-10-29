import typer

from . import asc, siwa

app = typer.Typer(help="Helpers for moving an app between developer accounts.", no_args_is_help=True)
app.command("asc-cleanup", help=asc.__doc__)(asc.cleanup)
app.add_typer(siwa.app, name="siwa")


def main():
    app()


if __name__ == "__main__":
    main()
