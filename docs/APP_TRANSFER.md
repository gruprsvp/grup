# Moving GRUP to another developer account

How to move the app (bundle and package `is.giorgio.app.parousia`) from one Google Play
developer account and one Apple developer team to new ones, without losing users.

| Store | State |
|---|---|
| Google Play | Transferred. Some follow-ups remain: see [Google Play](#google-play). |
| App Store | Not started. Blocked by the TestFlight check (see [Before the transfer](#1-before-the-transfer)). |

Tooling lives in [`tools/app-transfer`](../tools/app-transfer/README.md). It is a uv project with one CLI.
Run it from the repo root:

```sh
uv run --project tools/app-transfer app-transfer --help
```

Write the migration files (`*.csv`, `*.sql`) and keys (`*.p8`) inside `tools/app-transfer/`,
where they are gitignored, or anywhere outside the repo. They hold Apple user IDs and emails.

Sources: Apple's [Transferring your apps and users to another team](https://developer.apple.com/documentation/signinwithapple/transferring-your-apps-and-users-to-another-team),
[Bringing new apps and users into your team](https://developer.apple.com/documentation/signinwithapple/bringing-new-apps-and-users-into-your-team),
[TN3159](https://developer.apple.com/documentation/technotes/tn3159-migrating-sign-in-with-apple-users-for-an-app-transfer),
[App Store Connect: Overview of app transfer](https://developer.apple.com/help/app-store-connect/transfer-an-app/overview-of-app-transfer),
and Google's [Transfer apps to a different developer account](https://support.google.com/googleplay/android-developer/answer/6230247).

---

## Google Play

Users, ratings, reviews, store listings, content ratings, policy declarations and the
**app signing and upload keys** move with the app. Google lists what does *not* move. Here is
what that means for GRUP, most important first.

### 1. CI's service account (do this first)

Google: *"Permissions and linkage settings for integrated services do not transfer
automatically."* The service account in the `SERVICE_ACCOUNT_JSON` secret has no access to the
app in the new account. Two things use it:

- `build.yaml`, which uploads the bundle. The next merge to `main` fails at the Android upload.
- `store-metadata.yaml`, the `fastlane supply` job.

Fix: in the **new** Play Console account, open Users and permissions and click Invite new users.
Enter the `client_email` from the service-account JSON. Under App permissions, add GRUP and grant
at least these:

- Release to production, exclude devices, and use Play App Signing
- Release apps to testing tracks
- Manage testing tracks and edit tester lists
- Manage store presence

To check it, run the **Store metadata** workflow by hand (it has `workflow_dispatch`) and confirm
that the Android job passes.

### 2. Testers

*"Test groups (open, closed, internal test, and internal sharing) do not transfer."* Recreate the
internal and closed testing tester lists (email lists or Google Groups) in the new account, and
attach them to their tracks again.

### 3. Signing, App Links, Google sign-in: nothing to do, but check

- The app signing key moves with the app, so `web/.well-known/assetlinks.json` stays valid. To
  check: open Test and release → App integrity → App signing in the new account. The SHA-256
  of the **app signing key** must equal the fingerprint in `assetlinks.json` (`02:A1:58:…:54:1B`).
- The upload key moves too, so the `UPLOAD_KEYSTORE_B64` and `KEY_PROPERTIES` secrets keep working.
- Google sign-in uses OAuth clients in Google Cloud project `655087059227` (`assets/env/*.json`).
  They live in Google Cloud, not in Play, so the transfer leaves them untouched. If that project
  is owned by the old account's Google identity and you mean to close that account, first add the
  new owner as Owner in IAM. Google's page says the same for Cloud projects.

### 4. Reports from the old account

*"Bulk export reports, estimated sales reports, and earnings reports do not transfer."* Download
any you want to keep from the old account before you close it. The app is free, so there are no
orders or refunds to handle.

### 5. Later, and not applicable

- **Payments profile**: needed in the new account only once Google Play Billing ships (the
  paid-plans work). The app has no in-app products today.
- **N/A, checked**: Firebase (not used), ad SDKs (none), Play Games (none), Google Analytics
  (PostHog is used instead), managed private apps.
- **Old account**: if you close it, Google refunds its registration fee on request.

---

## App Store

The order matters here, and Sign in with Apple has a hard 60-day deadline.

### Why Sign in with Apple needs a migration

Apple's user ID (`sub`) is **different for each team**. Once the new team owns the app, every Apple
sign-in carries the new team's `sub`. Private relay addresses (`…@privaterelay.appleid.com`)
change as well. Supabase finds Apple users by `auth.identities.provider_id` (= `sub`). Without a
migration, every Apple user lands in a **new, empty account**, or, if their real email is shared
and verified, gets a second Apple identity linked to their account.

Apple bridges the two IDs with a **transfer ID**:

1. The **old** team turns each `sub` into a `transfer_sub` (`siwa prepare`). It can do this
   before the transfer, or up to 60 days after the transfer is accepted.
2. The **new** team turns each `transfer_sub` into its own `sub` and relay email (`siwa exchange`).
   It must do this **within 60 days of accepting**.

After 60 days Apple's migration endpoint stops working for both teams. The only way to recover
is to transfer the app back to the old team and forward again (TN3159). New ID tokens also carry
a `transfer_sub` claim for 60 days, but Supabase ignores it, so we can't rely on it.

### 1. Before the transfer

Apple's [criteria](https://developer.apple.com/help/app-store-connect/transfer-an-app/app-transfer-criteria)
(App Store Connect → the app → App Information → Transfer App runs the checks):

- [ ] Neither account is in a pending or changing state, and *"both parties must have accepted the
      latest version of their paid and free agreements"* (App Store Connect → Business). Apple
      doesn't say whether the receiving team needs the Paid Apps agreement for a free app. If the
      check fails on agreements, look there first.
- [ ] At least one version has been released, the app isn't on pre-order, and no version is
      Processing for Distribution, Waiting for Review, In Review, Accepted, Pending Developer
      Release or Pending Apple Release.
- [ ] In-app purchase product IDs don't clash with IDs in the receiving account. There are none today.
- [ ] Back up anything you want from the old team: the transferor loses the app's App Analytics
      (sales and payments up to the transfer stay visible). Webhooks carry over unless you
      delete them first. N/A for GRUP: auto-renewable subscriptions, Game Center, Mac Catalyst,
      alternative marketplaces, promo codes.
- [ ] **TestFlight**: Apple's [overview](https://developer.apple.com/help/app-store-connect/transfer-an-app/overview-of-app-transfer)
      says to *"remove all builds and testers, and clear each Test Information field for every
      localization"*, and to remove the app's Xcode Cloud data. Run the cleanup with the **old** team's App Store Connect
      API key (Users and Access → Integrations → Team Keys, Admin role):

      ```sh
      export ASC_ISSUER_ID=…  ASC_KEY_ID=…  ASC_KEY_PATH=~/AuthKey_XXXX.p8
      uv run --project tools/app-transfer app-transfer asc-cleanup 6473851276            # audit
      uv run --project tools/app-transfer app-transfer asc-cleanup 6473851276 --apply    # fix
      uv run --project tools/app-transfer app-transfer asc-cleanup 6473851276            # everything should read empty
      ```

      Add `--xcode-cloud` to `--apply` to delete the Xcode Cloud product as well (workflows and
      build history), as the transfer requires. The new team sets it up again afterwards.

      **Known blocker:** the four Beta App Review contact fields (first name, last name, phone,
      email) can't be emptied. The API answers `409`, and the web UI insists they are required.
      If the transfer check still flags TestFlight after everything else reads empty, only Apple
      can clear it. Contact Developer Support (App Store Connect → Contact Us) and give them:
      - the app's Apple ID, `6473851276`
      - the audit output, showing everything else empty
      - the `409` response body
- [ ] **Sign in with Apple grouping.** In Certificates, Identifiers & Profiles → Identifiers, open
      `is.giorgio.app.parousia` → Sign in with Apple → Configure. If it's grouped with another
      App ID, ungroup it, because App Store Connect refuses to transfer grouped apps. The web
      **Services ID** used by Supabase needs no ungrouping: it moves automatically with its primary
      App ID.
- [ ] Note the **Services ID** (Supabase → Authentication → Providers → Apple → Client IDs: the
      entry that isn't the bundle ID). You'll need it for the new secret.

### 2. Old team: prepare the transfer IDs

Do this before you start the transfer. Apple allows it up to 60 days after acceptance, but doing
it first means the old team's access isn't on the critical path.

1. In the Supabase SQL editor (production), run this and download the result as
   `tools/app-transfer/apple_users.csv`:

   ```sql
   select user_id, provider_id as sub, identity_data->>'email' as email
   from auth.identities where provider = 'apple';
   ```

2. Find an old-team key with Sign in with Apple enabled (Certificates, Identifiers & Profiles →
   Keys). The one that signed Supabase's current Apple secret works. You need its `.p8` file and
   Key ID.

3. Run `prepare`:

   ```sh
   cd tools/app-transfer
   uv run app-transfer siwa prepare apple_users.csv transfer_ids.csv \
       --team D5Q258YWK7 --key-id OLD_KEY_ID --key AuthKey_OLD.p8 \
       --client-id is.giorgio.app.parousia --target NEW_TEAM_ID
   ```

   Every row should say `ok`. Failed rows keep their error in `transfer_ids.csv`, so fix the cause
   and re-run (transfer IDs are stable, so re-running is harmless). Keep `transfer_ids.csv`: the
   next step needs it.

4. Start the transfer: App Store Connect → the app → App Information → Transfer App. Enter the
   recipient's Team ID and the Apple Account of its Account Holder.

### 3. Transfer day (new team)

Do these in one sitting, in this order. Any Apple sign-in between accepting and running the SQL
gets the new `sub` before Supabase knows about it.

1. **Just before accepting**, turn off Supabase → Authentication → Providers → **Apple**. Users
   already signed in stay signed in, because Supabase sessions don't depend on Apple. New Apple
   sign-ins fail for a few minutes instead of creating duplicate accounts.
2. **Accept** the transfer (Account Holder of the new team). The 60-day clock starts now.
3. **Create the new team's key.** Certificates, Identifiers & Profiles → Keys → +, enable Sign in
   with Apple, and configure it with the primary App ID `is.giorgio.app.parousia` (now in this
   team). Download the `.p8` file, which you can only do once, and note the Key ID.
4. **Exchange** the transfer IDs:

   ```sh
   uv run app-transfer siwa exchange transfer_ids.csv migrate.sql \
       --team NEW_TEAM_ID --key-id NEW_KEY_ID --key AuthKey_NEW.p8 \
       --client-id is.giorgio.app.parousia
   ```

5. **Review `migrate.sql`** and run it in the Supabase SQL editor in two parts:
   1. **Conflict check** (the `select` at the top). It must return 0 rows. A row means someone
      signed in with Apple after the transfer and got a separate account holding the new `sub`.
      Merge or delete that duplicate user, then run the check again. (A user whose new identity
      Supabase linked to their own existing account isn't a conflict: the migration removes that
      extra identity itself.)
   2. **Migration** (`begin; … commit;`). It runs in one transaction. Each user's Apple identity
      gets the new `sub` and, for private-relay users, the new relay email (on `auth.users` too).
      If anything clashes, the whole transaction fails and changes nothing. Running it a second
      time does nothing.
6. **New Supabase secret.** The current "Secret Key (for OAuth)" was signed by the old team, so
   web and Android Apple sign-in fail until you replace it. Native iOS doesn't use it.

   ```sh
   uv run app-transfer siwa secret --team NEW_TEAM_ID --key-id NEW_KEY_ID \
       --key AuthKey_NEW.p8 --client-id YOUR_SERVICES_ID
   ```

   Paste the output into Supabase → Apple → Secret Key (for OAuth). Leave Client IDs as they are,
   because the bundle ID and the Services ID keep their identifiers. The secret expires after
   6 months; the `siwa-secret.yaml` workflow renews it monthly, so **replace its GitHub secrets
   with the new team's** (`APPLE_SIWA_KEY` = the `.p8` contents, `APPLE_SIWA_KEY_ID`,
   `APPLE_TEAM_ID`), or its next run puts back an old-team secret.
7. **Turn the Apple provider back on.**
8. **Check it worked.**
   - Sign in with an existing Apple account on iOS (native) and on the web. Each must land in the
     existing account with its groups, not an empty one.
   - Check that no new Apple users appeared:

     ```sql
     select u.id, u.email, u.created_at from auth.users u
     join auth.identities i on i.user_id = u.id and i.provider = 'apple'
     where u.created_at > 'ACCEPTED_AT'::timestamptz;
     ```

### 4. After the transfer: what's tied to the Team ID

| What | Where | Change |
|---|---|---|
| Universal links and password autofill | `web/.well-known/apple-app-site-association` | Add `NEW_TEAM_ID.is.giorgio.app.parousia` to both `applinks.details[].appIDs` and `webcredentials.apps`, and **keep the old entry**: installs built by the old team still carry it. The file ships with the web deploy, so merge this **before the first new-team build reaches users**. Apple's CDN caches it for a while. Remove the old entry only after `web/app_version.json` blocks every old-team build. |
| Signing team | `ios/Runner.xcodeproj/project.pbxproj` and `macos/Runner.xcodeproj/project.pbxproj` (3 × `DEVELOPMENT_TEAM` each) | Set to the new Team ID. |
| Xcode Cloud | App Store Connect (new team) | Set up the product again (connect the repo, recreate the workflows). `ios/ci_scripts/` needs no change. |
| Store metadata CI | GitHub secrets `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT` (`store-metadata.yaml`) | Create a Team Key in the new team (App Manager role) and replace all three. Then run the workflow by hand to check. |
| TestFlight | App Store Connect (new team) | The cleanup emptied everything. Re-enter Test Information and recreate the internal group. External testing needs Beta App Review again. |
| Sign in with Apple grouping | Certificates, Identifiers & Profiles | If you ungrouped in step 1, regroup in the new team. |
| Private relay email | Certificates, Identifiers & Profiles → Services → Sign in with Apple for Email Communication (new team) | Register the domain and sender address that Supabase's SMTP sends from. Without it, Supabase emails to `@privaterelay.appleid.com` addresses are dropped. |
| Agreements | App Store Connect → Business (new team) | Paid Apps agreement, tax and banking. Needed again once in-app purchases ship. |

**N/A, checked:**

- Push notifications. `Runner.entitlements` has `aps-environment`, but the app has no push SDK
  or APNs sender, so there's no APNs key to move.
- App Groups and keychain sharing. There are no such entitlements, and the Supabase session lives
  in SharedPreferences, not in the keychain, whose access group changes with the Team ID. Users
  stay signed in across the update.
- fastlane `Appfile`/`Fastfile`. They contain no team ID.
- macOS. It has no Sign in with Apple entitlement.

### 5. Cleanup (once sign-ins are confirmed, within the 60 days)

- Delete `apple_users.csv`, `transfer_ids.csv`, `migrate.sql` and the `.p8` files from
  `tools/app-transfer/`, or wherever you wrote them.
- After the 60 days, revoke the old team's Sign in with Apple key, since nothing uses it any more.
