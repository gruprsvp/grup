-- anon holds no privilege on any table (MODERNIZATION.md S4, second half).
--
-- 20260628120000 meant "anon only gets schema USAGE", but Supabase's own
-- defaults had already granted anon everything on every table. RLS has no
-- anon policy, so nothing was readable, but the grants were one permissive
-- policy away from exposing a table, and TRUNCATE ignores RLS. Every route
-- needs a session, and nothing queries a table before sign-in (the
-- repositories only load data for a signed-in user).
revoke all on all tables in schema public from anon;
revoke all on all sequences in schema public from anon;

-- And for tables added later: 20261023120000 removed select/insert/update/
-- delete; this removes the truncate, references and trigger Supabase leaves.
alter default privileges for role postgres in schema public
  revoke all on tables from anon;
alter default privileges for role postgres in schema public
  revoke all on sequences from anon;
