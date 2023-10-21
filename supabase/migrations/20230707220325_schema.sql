drop table if exists replies;
drop table if exists default_replies;
drop table if exists schedules;
drop table if exists invites;
drop table if exists members;
drop table if exists groups;
drop table if exists profiles;
drop type if exists reply_options;
drop domain if exists rfc5545;

create type reply_options as enum ('yes', 'no');
comment on type reply_options is 'Valid replies that users may select.';

create type invite_methods as enum ('email', 'phone', 'code');
comment on type invite_methods is 'The available strategies to invite a new user';

-- TODO handle RFC-7265 JSON format, validation, optional extensions
create domain rfc5545 as text;
comment on domain rfc5545 is 'An alias for text-based RFC5545 recurrence rule definitions.';

create table profiles (
  id uuid not null references auth.users on delete cascade primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  display_name text not null
);
comment on table profiles is 'User profiles that apply across multiple groups.';
comment on column profiles.display_name is 'The user name, as seen by other users.';

create table groups (
  id bigint generated always as identity primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  display_name text not null
);
comment on table groups is 'Group of users that share roles, schedules, replies.';
comment on column groups.display_name is 'The group name.';

create table members (
  id bigint generated always as identity primary key,
  group_id bigint not null references groups,
  profile_id uuid references profiles,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

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

create table invites (
  id bigint generated always as identity primary key,
  member_id bigint not null references members on delete cascade,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  method invite_methods not null,
  value text not null
);
comment on table invites is 'Invites define a mapping for new users, to become members of groups.';

create table schedules (
  id bigint generated always as identity primary key,
  group_id bigint not null references groups on delete cascade,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  -- TODO invitees default replies per schedule

  display_name text not null,
  recurrence_rule rfc5545 not null
);
comment on table schedules is 'Schedules are a series of events within a group.';
comment on column schedules.display_name is 'A name for the schedule';
comment on column schedules.recurrence_rule is 'The rrule that defines when events are scheduled.';

create table default_replies (
  id bigint generated always as identity primary key,
  member_id bigint not null references members on delete cascade,
  schedule_id bigint not null references schedules on delete cascade,

  selected_option reply_options not null,
  recurrence_rule rfc5545 not null
);
comment on table default_replies is 'The default replies for each member, per schedule.';
comment on column default_replies.recurrence_rule is 'Must be equal or a subset of the corresponding schedule rule.';

create table replies (
  id bigint generated always as identity primary key,
  member_id bigint not null references members on delete cascade,
  schedule_id bigint not null references schedules on delete cascade,
  event_date timestamp not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  selected_option reply_options not null,

  unique (member_id, schedule_id, event_date)
);
comment on table replies is 'Override the default replies set per schedule/profile.';
comment on column replies.member_id is 'The member (either with a related profile or not) that overrides their default reply.';
comment on column replies.event_date is 'Defines the actual occurrence for the override reply.';

alter table profiles enable row level security;
alter table groups enable row level security;
alter table members enable row level security;
alter table schedules enable row level security;
alter table default_replies enable row level security;
alter table replies enable row level security;

