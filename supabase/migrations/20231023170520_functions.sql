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
    -- TODO(borgoat): check subscription status

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
declare
    invite record;
begin
    insert into public.profiles (id) values (new.id);

    for invite in
        select *
        from public.invites
        where (method = 'email' and value = new.email)
           or (method = 'phone' and value = '+' || new.phone) -- TODO(borgoat): normalize phone numbers
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
comment on function handle_new_user() is 'Creates a profile for a new user and add to groups they have been invited to';

create or replace trigger on_auth_user_created
    after insert
    on auth.users
    for each row
execute procedure public.handle_new_user();
comment on trigger on_auth_user_created on auth.users is 'Creates a profile whenever a new user is created';

-- TODO(borgoat): add a trigger to manage a phone number/email being added after sign up instead

create or replace function check_invite_code(code text)
    returns bigint
    language plpgsql
    security definer set search_path = public as
$$
declare
    id bigint;
begin
    select member_id from invites where method = 'code' and value = check_invite_code.code into strict id;
    return id;
end;
$$;
comment on function check_invite_code(text) is 'Checks if an invite code is valid and returns the member_id if it is';

create or replace function consume_invite_code(code text)
    returns void
    language plpgsql
    security definer set search_path = public as
$$
declare
    new_member_id bigint;
begin
    select check_invite_code(code) into strict new_member_id;

    if new_member_id is null then
        raise exception 'Invalid invite code';
    end if;

    update members set profile_id = auth.uid(), display_name_override = default where members.id = new_member_id;
    delete from invites where invites.member_id = new_member_id;
end;
$$;
comment on function consume_invite_code(text) is 'Adds the current user to a group based on an invite code';
