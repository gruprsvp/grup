-- Default privileges for objects created by later migrations
-- (MODERNIZATION.md S2, S4 and S5).
--
-- S2: on 2026-10-30 Supabase revokes the default table and sequence grants on
-- existing projects, with these same statements (its changelog, "tables not
-- exposed to Data and GraphQL API automatically"). Running them here makes
-- local and CI match prod, so a migration that adds a table without granting
-- it fails in CI instead of only on prod (42501). This also cancels the
-- defaults 20260628120000 set for authenticated and service_role: every new
-- table now grants its privileges explicitly, next to `enable row level
-- security`. Existing tables keep their grants.
alter default privileges for role postgres in schema public
  revoke select, insert, update, delete on tables from anon, authenticated, service_role;
alter default privileges for role postgres in schema public
  revoke usage, select on sequences from anon, authenticated, service_role;

-- S4: a new function was still executable by anon, twice over, so the next
-- SECURITY DEFINER RPC would have been callable signed out:
-- - Supabase's defaults grant EXECUTE in public to anon by name;
-- - 20260807150000's `in schema public revoke ... from public` did nothing:
--   per-schema default privileges only add to the global ones, which give
--   PUBLIC EXECUTE on every function. Only a global revoke removes that.
-- authenticated keeps EXECUTE (RLS helpers need it); trigger functions revoke
-- it, as the existing ones do.
alter default privileges for role postgres in schema public
  revoke execute on functions from anon;
alter default privileges for role postgres
  revoke execute on functions from public;

-- S5 (`supabase db advisors`: function_search_path_mutable). The function only
-- calls pg_catalog built-ins, so an empty search_path changes nothing. The
-- vendored 20230706000000 stays untouched: prod never re-applies it.
-- On prod the function belongs to the pg_tle extension that installed it, and
-- its owner may not be postgres. ALTER by a non-owner is an error, which would
-- stop `db push` and every release after it, so skip it there with a notice.
do $$
begin
  if pg_has_role(
    (select proowner from pg_proc where oid = 'public.gen_random_uuid_v7()'::regprocedure),
    'usage'
  ) then
    alter function public.gen_random_uuid_v7() set search_path = '';
  else
    raise notice 'gen_random_uuid_v7: not its owner, search_path left as is';
  end if;
end
$$;
