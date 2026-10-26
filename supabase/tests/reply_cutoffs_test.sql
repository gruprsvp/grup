-- Reply cutoffs (migration 20261025140200, docs/billing-and-entitlements.md 9.2).
--
-- Occurrences are stored as wall-clock times labelled UTC, so "an occurrence
-- 30 minutes from now in Zurich" is Zurich's wall clock plus 30 minutes, read
-- as UTC. The instants below are built that way and kept in settings, which
-- every role can read.

begin;
select plan(27);

select set_config('test.zrh_locked',  (((now() at time zone 'Europe/Zurich') + interval '30 minutes') at time zone 'UTC')::text, true);
select set_config('test.zrh_locked2', (((now() at time zone 'Europe/Zurich') + interval '10 minutes') at time zone 'UTC')::text, true);
select set_config('test.zrh_open',    (((now() at time zone 'Europe/Zurich') + interval '3 hours') at time zone 'UTC')::text, true);
select set_config('test.ny_open',     (((now() at time zone 'America/New_York') + interval '90 minutes') at time zone 'UTC')::text, true);

-- ── The deadline, in both seasons ──────────────────────────────────────────
select is(
  billing.reply_deadline('2026-01-15 18:00Z', 60, 'Europe/Zurich'), '2026-01-15 16:00Z',
  '18:00 in a Zurich winter (UTC+1) closes at 16:00Z with a 60-minute cutoff'
);
select is(
  billing.reply_deadline('2026-07-15 18:00Z', 60, 'Europe/Zurich'), '2026-07-15 15:00Z',
  '18:00 in a Zurich summer (UTC+2) closes at 15:00Z'
);
select is(
  billing.reply_deadline('2026-01-15 18:00Z', 60, 'America/New_York'), '2026-01-15 22:00Z',
  '18:00 in a New York winter (UTC-5) closes at 22:00Z'
);
select is(
  billing.reply_deadline('2026-07-15 18:00Z', 60, 'America/New_York'), '2026-07-15 21:00Z',
  '18:00 in a New York summer (UTC-4) closes at 21:00Z'
);

-- ── Setup ──────────────────────────────────────────────────────────────────
insert into auth.users (id, email) values
  ('aaaaaaaa-1111-0000-0000-000000000001', 'alice@cutoffs.test'),
  ('aaaaaaaa-1111-0000-0000-000000000002', 'bob@cutoffs.test'),
  ('aaaaaaaa-1111-0000-0000-000000000003', 'carol@cutoffs.test'),
  ('aaaaaaaa-1111-0000-0000-000000000004', 'dan@cutoffs.test');

-- 'Kitchen' and 'Canteen' have the feature (a grant); 'Free' had it while
-- unlocked and lost it at launch, so its cutoff is kept but not enforced.
insert into groups (id, display_name) values
  ('bbbbbbbb-1111-0000-0000-000000000001', 'Kitchen'),
  ('bbbbbbbb-1111-0000-0000-000000000002', 'Free'),
  ('bbbbbbbb-1111-0000-0000-000000000003', 'Canteen');
insert into members (id, group_id, profile_id, role) values
  ('cccccccc-1111-0000-0000-000000000001', 'bbbbbbbb-1111-0000-0000-000000000001', 'aaaaaaaa-1111-0000-0000-000000000001', 'admin'),
  ('cccccccc-1111-0000-0000-000000000002', 'bbbbbbbb-1111-0000-0000-000000000001', 'aaaaaaaa-1111-0000-0000-000000000002', 'member'),
  ('cccccccc-1111-0000-0000-000000000003', 'bbbbbbbb-1111-0000-0000-000000000001', 'aaaaaaaa-1111-0000-0000-000000000003', 'member'),
  ('cccccccc-1111-0000-0000-000000000004', 'bbbbbbbb-1111-0000-0000-000000000002', 'aaaaaaaa-1111-0000-0000-000000000001', 'admin'),
  ('cccccccc-1111-0000-0000-000000000005', 'bbbbbbbb-1111-0000-0000-000000000002', 'aaaaaaaa-1111-0000-0000-000000000002', 'member'),
  ('cccccccc-1111-0000-0000-000000000006', 'bbbbbbbb-1111-0000-0000-000000000003', 'aaaaaaaa-1111-0000-0000-000000000001', 'admin'),
  ('cccccccc-1111-0000-0000-000000000007', 'bbbbbbbb-1111-0000-0000-000000000003', 'aaaaaaaa-1111-0000-0000-000000000004', 'member');

