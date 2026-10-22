-- Foreign-key indexes and SECURITY DEFINER hygiene (migration 20261022120000).

begin;
select plan(6);

select has_index(
  'public', 'replies', 'replies_schedule_id', 'schedule_id',
  'replies(schedule_id) is indexed'
);
select has_index(
  'public', 'default_rules', 'default_rules_schedule_id', 'schedule_id',
  'default_rules(schedule_id) is indexed'
);
select has_index(
  'public', 'schedules', 'schedules_group_id', 'group_id',
  'schedules(group_id) is indexed'
);
select has_index(
  'public', 'invites', 'invites_member_id', 'member_id',
  'invites(member_id) is indexed'
);
select has_index(
  'public', 'members', 'members_profile_id', 'profile_id',
  'members(profile_id) is indexed'
);

-- A definer function without a pinned search_path resolves names through
-- the caller's search_path. Covers functions added later, too.
select is_empty(
  $$
    select p.proname
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prosecdef
      and not exists (
        select 1 from unnest(p.proconfig) as c where c like 'search_path=%'
      )
  $$,
  'every SECURITY DEFINER function in public pins search_path'
);

select * from finish();
rollback;
