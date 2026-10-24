-- Profile and member names the user set stay set (MODERNIZATION.md
-- "Database residuals").

-- The app now writes its profile edits to `profiles` directly. Until now
-- they went through auth metadata, which providers rewrite at sign-in.
create policy "profiles_update_self"
    on profiles
    for update
    to authenticated
    using (id = (select auth.uid()))
    with check (id = (select auth.uid()));
comment on policy "profiles_update_self" on profiles is 'Users can edit their own profile';

-- handle_upsert_user copied full_name/avatar_url into the profile on every
-- auth.users update, so a provider rewriting its metadata at sign-in
-- overwrote an in-app edit. Copy a field only while the profile still holds
-- the previous metadata value: an edit in the app (any value that differs)
-- is kept, while a profile that was never edited in the app follows its
-- metadata. That covers Sign in with Apple's late name (null → name) and
-- 1.x/2.0.0 clients, which still save the profile as auth metadata.
create or replace function handle_upsert_user()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
declare
    invite public.invites;
begin
    -- On insert, `old` is null and the row is new: no conflict.
    insert into public.profiles (id, display_name, picture)
    values (new.id, new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'avatar_url')
    on conflict (id) do update set
        display_name = case
            when profiles.display_name is not distinct from old.raw_user_meta_data ->> 'full_name'
                then coalesce(excluded.display_name, profiles.display_name)
            else profiles.display_name end,
        picture      = case
            when profiles.picture is not distinct from old.raw_user_meta_data ->> 'avatar_url'
                then coalesce(excluded.picture, profiles.picture)
            else profiles.picture end;

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

revoke execute on function public.handle_upsert_user() from public, anon, authenticated;

-- An invite for an existing user now drops the name the admin typed for the
-- invitee, as the other two claim paths (handle_upsert_user and
-- consume_invite_code) already do: the member shows the user's own name.
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
        set profile_id            = user_id,
            display_name_override = default
        where id = new.member_id;

        delete from invites where member_id = new.member_id;
    end if;

    return new;
end;
$$;
comment on function handle_new_invite() is 'Updates members whenever an invite for an existing profile is created';

revoke execute on function public.handle_new_invite() from public, anon, authenticated;