insert into schedules (id, group_id, display_name, start_date, recurrence_rule, cutoff_minutes_before, time_zone) values
  ('eeeeeeee-1111-0000-0000-000000000001', 'bbbbbbbb-1111-0000-0000-000000000001', 'Dinner', '2026-01-01 18:00Z', '{"freq": "DAILY"}', 60, 'Europe/Zurich'),
  ('eeeeeeee-1111-0000-0000-000000000002', 'bbbbbbbb-1111-0000-0000-000000000001', 'Supper', '2026-01-01 18:00Z', '{"freq": "DAILY"}', 60, 'America/New_York'),
  ('eeeeeeee-1111-0000-0000-000000000003', 'bbbbbbbb-1111-0000-0000-000000000002', 'Dinner', '2026-01-01 18:00Z', '{"freq": "DAILY"}', 60, 'Europe/Zurich'),
  ('eeeeeeee-1111-0000-0000-000000000004', 'bbbbbbbb-1111-0000-0000-000000000002', 'Lunch',  '2026-01-01 12:00Z', '{"freq": "DAILY"}', null, null),
  ('eeeeeeee-1111-0000-0000-000000000005', 'bbbbbbbb-1111-0000-0000-000000000003', 'Dinner', '2026-01-01 18:00Z', '{"freq": "DAILY"}', 60, 'Europe/Zurich');

insert into billing.grants (group_id, source, features) values
  ('bbbbbbbb-1111-0000-0000-000000000001', 'manual', '{reply_cutoffs}'),
  ('bbbbbbbb-1111-0000-0000-000000000003', 'manual', '{reply_cutoffs}');
update billing.config set mode = 'live', cutoff_at = '2026-01-01';

-- Replies written as postgres (no user): never locked.
insert into replies (member_id, schedule_id, instance_date, selected_option) values
  ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001', current_setting('test.zrh_locked')::timestamptz, 'yes'),
  ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001', current_setting('test.zrh_open')::timestamptz, 'yes'),
  ('cccccccc-1111-0000-0000-000000000003', 'eeeeeeee-1111-0000-0000-000000000001', current_setting('test.zrh_locked')::timestamptz, 'yes'),
  ('cccccccc-1111-0000-0000-000000000005', 'eeeeeeee-1111-0000-0000-000000000003', current_setting('test.zrh_locked')::timestamptz, 'yes'),
  ('cccccccc-1111-0000-0000-000000000007', 'eeeeeeee-1111-0000-0000-000000000005', current_setting('test.zrh_locked')::timestamptz, 'yes');

-- ── Turning cutoffs on and off ─────────────────────────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-1111-0000-0000-000000000001","role":"authenticated"}';

select throws_ok(
  $$ update schedules set cutoff_minutes_before = 60, time_zone = 'Europe/Zurich'
      where id = 'eeeeeeee-1111-0000-0000-000000000004' $$,
  'P0001', 'feature_locked',
  'turning a cutoff on without the feature raises feature_locked'
);
select lives_ok(
  $$ insert into schedules (group_id, display_name, start_date, recurrence_rule, cutoff_minutes_before, time_zone)
     values ('bbbbbbbb-1111-0000-0000-000000000001', 'Breakfast', '2026-01-01 08:00Z', '{"freq": "DAILY"}', 30, 'Europe/Zurich') $$,
  'with the feature, a schedule can have a cutoff'
);
select throws_ok(
  $$ update schedules set time_zone = 'Mars/Olympus_Mons' where id = 'eeeeeeee-1111-0000-0000-000000000001' $$,
  '22023', null,
  'an unknown time zone is refused'
);
select throws_ok(
  $$ update schedules set time_zone = null where id = 'eeeeeeee-1111-0000-0000-000000000001' $$,
  '23514', null,
  'a cutoff needs a time zone'
);

-- ── After the deadline: members ────────────────────────────────────────────
set local request.jwt.claims to '{"sub":"aaaaaaaa-1111-0000-0000-000000000002","role":"authenticated"}';

