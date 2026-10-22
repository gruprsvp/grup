-- Index the foreign-key columns that RLS subqueries, joins and ON DELETE
-- CASCADE scan. A composite key only indexes its leading column, so
-- schedule_id (in replies' and default_rules' primary keys) and
-- members.profile_id (in the (group_id, profile_id) unique key) are not
-- covered. members.profile_id is the column behind every policy check:
-- is_member_of_group() and profiles_select look members up by it.
create index if not exists replies_schedule_id on replies (schedule_id);
create index if not exists default_rules_schedule_id on default_rules (schedule_id);
create index if not exists schedules_group_id on schedules (group_id);
create index if not exists invites_member_id on invites (member_id);
create index if not exists members_profile_id on members (profile_id);

-- Every other SECURITY DEFINER function pins its search_path; without it,
-- the function resolves names through the caller's search_path.
alter function public.handle_delete_user() set search_path = public;
