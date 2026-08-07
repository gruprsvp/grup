-- Function EXECUTE perimeter (migration 20260807150000).
--
-- Every function used to be PUBLIC-executable, which made check_invite_code
-- an unauthenticated enumeration oracle over invite codes via /rest/v1/rpc.
-- These assertions pin the perimeter: anon has no RPC surface at all,
-- authenticated keeps exactly the flows the app calls, and trigger functions
-- are not callable by any API role.
--
-- has_function_privilege() includes privileges inherited via PUBLIC, so a
-- regression to the default grant fails these tests.

begin;
select plan(13);

-- anon: no RPC surface.
select ok(
  not has_function_privilege('anon', 'public.check_invite_code(text)', 'execute'),
  'anon cannot execute check_invite_code (enumeration oracle closed)'
);
select ok(
  not has_function_privilege('anon', 'public.consume_invite_code(text)', 'execute'),
  'anon cannot execute consume_invite_code'
);
select ok(
  not has_function_privilege('anon', 'public.create_group(uuid, text, text, text)', 'execute'),
  'anon cannot execute create_group'
);
select ok(
  not has_function_privilege('anon', 'public.is_member_of_group(uuid, group_roles[])', 'execute'),
  'anon cannot execute is_member_of_group'
);

-- authenticated: exactly the flows the app uses.
select ok(
  has_function_privilege('authenticated', 'public.check_invite_code(text)', 'execute'),
  'authenticated can execute check_invite_code'
);
select ok(
  has_function_privilege('authenticated', 'public.consume_invite_code(text)', 'execute'),
  'authenticated can execute consume_invite_code'
);
select ok(
  has_function_privilege('authenticated', 'public.create_group(uuid, text, text, text)', 'execute'),
  'authenticated can execute create_group'
);
select ok(
  has_function_privilege('authenticated', 'public.is_member_of_group(uuid, group_roles[])', 'execute'),
  'authenticated can execute is_member_of_group (used by RLS policies)'
);
select ok(
  has_function_privilege('authenticated', 'public.gen_random_uuid_v7()', 'execute'),
  'authenticated can execute gen_random_uuid_v7 (column defaults)'
);

-- Trigger functions: not callable by any API role (EXECUTE is only checked
-- at CREATE TRIGGER time, so the triggers themselves still fire).
select ok(
  not has_function_privilege('authenticated', 'public.handle_upsert_user()', 'execute'),
  'authenticated cannot call handle_upsert_user directly'
);
select ok(
  not has_function_privilege('authenticated', 'public.handle_delete_user()', 'execute'),
  'authenticated cannot call handle_delete_user directly'
);
select ok(
  not has_function_privilege('authenticated', 'public.handle_new_invite()', 'execute'),
  'authenticated cannot call handle_new_invite directly'
);
select ok(
  not has_function_privilege('authenticated', 'public.handle_member_left()', 'execute'),
  'authenticated cannot call handle_member_left directly'
);

select * from finish();
rollback;
