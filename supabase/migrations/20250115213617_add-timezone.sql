alter table if exists schedules
  add column if not exists timezone text not null default 'Europe/Zurich';

alter table if exists replies
  alter column instance_date type timestamp using instance_date::timestamp;
