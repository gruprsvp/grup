drop table if exists replies;
drop table if exists default_replies;
drop table if exists schedules;
drop table if exists invites;
drop table if exists members;
drop table if exists groups;
drop table if exists profiles;
drop table if exists roles;
drop type if exists invite_methods;
drop type if exists reply_options;
drop domain if exists rfc7265;

create type reply_options as enum ('yes', 'no');
comment on type reply_options is 'Valid replies that users may select.';

create type invite_methods as enum ('email', 'phone', 'code');
comment on type invite_methods is 'The available strategies to invite a new user';

-- TODO handle validation, optional extensions
create domain rfc7265 as jsonb;
comment on domain rfc7265 is 'An alias for RFC7265 jCal (JSON) recurrence rule definitions.';

create table roles
(
    id                   bigint generated always as identity primary key,
    created_at           timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at           timestamp with time zone default timezone('utc'::text, now()) not null,

    display_name         text                                                          not null,
    can_manage_group     boolean                                                       not null,
    can_manage_members   boolean                                                       not null,
    can_manage_invites   boolean                                                       not null,
    can_manage_schedules boolean                                                       not null,
    can_manage_replies   boolean                                                       not null
);
comment on table roles is 'Roles define the permissions for each group member.';

create table profiles
(
    id           uuid                                                          not null references auth.users on delete cascade primary key,
    created_at   timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at   timestamp with time zone default timezone('utc'::text, now()) not null,

    display_name text,
    picture      text
);
comment on table profiles is 'User profiles that apply across multiple groups.';
comment on column profiles.display_name is 'The user name, as seen by other users.';
comment on column profiles.picture is 'A URL to the user profile picture.';

create table groups
(
    id           bigint generated always as identity primary key,
    created_at   timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at   timestamp with time zone default timezone('utc'::text, now()) not null,

    display_name text                                                          not null
);
comment on table groups is 'Group of users that share roles, schedules, replies.';
comment on column groups.display_name is 'The group name.';

create table members
(
    id                    bigint generated always as identity primary key,
    created_at            timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at            timestamp with time zone default timezone('utc'::text, now()) not null,

    group_id              bigint                                                        not null references groups,
    role_id               bigint                                                        not null references roles,
    profile_id            uuid references profiles,

    -- TODO a group should be able to insert a profile with default replies before it even exists...
    --      therefore, we need a way to "invite" new members, so that when users sign up,
    --      they become owners of their own member_ids, and can override replies

    display_name_override text,

    unique (group_id, profile_id),

    -- if there's no profile linked yet, a display name must be set
    -- a user may also override their display name as members of a specific group
    constraint must_have_display_name_or_profile
        check (display_name_override is not null or profile_id is not null)
);
comment on table members is 'Define invitees and user membership in groups.';
comment on column members.display_name_override is 'In case a user wants to be known by another name in that specific group.';

create table invites
(
    id         bigint generated always as identity primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

    member_id  bigint                                                        not null references members on delete cascade,

    method     invite_methods                                                not null,
    value      text                                                          not null
);
comment on table invites is 'Invites define a mapping for new users, to become members of groups.';

create table schedules
(
    id              bigint generated always as identity primary key,
    created_at      timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at      timestamp with time zone default timezone('utc'::text, now()) not null,

    group_id        bigint                                                        not null references groups on delete cascade,

    display_name    text                                                          not null,
    recurrence_rule rfc7265                                                       not null
);
comment on table schedules is 'Schedules are a series of events within a group.';
comment on column schedules.display_name is 'A name for the schedule';
comment on column schedules.recurrence_rule is 'The rrule that defines when events are scheduled.';

create table default_replies
(
    id              bigint generated always as identity primary key,
    created_at      timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at      timestamp with time zone default timezone('utc'::text, now()) not null,

    member_id       bigint                                                        not null references members on delete cascade,
    schedule_id     bigint                                                        not null references schedules on delete cascade,

    selected_option reply_options                                                 not null,
    recurrence_rule rfc7265                                                       not null
);
comment on table default_replies is 'The default replies for each member, per schedule.';
comment on column default_replies.recurrence_rule is 'Must be equal or a subset of the corresponding schedule rule.';

create table replies
(
    id              bigint generated always as identity primary key,
    created_at      timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at      timestamp with time zone default timezone('utc'::text, now()) not null,

    member_id       bigint                                                        not null references members on delete cascade,
    schedule_id     bigint                                                        not null references schedules on delete cascade,
    event_date      timestamp                                                     not null,

    selected_option reply_options                                                 not null,

    unique (member_id, schedule_id, event_date)
);
comment on table replies is 'Override the default replies set per schedule/profile.';
comment on column replies.member_id is 'The member (either with a related profile or not) that overrides their default reply.';
comment on column replies.event_date is 'Defines the actual occurrence for the override reply.';

create extension if not exists moddatetime schema extensions;

create trigger handle_roles_updated_at
    before update
    on roles
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_profiles_updated_at
    before update
    on profiles
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_groups_updated_at
    before update
    on groups
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_invites_updated_at
    before update
    on invites
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_members_updated_at
    before update
    on members
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_schedules_updated_at
    before update
    on schedules
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_default_replies_updated_at
    before update
    on default_replies
    for each row
execute procedure moddatetime(updated_at);
create trigger handle_replies_updated_at
    before update
    on replies
    for each row
execute procedure moddatetime(updated_at);


alter table roles
    enable row level security;
alter table profiles
    enable row level security;
alter table groups
    enable row level security;
alter table invites
    enable row level security;
alter table members
    enable row level security;
alter table schedules
    enable row level security;
alter table default_replies
    enable row level security;
alter table replies
    enable row level security;

create or replace function is_user_member_of_group(check_group_id bigint)
    returns boolean as
$$
begin
    return exists (select 1
                   from members
                   where profile_id = auth.uid()
                     and group_id = check_group_id);
end;
$$ language plpgsql;

create policy "Users can read their own profile"
    on profiles
    for select using (id = auth.uid());

create policy "Users can write their own profile"
    on profiles
    for update
    using (id = auth.uid())
    with check (id = auth.uid());

-- create policy "Only group members can read group data"
--     on groups
--     for select using (is_user_member_of_group(id));
--
-- create policy "Only group members can read member data"
--     on members
--     for select using (is_user_member_of_group(group_id));
--
-- create policy "Only group members can read schedule data"
--     on schedules
--     for select using (is_user_member_of_group(group_id));
--
-- create policy "Only group members can read default reply data"
--     on default_replies
--     for select using (is_user_member_of_group(
--         (select group_id
--          from schedules
--          where id = schedule_id)));
