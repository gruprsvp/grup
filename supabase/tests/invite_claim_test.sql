-- Phone-invite claiming, both directions (migration 20260807150200).
--
-- Canonical format: invites.value holds E.164 WITH the leading '+';
-- auth.users.phone stores the digits WITHOUT it. Before the fix the two
-- claim paths disagreed (handle_upsert_user matched '+' || phone, but
-- handle_new_invite matched the raw phone), so invite-then-signup worked
-- while signup-then-invite silently no-oped. Both directions are pinned here.

begin;
select plan(5);

-- ── Setup: Alice, admin of a group ─────────────────────────────────────────
insert into auth.users (id, email) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'alice-invites@test.com');

set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';

select lives_ok(
  $$ select create_group('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Invite Group', null, null) $$,
  'setup: Alice creates a group'
);

-- ── Path 1: invite first, user signs up later (handle_upsert_user) ─────────
insert into members (id, group_id, display_name_override)
values ('cccccccc-cccc-cccc-cccc-cccccccccccc',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Phoebe');
insert into invites (member_id, method, value)
values ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'phone', '+15550001111');

-- Simulate the signup (GoTrue stores the phone without '+').
reset role;
insert into auth.users (id, phone) values
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', '15550001111');

select is(
  (select profile_id from members where id = 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  'invite-then-signup: the member row is claimed on signup'
);
select is(
  (select count(*)::int from invites
   where member_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
  0,
  'invite-then-signup: the invite is consumed'
);

-- ── Path 2: user exists, invite created later (handle_new_invite) ──────────
insert into auth.users (id, phone) values
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '15550002222');

set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';

insert into members (id, group_id, display_name_override)
values ('ffffffff-ffff-ffff-ffff-ffffffffffff',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Quinn');
insert into invites (member_id, method, value)
values ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'phone', '+15550002222');

reset role;
select is(
  (select profile_id from members where id = 'ffffffff-ffff-ffff-ffff-ffffffffffff'),
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  'signup-then-invite: the member row is claimed when the invite is created'
);
select is(
  (select count(*)::int from invites
   where member_id = 'ffffffff-ffff-ffff-ffff-ffffffffffff'),
  0,
  'signup-then-invite: the invite is consumed immediately'
);

select * from finish();
rollback;
