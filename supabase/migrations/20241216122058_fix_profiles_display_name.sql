-- This is to fix https://github.com/appforit/appforit/issues/87
-- If the identity provider provided a name and/or a profile picture, we should use it
-- This is particularly important for Apple, as they request in their guidelines:
--
-- > ## Guideline 4.0 - Design
--
-- > Your app offers Sign in with Apple as a login option but does not follow the design
-- > and user experience requirements for Sign in with Apple. Specifically:
-- >
-- > - Your app requires users to provide their name and/or email address after using Sign in with Apple.
--     This information is already provided by the
--     [Authentication Services framework](https://developer.apple.com/documentation/authenticationservices).
--
-- > These requirements provide the consistent experience users expect
-- > when using Sign In with Apple to authenticate or log in to an account.

-- We now upsert the user when it's first created, and update the user when it's updated.
create or replace function handle_upsert_user()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
declare
    invite public.invites;
begin
    insert into public.profiles (id, display_name, picture)
    values (new.id, new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'avatar_url')
    on conflict (id) do update set display_name = new.raw_user_meta_data ->> 'full_name',
                                   picture      = new.raw_user_meta_data ->> 'avatar_url';

    for invite in
        select *
        from public.invites
        where (method = 'email' and value = new.email)
           or (method = 'phone' and value = '+' || new.phone) -- TODO: normalize phone numbers
        loop
            update public.members
            set profile_id            = new.id,
                display_name_override = default
            where members.id = invite.member_id;
            delete from public.invites where invites.member_id = invite.member_id;
        end loop;

    return new;
end;
$$;
comment on function handle_upsert_user() is 'Upsert a profile for a new user and add to groups they have been invited to';

create or replace trigger on_auth_user_updated
    after insert or update
    on auth.users
    for each row
execute function public.handle_upsert_user();
comment on trigger on_auth_user_updated on auth.users is 'Upserts a profile whenever a user is created or updated';

-- The trigger on_auth_user_created is no longer needed as we are now using the on_auth_user_updated trigger.
drop trigger if exists on_auth_user_created on auth.users;

-- We no longer need the handle_new_user function as we are now using the handle_upsert_user function.
drop function if exists handle_new_user() cascade;

-- Updating the profiles must now be done through the handle_update_user function.
-- This is to ensure that the display name and picture are updated when the user is updated.
drop policy if exists "profiles_update" on public.profiles;
