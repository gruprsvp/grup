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
execute function public.handle_new_user();
comment on trigger on_auth_user_created on auth.users is 'Creates a profile whenever a new user is created';

create or replace function public.handle_delete_user()
    returns trigger
    language plpgsql
    security definer
as
$$
declare
    group_record record;
begin
    for group_record in
        select g.id
        from public.groups g
        join public.members m on g.id = m.group_id
        where m.profile_id = old.id and m.role = 'admin'
    loop
        if (select count(*) from public.members where group_id = group_record.id and role = 'admin') > 1 then
            -- More than one admin, do nothing
            continue;
        elsif (select count(*) from public.members where group_id = group_record.id) > 1 then
            -- Only one admin but more members, assign admin role to another member
            update public.members
            set role = 'admin'
            where id = (select id from public.members where group_id = group_record.id and profile_id != old.id limit 1);
        else
            -- Only one admin and no other members, delete the group
            delete from public.groups where id = group_record.id;
        end if;
    end loop;
    
    delete from public.profiles where id = old.id;

    return old;
end;
$$;
comment on function public.handle_delete_user() is 'Deletes a profile when a user is deleted';

create or replace trigger on_auth_user_deleted
    before delete on auth.users
    for each row
    execute function public.handle_delete_user();
comment on trigger on_auth_user_deleted on auth.users is 'Trigger to delete a profile when a user is deleted';

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

create or replace function handle_new_invite()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
declare
    user_id uuid;
begin
    select id into user_id
    from auth.users 
    where 
        case 
            when new.method = 'email' then email = new.value
            when new.method = 'phone' then phone = new.value
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

create or replace trigger on_invite_created
    after insert
    on invites
    for each row
execute function public.handle_new_invite();
comment on trigger on_auth_user_created on auth.users is 'Updates members whenever an invite is created';
