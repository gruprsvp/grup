-- Grants on tables and functions, including those later migrations add
-- (migrations 20261023120000 and 20261023130000).
--
-- The probes are created here as postgres, the role migrations run as, so
-- they get exactly the default privileges the next migration's objects get.

begin;
select plan(10);

-- Every table the API can reach is behind row-level security, and signed-in
-- users hold the privileges the policies then filter.
select is_empty(
  $$
    select relname from pg_class
    where relnamespace = 'public'::regnamespace and relkind in ('r', 'p')
      and not relrowsecurity
  $$,
  'every public table has row-level security enabled'
);
select is_empty(
  $$
    select relname from pg_class
    where relnamespace = 'public'::regnamespace and relkind in ('r', 'p')
      and not (
        has_table_privilege('authenticated', oid, 'select')
        and has_table_privilege('authenticated', oid, 'insert')
        and has_table_privilege('authenticated', oid, 'update')
        and has_table_privilege('authenticated', oid, 'delete')
      )
  $$,
  'authenticated holds select, insert, update and delete on every public table'
);

-- anon holds nothing on any table: every route needs a session.
select is_empty(
  $$
    select relname from pg_class
    where relnamespace = 'public'::regnamespace and relkind in ('r', 'p', 'v', 'm', 'S')
      and has_table_privilege(
        'anon', oid, 'select, insert, update, delete, truncate, references, trigger'
      )
  $$,
  'anon holds no privilege on any public table or sequence'
);

-- S2: a new table grants nothing until its migration says so (as on prod
-- after Supabase's 2026-10-30 change).
create table public.probe_table (id int);
create sequence public.probe_sequence;
select ok(
  not has_table_privilege(
    'anon', 'public.probe_table', 'select, insert, update, delete, truncate, references, trigger'
  ),
  'a new table grants anon nothing by default'
);
select ok(
  not has_table_privilege('authenticated', 'public.probe_table', 'select, insert, update, delete'),
  'a new table grants authenticated nothing by default'
);
select ok(
  not has_sequence_privilege('authenticated', 'public.probe_sequence', 'usage, select'),
  'a new sequence grants authenticated nothing by default'
);

-- S4: a new function is not callable signed out.
create function public.probe_function() returns int language sql as 'select 1';
select ok(
  not has_function_privilege('anon', 'public.probe_function()', 'execute'),
  'a new function is not executable by anon by default'
);
select is_empty(
  $$
    select p.oid::regprocedure from pg_proc p
    where p.pronamespace = 'public'::regnamespace
      and has_function_privilege('anon', p.oid, 'execute')
      and not exists (
        select from pg_depend d
        where d.classid = 'pg_proc'::regclass and d.objid = p.oid and d.deptype = 'e'
      )
  $$,
  'anon can execute no function in public'
);

-- S5: a pinned search_path, and still a version-7 UUID with the RFC 4122
-- variant (the default of every id column).
select ok(
  (select coalesce(proconfig, '{}') @> array['search_path=""'] from pg_proc
   where oid = 'public.gen_random_uuid_v7()'::regprocedure),
  'gen_random_uuid_v7 has an empty search_path'
);
select matches(
  public.gen_random_uuid_v7()::text,
  '^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  'gen_random_uuid_v7 returns a version-7 UUID'
);

select * from finish();
rollback;
