-- Tests for the create_group() RPC.
--
-- Self-contained: creates a user in auth.users and authenticates as them by setting
-- the role + JWT claims that create_group() reads via auth.uid().

begin;
select plan(3);

insert into auth.users (id, email)
values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'creator@test.com');

set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';

select isnt(
  (select id from create_group(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Test Group', null, null)),
  null,
  'create_group returns the created group'
);

select is(
  (select count(*)::int from groups where display_name = 'Test Group'),
  1,
  'the group exists in the groups table'
);

select is(
  (select count(*)::int from members
   where group_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' and role = 'admin'),
  1,
  'the creator is added as an admin member of the group'
);

select * from finish();
rollback;
