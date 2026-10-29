"""
Audit, then clear, what blocks an App Store Connect app transfer.

Default mode is AUDIT: changes nothing and prints everything that can trip the "TestFlight Beta Testing" transfer criterion, so you can see what's still there. --apply expires builds, deletes beta groups, removes testers from this app, and CLEARS TEST INFORMATION via the API (bypasses the web UI's "field is required" validation; deletes extra languages).

Setup: Users and Access > Integrations > App Store Connect API > Team Keys, Admin role.

    export ASC_ISSUER_ID=...  ASC_KEY_ID=...  ASC_KEY_PATH=~/AuthKey_XXXX.p8
    app-transfer asc-cleanup 6473851276            # audit
    app-transfer asc-cleanup 6473851276 --apply    # fix
    app-transfer asc-cleanup 6473851276            # audit again: all empty
"""
import os
import time
from typing import Annotated

import jwt
import requests
import typer

API = "https://api.appstoreconnect.apple.com"
_key = None

LOC_FIELDS = ["description", "feedbackEmail", "marketingUrl", "privacyPolicyUrl", "tvOsPrivacyPolicy"]
REVIEW_FIELDS = ["contactFirstName", "contactLastName", "contactPhone", "contactEmail",
                 "demoAccountName", "demoAccountPassword", "notes"]


def token():
    global _key
    if _key is None:
        _key = open(os.path.expanduser(os.environ["ASC_KEY_PATH"])).read()
    now = int(time.time())
    return jwt.encode(
        {"iss": os.environ["ASC_ISSUER_ID"], "iat": now, "exp": now + 1100, "aud": "appstoreconnect-v1"},
        _key, algorithm="ES256", headers={"kid": os.environ["ASC_KEY_ID"], "typ": "JWT"},
    )


def call(method, path, quiet=False, **kw):
    url = path if path.startswith("http") else API + path
    r = requests.request(method, url, headers={"Authorization": f"Bearer {token()}"}, timeout=30, **kw)
    if r.status_code >= 400:
        if not quiet:
            print(f"      ! {method} {url.replace(API, '')} -> {r.status_code}: {r.text[:300]}")
        return False, None
    return True, (r.json() if r.content else {})


def get_one(path):
    ok, data = call("GET", path, quiet=True)
    return data.get("data") if ok and data else None


def paged(path, params=None):
    ok, data = call("GET", path, params={**(params or {}), "limit": 200})
    while ok and data:
        yield from data.get("data", [])
        nxt = data.get("links", {}).get("next")
        if not nxt:
            break
        ok, data = call("GET", nxt)


def patch(type_, id_, attrs, quiet=False):
    body = {"data": {"type": type_, "id": id_, "attributes": attrs}}
    return call("PATCH", f"/v1/{type_}/{id_}", quiet=quiet, json=body)[0]


def clear(type_, id_, fields, extra=None):
    """Try null first, then empty strings (endpoints differ in what they accept)."""
    for blank in (None, ""):
        attrs = {f: blank for f in fields}
        attrs.update(extra or {})
        if patch(type_, id_, attrs, quiet=blank is None):
            return True
    return False


def filled(attrs, keys):
    return [k for k in keys if attrs.get(k) not in (None, "", False)]


