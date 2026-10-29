"""
Migrate Sign in with Apple users (Supabase) to the new team.

Apple user IDs ("sub") are team-scoped. After the transfer, every Apple sign-in returns a NEW sub, and Supabase matches Apple users on auth.identities.provider_id, so without this, every Apple user gets a brand-new empty account.

STEP 0 (any time): export Apple identities. In the Supabase SQL editor, run this and download the result as CSV (apple_users.csv):

    select user_id, provider_id as sub, identity_data->>'email' as email
    from auth.identities where provider = 'apple';

STEP 1 (OLD team; before the transfer, or up to 60 days after it's accepted):

    app-transfer siwa prepare apple_users.csv transfer_ids.csv \\
        --team OLD_TEAM_ID --key-id OLD_KEY_ID --key AuthKey_OLD.p8 \\
        --client-id your.bundle.id --target NEW_TEAM_ID

STEP 2 (NEW team, after accepting; hard deadline 60 days from acceptance):

    app-transfer siwa exchange transfer_ids.csv migrate.sql \\
        --team NEW_TEAM_ID --key-id NEW_KEY_ID --key AuthKey_NEW.p8 \\
        --client-id your.bundle.id

Review migrate.sql, check the conflict query at the top, then run it in Supabase.

Keys: Certificates, Identifiers & Profiles > Keys > new key with "Sign in with Apple" enabled, configured for the app's primary App ID. One per team.

The files carry each user's old sub and email: fine when one owner controls both teams and the database. Apple says never to hand them to a third-party recipient (send transfer_sub only).
"""
import csv
import json
import time
from pathlib import Path
from typing import Annotated

import jwt
import requests
import typer

APPLE = "https://appleid.apple.com"


class Creds:
    """Client secret + migration access token, refreshed before they expire."""

    def __init__(self, team, key_id, key, client_id):
        self.team, self.key_id, self.key, self.client_id = team, key_id, key.read_text(), client_id
        self.born = 0.0

    def get(self):
        if time.time() - self.born > 3000:
            now = int(time.time())
            self.secret = jwt.encode(
                {"iss": self.team, "iat": now, "exp": now + 3600, "aud": APPLE, "sub": self.client_id},
                self.key, algorithm="ES256", headers={"kid": self.key_id},
            )
            r = requests.post(f"{APPLE}/auth/token", timeout=30, data={
                "grant_type": "client_credentials", "scope": "user.migration",
                "client_id": self.client_id, "client_secret": self.secret,
            })
            if r.status_code >= 400:
                raise SystemExit(f"auth/token failed: {r.status_code} {r.text}")
            self.token, self.born = r.json()["access_token"], time.time()
        return self.token, self.secret


def migration_info(creds, payload):
    token, secret = creds.get()
    data = {**payload, "client_id": creds.client_id, "client_secret": secret}
    r = requests.post(f"{APPLE}/auth/usermigrationinfo", timeout=30, data=data,
                      headers={"Authorization": f"Bearer {token}"})
    if r.status_code >= 400:
        return None, f"{r.status_code} {r.text[:200]}"
    return r.json(), None


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def migration_sql(results):
    """SQL moving each (exported row, Apple exchange response) pair to the new team's sub."""
    updates, new_subs = [], []
    for row, res in results:
        new_sub, new_email = res["sub"], res.get("email")
        private = str(res.get("is_private_email", "")).lower() == "true"
        user, old_sub = q(row["user_id"]), q(row["sub"])
        new_subs.append(new_sub)
        patch = {"sub": new_sub, "provider_id": new_sub}
        if new_email:
            patch["email"] = new_email
        # A sign-in since the transfer may have linked the new sub to this same user
        # (same verified email); that identity is a duplicate of the one we rewrite.
        # Only while the old one still exists, so re-running the script is harmless.
        updates.append(
            f"delete from auth.identities where provider = 'apple' and user_id = {user}::uuid "
            f"and provider_id = {q(new_sub)} and exists (select 1 from auth.identities "
            f"where provider = 'apple' and user_id = {user}::uuid and provider_id = {old_sub});"
        )
        updates.append(
            f"update auth.identities set provider_id = {q(new_sub)}, "
            f"identity_data = identity_data || {q(json.dumps(patch))}::jsonb, updated_at = now() "
            f"where provider = 'apple' and user_id = {user}::uuid and provider_id = {old_sub};"
        )
        if private and new_email and new_email != row.get("email"):
            updates.append(
                f"update auth.users set email = {q(new_email)}, updated_at = now() "
                f"where id = {user}::uuid and email = {q(row.get('email', ''))};"
            )
    sql = [
        "-- 1) CONFLICT CHECK: Apple sign-ins since the transfer may already have created",
        "--    duplicate users holding these new subs. Must return 0 rows before step 2;",
        "--    otherwise merge or delete those duplicate users first. (Step 2 also fails",
        "--    as a whole on such a conflict: provider_id and email are unique.)",
    ]
    if new_subs:
        sql.append(
            "select i.user_id, i.provider_id, i.created_at from auth.identities i where i.provider = 'apple' "
            f"and i.provider_id in ({', '.join(q(s) for s in new_subs)}) and not exists ("
            "select 1 from auth.identities o where o.provider = 'apple' and o.user_id = i.user_id "
            "and o.provider_id <> i.provider_id);"
        )
    sql += ["", "-- 2) MIGRATION", "begin;", *updates, "commit;", ""]
    return "\n".join(sql)


