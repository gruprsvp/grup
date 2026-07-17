-- Write-path RLS tests: INSERT/UPDATE/DELETE policies, admin vs plain member,
-- and the *_all_self policies (including the reply-spoofing negative).
--
-- Self-contained, same technique as rls_test.sql: users created directly in
-- auth.users, identity switched via role + JWT claims.
--
-- Cast of characters:
--   Alice 11111111-… : creator/admin of the group
--   Bob   22222222-… : plain member of the group
--
-- Note on failure modes: an INSERT that violates a policy raises 42501, while
-- an UPDATE/DELETE whose USING clause matches no rows succeeds silently with
-- 0 rows affected — both shapes are asserted below because the app currently
-- treats 0-row deletes as success (see MODERNIZATION.md Phase 1.5 item 3).

begin;
select plan(20);

-- ── Setup (superuser, bypasses RLS) ────────────────────────────────────────
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'alice@test.com'),
  ('22222222-2222-2222-2222-222222222222', 'bob@test.com');

-- ── Alice: create the group, add Bob, create a schedule ────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

select lives_ok(
  $$ select create_group('33333333-3333-3333-3333-333333333333', 'Test Group', null, null) $$,
  'setup: Alice creates a group'
);

-- groups has SELECT/UPDATE/DELETE policies but no INSERT policy: direct
-- inserts must be impossible for everyone; create_group (SECURITY DEFINER)
-- is the only way in.
select throws_ok(
  $$ insert into groups (display_name) values ('direct insert') $$,
  '42501', null,
  'nobody can INSERT into groups directly (create_group RPC is the only path)'
);

-- members_all INSERT, positive: an admin can add a member.
select lives_ok(
  $$ insert into members (id, group_id, profile_id, role)
     values ('44444444-4444-4444-4444-444444444444',
             '33333333-3333-3333-3333-333333333333',
             '22222222-2222-2222-2222-222222222222', 'member') $$,
  'an admin can add a member to their group'
);

-- schedules_all INSERT, positive: an admin can create a schedule.
select lives_ok(
  $$ insert into schedules (id, group_id, display_name, start_date, recurrence_rule)
     values ('55555555-5555-5555-5555-555555555555',
             '33333333-3333-3333-3333-333333333333',
             'Weekly practice', '2026-01-05T10:00:00Z', '{"freq": "WEEKLY"}') $$,
  'an admin can create a schedule'
);

-- replies_all INSERT, positive: an admin can manage another member's reply.
select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('44444444-4444-4444-4444-444444444444',
             '55555555-5555-5555-5555-555555555555',
             '2026-01-05T10:00:00Z', 'no') $$,
  'an admin can set another member''s reply'
);

-- Alice's own reply, used later as Bob's spoofing target.
select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     select m.id, '55555555-5555-5555-5555-555555555555', '2026-01-05T10:00:00Z', 'yes'
     from members m
     where m.group_id = '33333333-3333-3333-3333-333333333333'
       and m.profile_id = '11111111-1111-1111-1111-111111111111' $$,
  'setup: Alice replies for herself'
);

-- ── Bob: plain member ──────────────────────────────────────────────────────
set local request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

-- schedules_all, negative: a plain member cannot create a schedule.
select throws_ok(
  $$ insert into schedules (group_id, display_name, start_date, recurrence_rule)
     values ('33333333-3333-3333-3333-333333333333',
             'Bob''s schedule', '2026-01-06T10:00:00Z', '{"freq": "DAILY"}') $$,
  '42501', null,
  'a plain member cannot create a schedule'
);

-- schedules_all, negative: a plain member's DELETE matches no rows.
select lives_ok(
  $$ delete from schedules where id = '55555555-5555-5555-5555-555555555555' $$,
  'a plain member''s schedule DELETE does not error'
);
select is(
  (select count(*)::int from schedules where id = '55555555-5555-5555-5555-555555555555'),
  1,
  'the schedule survives a plain member''s DELETE (0 rows matched)'
);

-- members_all, negative: a plain member cannot add members.
select throws_ok(
  $$ insert into members (group_id, display_name_override)
     values ('33333333-3333-3333-3333-333333333333', 'Mallory') $$,
  '42501', null,
  'a plain member cannot add a member'
);

-- members_all, negative: a plain member cannot promote themselves.
select lives_ok(
  $$ update members set role = 'admin'
     where id = '44444444-4444-4444-4444-444444444444' $$,
  'a self-promotion UPDATE does not error'
);
select is(
  (select role::text from members where id = '44444444-4444-4444-4444-444444444444'),
  'member',
  'a plain member cannot change their own role (0 rows matched)'
);

-- Documents current behavior: members has no self-service policy, so a plain
-- member cannot even leave the group (see MODERNIZATION.md Phase 1 item 15 —
-- update this assertion when that lands).
select lives_ok(
  $$ delete from members where id = '44444444-4444-4444-4444-444444444444' $$,
  'a leave-group DELETE does not error'
);
select is(
  (select count(*)::int from members where id = '44444444-4444-4444-4444-444444444444'),
  1,
  'a plain member cannot delete their own membership (no self-service policy yet)'
);

-- replies_all_self, positive: Bob manages his own reply.
select lives_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     values ('44444444-4444-4444-4444-444444444444',
             '55555555-5555-5555-5555-555555555555',
             '2026-01-12T10:00:00Z', 'yes') $$,
  'a member can create their own reply'
);

-- replies_all / replies_all_self UPDATE scoping: Bob's update of Alice's
-- existing reply matches no rows.
select lives_ok(
  $$ update replies set selected_option = 'no'
     where schedule_id = '55555555-5555-5555-5555-555555555555'
       and member_id <> '44444444-4444-4444-4444-444444444444' $$,
  'an update of another member''s reply does not error'
);
select is(
  (select count(*)::int from replies
   where schedule_id = '55555555-5555-5555-5555-555555555555'
     and member_id <> '44444444-4444-4444-4444-444444444444'
     and selected_option = 'yes'),
  1,
  'another member''s reply is untouched (Alice''s ''yes'' still stands)'
);

-- replies_all_self, negative (reply spoofing): Bob cannot write a reply for
-- Alice's member row — WITH CHECK fails on both replies_all (not admin) and
-- replies_all_self (not his member_id).
select throws_ok(
  $$ insert into replies (member_id, schedule_id, instance_date, selected_option)
     select m.id, '55555555-5555-5555-5555-555555555555', '2026-01-19T10:00:00Z', 'no'
     from members m
     where m.group_id = '33333333-3333-3333-3333-333333333333'
       and m.profile_id = '11111111-1111-1111-1111-111111111111' $$,
  '42501', null,
  'a member cannot create a reply for another member (reply spoofing)'
);

-- default_rules_all_self, positive + spoofing negative.
select lives_ok(
  $$ insert into default_rules (member_id, schedule_id, selected_option, recurrence_rule)
     values ('44444444-4444-4444-4444-444444444444',
             '55555555-5555-5555-5555-555555555555',
             'yes', '{"freq": "WEEKLY"}') $$,
  'a member can set their own default rule'
);
select throws_ok(
  $$ insert into default_rules (member_id, schedule_id, selected_option, recurrence_rule)
     select m.id, '55555555-5555-5555-5555-555555555555', 'no', '{"freq": "WEEKLY"}'
     from members m
     where m.group_id = '33333333-3333-3333-3333-333333333333'
       and m.profile_id = '11111111-1111-1111-1111-111111111111' $$,
  '42501', null,
  'a member cannot set a default rule for another member'
);

select * from finish();
rollback;