def cleanup(
    app_id: Annotated[str, typer.Argument(help="Apple ID of the app (App Information in App Store Connect)")],
    apply: Annotated[bool, typer.Option("--apply", help="Expire builds, delete beta groups and testers, clear Test Information")] = False,
    xcode_cloud: Annotated[bool, typer.Option("--xcode-cloud", help="With --apply, also delete the Xcode Cloud product")] = False,
):
    app = app_id
    print("APPLY MODE" if apply else "AUDIT MODE (no changes; add --apply to fix)")

    # 1. Builds, all platforms (the web UI shows one platform at a time)
    builds = list(paged("/v1/builds", {"filter[app]": app}))
    live = [b for b in builds if not b["attributes"].get("expired")]
    print(f"\n[builds] {len(builds)} total, {len(live)} NOT expired")
    for b in live:
        a = b["attributes"]
        print(f"  - build {a.get('version')} | {a.get('processingState')} | uploaded {(a.get('uploadedDate') or '')[:10]}")
        if apply:
            print("    expired" if patch("builds", b["id"], {"expired": True}) else "    FAILED")

    # 2. Beta groups
    groups = list(paged("/v1/betaGroups", {"filter[app]": app}))
    print(f"\n[beta groups] {len(groups)}")
    for g in groups:
        a = g["attributes"]
        print(f"  - '{a.get('name')}' ({'internal' if a.get('isInternalGroup') else 'external'})")
        if apply:
            print("    deleted" if call("DELETE", f"/v1/betaGroups/{g['id']}")[0] else "    FAILED")

    # 3. Testers still attached to this app
    testers = list(paged("/v1/betaTesters", {"filter[apps]": app}))
    print(f"\n[testers] {len(testers)}")
    for t in testers:
        a = t["attributes"]
        print(f"  - {a.get('email') or a.get('firstName') or t['id']} ({a.get('inviteType')})")
        if apply:
            ok = call("DELETE", f"/v1/betaTesters/{t['id']}/relationships/apps",
                      json={"data": [{"type": "apps", "id": app}]})[0]
            print("    removed" if ok else "    FAILED")

    # 4. Test Information
    print("\n[test information]")
    for loc in list(paged(f"/v1/apps/{app}/betaAppLocalizations")):
        a = loc["attributes"]
        f = filled(a, LOC_FIELDS)
        print(f"  - language {a.get('locale')}: {'filled: ' + ', '.join(f) if f else 'empty'}")
        if apply:
            ok = call("DELETE", f"/v1/betaAppLocalizations/{loc['id']}", quiet=True)[0]
            if ok:
                print("    language deleted")
            elif f:
                print("    cleared" if clear("betaAppLocalizations", loc["id"], LOC_FIELDS) else "    FAILED to clear")

    rd = get_one(f"/v1/apps/{app}/betaAppReviewDetail")
    if rd:
        f = filled(rd["attributes"], REVIEW_FIELDS + ["demoAccountRequired"])
        print(f"  - beta review contact / sign-in: {'filled: ' + ', '.join(f) if f else 'empty'}")
        if apply and f:
            ok = clear("betaAppReviewDetails", rd["id"], REVIEW_FIELDS, {"demoAccountRequired": False})
            print("    cleared" if ok else "    FAILED to clear")

    lic = get_one(f"/v1/apps/{app}/betaLicenseAgreement")
    if lic:
        has = bool((lic["attributes"].get("agreementText") or "").strip())
        print(f"  - license agreement: {'filled' if has else 'empty'}")
        if apply and has:
            print("    cleared" if clear("betaLicenseAgreements", lic["id"], ["agreementText"]) else "    FAILED to clear")

    # 5. Xcode Cloud
    ci = get_one(f"/v1/apps/{app}/ciProduct")
    print(f"\n[xcode cloud] {'product EXISTS' if ci else 'none'}")
    if ci and apply and xcode_cloud:
        ok = call("DELETE", f"/v1/ciProducts/{ci['id']}")[0]
        print("    deleted (workflows, history, artifacts)" if ok else "    FAILED")

    # 6. Users whose access is limited to specific apps including this one (report only)
    print("\n[users and access] app-limited users with access to this app:")
    hits = 0
    for u in list(paged("/v1/users")):
        if u["attributes"].get("allAppsVisible"):
            continue
        if any(x["id"] == app for x in paged(f"/v1/users/{u['id']}/visibleApps")):
            hits += 1
            print(f"  - {u['attributes'].get('username')}  -> remove this app from their access in the UI")
    if not hits:
        print("  none")

    if apply:
        print("\nDone. Re-run without --apply to verify, then close and restart the Transfer App flow.")

