-- Row Level Security tests: verify tenant isolation between groups.
--
-- Self-contained: creates users directly in auth.users (the handle_upsert_user
-- trigger auto-creates their profiles) and switches the authenticated identity by
-- setting the role + JWT claims that Supabase RLS reads via auth.uid(). No external
-- test-helper extension or network access required.

begin;
select plan(7);

-- ── Setup (runs as the superuser/migration role, bypassing RLS) ────────────
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'alice@test.com'),
  ('22222222-2222-2222-2222-222222222222', 'bob@test.com');

-- ── Act as Alice ───────────────────────────────────────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

select lives_ok(
  $$ select create_group('33333333-3333-3333-3333-333333333333', 'Alice Group', null, null) $$,
  'an authenticated user can create a group'
);

select is(
  (select count(*)::int from groups where id = '33333333-3333-3333-3333-333333333333'),
  1,
  'the creator can see their own group'
);

select is(
  (select role::text from members
   where group_id = '33333333-3333-3333-3333-333333333333'
     and profile_id = '11111111-1111-1111-1111-111111111111'),
  'admin',
  'the creator is added as an admin member'
);

-- ── Act as Bob (not a member of Alice's group) ─────────────────────────────
set local request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

select is(
  (select count(*)::int from groups where id = '33333333-3333-3333-3333-333333333333'),
  0,
  'a non-member cannot see another user''s group'
);

select is(
  (select count(*)::int from members where group_id = '33333333-3333-3333-3333-333333333333'),
  0,
  'a non-member cannot see another group''s members'
);

-- Bob's UPDATE runs but RLS scopes it to zero rows (he is not an admin there).
select lives_ok(
  $$ update groups set display_name = 'hacked' where id = '33333333-3333-3333-3333-333333333333' $$,
  'a non-member''s update statement does not error (it just matches no rows)'
);

-- ── Back as Alice: confirm Bob''s update changed nothing ────────────────────
set local request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

select is(
  (select display_name from groups where id = '33333333-3333-3333-3333-333333333333'),
  'Alice Group',
  'the group is unchanged after a non-member attempted an update'
);

select * from finish();
rollback;
