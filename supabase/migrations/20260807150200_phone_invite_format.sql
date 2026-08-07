-- Fix the phone-invite format contradiction (MODERNIZATION.md Phase 1 item 14).
--
-- The two invite-claiming paths disagreed on the stored phone format:
--   * handle_upsert_user (user signs up after being invited) matched
--     invites.value = '+' || auth.users.phone           → expects value WITH '+'
--   * handle_new_invite (invite created for an existing user) matched
--     auth.users.phone = invites.value                  → expects value WITHOUT '+'
-- The same stored value can never satisfy both, so one flow always no-oped.
--
-- Canonical format: invites.value holds E.164 WITH the leading '+' (what the
-- app's PhoneController.international produces); auth.users.phone stores the
-- digits without '+' (GoTrue's behavior). handle_upsert_user already matches
-- that; this migration brings handle_new_invite in line.
create or replace function handle_new_invite()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
declare
    user_id uuid;
begin
    select id
    into user_id
    from auth.users
    where case
              when new.method = 'email' then email = new.value
              -- invites.value is E.164 with '+'; auth.users.phone has no '+'
              when new.method = 'phone' then '+' || phone = new.value
              end
    limit 1;

    if user_id is not null then
        update public.members
        set profile_id = user_id
        where id = new.member_id;

        delete from invites where member_id = new.member_id;
    end if;

    return new;
end;
$$;
comment on function handle_new_invite() is 'Updates members whenever an invite for an existing profile is created';

-- Belt and braces: re-assert the EXECUTE perimeter (see 20260807150000).
revoke execute on function public.handle_new_invite() from public, anon, authenticated;