app = typer.Typer(help=__doc__, no_args_is_help=True)

Input = Annotated[Path, typer.Argument(exists=True, dir_okay=False)]
Output = Annotated[Path, typer.Argument(dir_okay=False)]
Team = Annotated[str, typer.Option(help="Team ID of the team running this step")]
KeyId = Annotated[str, typer.Option(help="Key ID of that key")]
Key = Annotated[Path, typer.Option(exists=True, dir_okay=False, help="Sign in with Apple .p8 key of that team")]
ClientId = Annotated[str, typer.Option(help="bundle ID (or Services ID)")]


@app.command()
def prepare(input: Input, output: Output, team: Team, key_id: KeyId, key: Key, client_id: ClientId,
            target: Annotated[str, typer.Option(help="recipient Team ID")]):
    """OLD team: exported Supabase Apple users -> transfer IDs for the new team."""
    creds, rows = Creds(team, key_id, key, client_id), list(csv.DictReader(open(input)))
    out, failed = [], 0
    for i, row in enumerate(rows, 1):
        res, err = migration_info(creds, {"sub": row["sub"], "target": target})
        failed += bool(err)
        out.append({**row, "transfer_sub": (res or {}).get("transfer_sub", ""), "error": err or ""})
        print(f"[{i}/{len(rows)}] {row['user_id']}: {'ok' if res else err}")
    with open(output, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["user_id", "sub", "email", "transfer_sub", "error"])
        w.writeheader()
        w.writerows(out)
    print(f"\n{len(rows) - failed} ok, {failed} failed -> {output}. Keep this file safe; you need it after the transfer.")


@app.command()
def exchange(input: Input, output: Output, team: Team, key_id: KeyId, key: Key, client_id: ClientId):
    """NEW team: transfer IDs -> SQL moving the Supabase identities to the new subs."""
    creds, all_rows = Creds(team, key_id, key, client_id), list(csv.DictReader(open(input)))
    rows = [r for r in all_rows if r.get("transfer_sub")]
    if skipped := len(all_rows) - len(rows):
        print(f"{skipped} rows have no transfer_sub (prepare failed for them); re-run prepare to include them.")
    results, failed = [], 0
    for i, row in enumerate(rows, 1):
        res, err = migration_info(creds, {"transfer_sub": row["transfer_sub"]})
        if not res:
            failed += 1
            print(f"[{i}/{len(rows)}] {row['user_id']}: {err}")
            continue
        results.append((row, res))
        private = str(res.get("is_private_email", "")).lower() == "true"
        print(f"[{i}/{len(rows)}] {row['user_id']}: ok{' (relay email changed)' if private else ''}")
    with open(output, "w") as f:
        f.write(migration_sql(results))
    print(f"\n{len(rows) - failed} ok, {failed} failed -> {output}")


@app.command()
def secret(team: Team, key_id: KeyId, key: Key, client_id: Annotated[str, typer.Option(help="Services ID")]):
    """Supabase's Apple "Secret Key (for OAuth)": a client secret valid for Apple's maximum, 6 months."""
    now = int(time.time())
    print(jwt.encode(
        {"iss": team, "iat": now, "exp": now + 15777000, "aud": APPLE, "sub": client_id},
        key.read_text(), algorithm="ES256", headers={"kid": key_id},
    ))
    print(f"\nExpires {time.strftime('%Y-%m-%d', time.gmtime(now + 15777000))}: generate a new one before then.")
