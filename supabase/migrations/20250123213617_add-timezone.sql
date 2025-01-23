alter table if exists schedules
  add column if not exists timezone text not null default 'Europe/Zurich';

-- Replies Table migration
-- 1. Remove the primary key constraint
-- 2. Change the instance_date column type to timestamp
-- 3. Add a new column id
-- 4. Update the id column with the member_id, schedule_id, and instance_date
-- 5. Add a new primary key constraint on the id column
do $$
begin
    if exists (select 1 from pg_constraint where conrelid = 'replies'::regclass and contype = 'p') then
        execute 'alter table replies drop constraint ' || (select conname from pg_constraint where conrelid = 'replies'::regclass and contype = 'p');
end if;
end $$;

alter table if exists replies
  alter column instance_date type timestamp using instance_date::timestamp;

alter table if exists replies
    add column if not exists id text;

update replies
set id = member_id || '-' || schedule_id || '-' || instance_date;

alter table if exists replies
alter column id set not null,
    add primary key (id);

-- Default Rules Table migration
-- 1. Remove the primary key constraint
-- 2. Add a new column id
-- 3. Update the id column with the member_id and schedule_id
-- 4. Add a new primary key constraint on the id column
do $$
begin
    if exists (select 1 from pg_constraint where conrelid = 'default_rules'::regclass and contype = 'p') then
        execute 'alter table default_rules drop constraint ' || (select conname from pg_constraint where conrelid = 'default_rules'::regclass and contype = 'p');
end if;
end $$;

alter table if exists default_rules
    add column if not exists id text;

update default_rules
set id = member_id || '-' || schedule_id;

alter table if exists default_rules
alter column id set not null,
    add primary key (id);