select throws_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001',
             current_setting('test.zrh_locked2')::timestamptz, 'no') $$,
  'P0001', 'reply_locked',
  'after the deadline a member can''t answer'
);
select throws_ok(
  $$ update replies set selected_option = 'no'
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_locked')::timestamptz $$,
  'P0001', 'reply_locked',
  '... nor change an answer'
);
select throws_ok(
  $$ delete from replies
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_locked')::timestamptz $$,
  'P0001', 'reply_locked',
  '... nor delete one'
);
select throws_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001',
             current_setting('test.zrh_locked')::timestamptz, 'no')
     on conflict (member_id, schedule_id, instance_date) do update set selected_option = excluded.selected_option $$,
  'P0001', 'reply_locked',
  '... nor upsert one, as the app does'
);

-- ── Before the deadline, or without the feature ────────────────────────────
select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001',
             current_setting('test.zrh_open')::timestamptz, 'no')
     on conflict (member_id, schedule_id, instance_date) do update set selected_option = excluded.selected_option $$,
  'before the deadline a member can change an answer'
);
select lives_ok(
  $$ delete from replies
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_open')::timestamptz $$,
  '... and delete it'
);
select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000002',
             current_setting('test.ny_open')::timestamptz, 'yes') $$,
  'New York''s wall clock is read in New York: 90 minutes ahead, a 60-minute cutoff is still open'
);
select lives_ok(
  $$ update replies set selected_option = 'no'
      where member_id = 'cccccccc-1111-0000-0000-000000000005'
        and instance_date = current_setting('test.zrh_locked')::timestamptz $$,
  'without the feature a kept cutoff isn''t enforced'
);
select is(
  (select selected_option::text from replies
    where member_id = 'cccccccc-1111-0000-0000-000000000005'),
  'no',
  '... and the change is saved'
);

-- ── After the deadline: admins ─────────────────────────────────────────────
set local request.jwt.claims to '{"sub":"aaaaaaaa-1111-0000-0000-000000000001","role":"authenticated"}';

select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('cccccccc-1111-0000-0000-000000000002', 'eeeeeeee-1111-0000-0000-000000000001',
             current_setting('test.zrh_locked2')::timestamptz, 'no') $$,
  'after the deadline an admin can still answer for a member'
);
select lives_ok(
  $$ update replies set selected_option = 'no'
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_locked')::timestamptz $$,
  '... and change an answer'
);
select throws_ok(
  $$ delete from replies
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_locked')::timestamptz $$,
  'P0001', 'reply_locked',
  '... but not delete one: that would fall back to the default unseen'
);
select lives_ok(
  $$ update schedules set cutoff_minutes_before = null where id = 'eeeeeeee-1111-0000-0000-000000000003' $$,
  'turning a cutoff off never needs the feature'
);

set local role service_role;
set local request.jwt.claims to '{"role":"service_role"}';
select lives_ok(
  $$ delete from replies
      where member_id = 'cccccccc-1111-0000-0000-000000000002'
        and instance_date = current_setting('test.zrh_locked2')::timestamptz $$,
  'the service role is never locked out'
);

-- ── Deleted with their member, schedule or group ───────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-1111-0000-0000-000000000002","role":"authenticated"}';
select lives_ok(
  $$ delete from members where id = 'cccccccc-1111-0000-0000-000000000002' $$,
  'a member with locked replies can leave the group'
);

set local request.jwt.claims to '{"sub":"aaaaaaaa-1111-0000-0000-000000000001","role":"authenticated"}';
select lives_ok(
  $$ delete from members where id = 'cccccccc-1111-0000-0000-000000000003' $$,
  'an admin can remove a member with locked replies'
);
reset role;
insert into replies (member_id, schedule_id, instance_date, selected_option) values
  ('cccccccc-1111-0000-0000-000000000001', 'eeeeeeee-1111-0000-0000-000000000001', current_setting('test.zrh_locked')::timestamptz, 'yes');
set local role authenticated;
select lives_ok(
  $$ delete from schedules where id = 'eeeeeeee-1111-0000-0000-000000000001' $$,
  'an admin can delete a schedule with locked replies'
);
select lives_ok(
  $$ delete from groups where id = 'bbbbbbbb-1111-0000-0000-000000000003' $$,
  'an admin can delete a group with locked replies'
);
reset role;
select is(
  (select count(*)::int from replies
    where member_id in ('cccccccc-1111-0000-0000-000000000001', 'cccccccc-1111-0000-0000-000000000002',
                        'cccccccc-1111-0000-0000-000000000003', 'cccccccc-1111-0000-0000-000000000007')),
  0,
  'their replies went with them'
);

select * from finish();
rollback;
