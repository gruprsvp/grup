# app-transfer

CLI helpers for moving an app to another App Store Connect team. The step-by-step
runbook for GRUP is [`docs/APP_TRANSFER.md`](../../docs/APP_TRANSFER.md).

| Command | What it does |
|---|---|
| `app-transfer asc-cleanup APP_ID [--apply] [--xcode-cloud]` | Lists, and with `--apply` clears, the TestFlight data that blocks App Store Connect's transfer check: builds, beta groups, testers, Test Information, the Xcode Cloud product. |
| `app-transfer siwa prepare` / `siwa exchange` | Moves Sign in with Apple users in Supabase to the new team's user IDs. `prepare` runs with the old team's key, `exchange` with the new team's key and writes the SQL to run. |
| `app-transfer siwa secret [--supabase-project REF]` | Prints the Apple client secret Supabase needs for web/Android sign-in ("Secret Key (for OAuth)"), valid 6 months. With `--supabase-project` it sets it in that project instead (Management API, `SUPABASE_ACCESS_TOKEN`); `.github/workflows/siwa-secret.yaml` does this monthly. |

`app-transfer <command> --help` prints each command's full instructions.

## Running

No install needed. [uv](https://docs.astral.sh/uv/) handles Python and the dependencies:

```sh
# from the repo root
uv run --project tools/app-transfer app-transfer --help

# or from anywhere, without a project venv
uvx --from ./tools/app-transfer app-transfer --help

# tests
cd tools/app-transfer && uv run pytest
```

The migration files (`*.csv`, `*.sql`) and keys (`*.p8`) are gitignored in this folder.
They hold Apple user IDs and emails, so delete them once the migration is verified.

## Publishing later

This is already a normal package (`uv_build`, `[project.scripts]`), so `uv build && uv publish`
works as it is. Before publishing:

- Pick a name that's free on PyPI.
- The `siwa` command assumes one owner controls both teams and the database: its files carry the
  old team's user IDs and emails. If a third party receives the app, Apple says to send them only
  `transfer_sub`. A public version should split `prepare`'s output into two files: one the sender
  keeps, and one with only `user_id` and `transfer_sub` that goes to the recipient.
- `siwa` writes Supabase SQL (`auth.identities`). Other backends would need their own SQL writer
  next to `migration_sql`.
- The CLI is [Typer](https://typer.tiangolo.com). A new command is a function registered in
  `cli.py` (`app.command(...)`), or a module with its own `typer.Typer()` added there with
  `app.add_typer(...)`, as `siwa` does.
