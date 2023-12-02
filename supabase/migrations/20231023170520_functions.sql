create or replace function create_group(
    display_name text,
    description text,
    picture text)
    returns setof groups
    security definer set search_path = public
    language plpgsql as
$$
declare
    new_group record;
begin
    insert into groups (display_name, description, picture)
    values (create_group.display_name, create_group.description, create_group.picture)
    returning * into new_group;
    insert into members (group_id, profile_id, role) values (new_group.id, auth.uid(), 'admin');

    return next new_group;
end;
$$;
comment on function create_group(text, text, text) is 'Creates a group with the given display name and adds the current user as an admin';

create or replace function handle_new_user()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
begin
    insert into public.profiles (id)
    values (new.id);
    return new;
end;
$$;
comment on function handle_new_user() is 'Creates a profile for a new user';

create or replace trigger on_auth_user_created
    after insert
    on auth.users
    for each row
execute procedure public.handle_new_user();
comment on trigger on_auth_user_created on auth.users is 'Creates a profile whenever a new user is created';


-- TODO(borgoat): add a trigger to create a group member when in auth.identities a match is found for an invite

create or replace function check_invites()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
declare
    invite_id bigint;
    group_id  bigint;
begin
    if new.provider <> 'email' or new.provider <> 'phone' then
        return new;
    end if;

    select id, group_id, member_id
    into invite_id, group_id
    from invites
    where method = 'email'
      and value = new.email;

    -- iterate over the invites and add the user to the group

    if invite_id is not null then
        insert into members (group_id, profile_id, role_id)
        values (group_id, new.user_id, 2);
    end if;

    -- TODO(borgoat): delete other invites for the same group/user combination

    return new;
end;
$$;
comment on function check_invites() is 'Checks if the user has been invited to a group and adds them to the group';

create or replace trigger on_auth_identity_created
    after insert
    on auth.identities
    for each row
execute procedure public.check_invites();
comment on trigger on_auth_identity_created on auth.identities is 'When a user signs up the auth method is persisted in the identities table';
