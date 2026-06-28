-- Grant the Supabase API roles access to the public schema.
--
-- WHY: the existing schema migrations create tables but never GRANT privileges,
-- relying on Supabase's implicit default-privilege setup. Production received those
-- grants when it was first provisioned, but current Supabase CLI stacks do NOT
-- auto-grant the same way, so a fresh database (local dev, CI, a future staging
-- environment) ends up with anon/authenticated/service_role lacking DML on the
-- public tables -> "permission denied for table ..." (SQLSTATE 42501).
--
-- This migration makes the grants explicit and reproducible. Row Level Security
-- still governs which ROWS each role may access.
--
-- DELIBERATELY NOT GRANTING DML TO `anon`: this app is fully authenticated
-- (every route is behind AuthenticationGuard) so anon needs no table access. More
-- importantly, granting anon DML via `alter default privileges` would make every
-- FUTURE table anon-writable until someone remembers to enable RLS — the opposite
-- of the safe default for an RLS-based app. anon only gets schema USAGE.

grant usage on schema public to anon, authenticated, service_role;

grant select, insert, update, delete
  on all tables in schema public
  to authenticated, service_role;

grant usage, select
  on all sequences in schema public
  to authenticated, service_role;

-- Apply the same defaults to objects created by future migrations.
alter default privileges in schema public
  grant select, insert, update, delete on tables to authenticated, service_role;

alter default privileges in schema public
  grant usage, select on sequences to authenticated, service_role;
