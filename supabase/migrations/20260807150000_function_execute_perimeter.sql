-- Close the function-EXECUTE perimeter (MODERNIZATION.md Phase 1 item 13).
--
-- Postgres grants EXECUTE on every new function to PUBLIC by default, so all
-- of our SECURITY DEFINER functions were callable by `anon` via
-- `/rest/v1/rpc/...` with just the anon key. In particular
-- `check_invite_code` was an unauthenticated, unrate-limited enumeration
-- oracle over invite codes. The grants migration (20260628120000) deliberately
-- withheld table DML from `anon` but never touched function EXECUTE — this
-- migration closes that gap.
--
-- Idempotent: REVOKE/GRANT are no-ops when already applied.

-- RPC entry points: authenticated users only (plus service_role for tooling).
revoke execute on function public.create_group(uuid, text, text, text) from public, anon;
revoke execute on function public.check_invite_code(text) from public, anon;
revoke execute on function public.consume_invite_code(text) from public, anon;
revoke execute on function public.is_member_of_group(uuid, group_roles[]) from public, anon;
revoke execute on function public.gen_random_uuid_v7() from public, anon;

grant execute on function public.create_group(uuid, text, text, text) to authenticated, service_role;
grant execute on function public.check_invite_code(text) to authenticated, service_role;
grant execute on function public.consume_invite_code(text) to authenticated, service_role;
grant execute on function public.is_member_of_group(uuid, group_roles[]) to authenticated, service_role;
-- gen_random_uuid_v7 is a column default, evaluated as the inserting role.
grant execute on function public.gen_random_uuid_v7() to authenticated, service_role;

-- Trigger functions are never called through the API. EXECUTE on a trigger
-- function is only checked when the trigger is created, not when it fires,
-- so revoking from every API role is safe and removes them from the RPC
-- surface entirely.
revoke execute on function public.handle_upsert_user() from public, anon, authenticated;
revoke execute on function public.handle_delete_user() from public, anon, authenticated;
revoke execute on function public.handle_new_invite() from public, anon, authenticated;

-- Future-proofing: functions created by later migrations (this role) must be
-- granted to API roles explicitly instead of inheriting PUBLIC EXECUTE.
alter default privileges in schema public revoke execute on functions from public;
