-- Reply cutoffs, the reply_cutoffs feature (docs/billing-and-entitlements.md 9.2):
-- changes to replies close a set time before each occurrence starts.
--
-- replies.instance_date is the occurrence's start as the app computes it: a
-- wall-clock time labelled UTC (18:00 is stored as 18:00Z wherever the group
-- meets). time_zone says where that wall clock hangs, so the server knows the
-- real moment changes close. The app sets it with the cutoff, from the
-- admin's device.
alter table public.schedules
  add column cutoff_minutes_before int check (cutoff_minutes_before between 0 and 10080),
  add column time_zone text,
  add constraint schedules_cutoff_time_zone check (cutoff_minutes_before is null or time_zone is not null);
comment on column public.schedules.cutoff_minutes_before is 'Replies close this many minutes before each occurrence (reply_cutoffs).';
comment on column public.schedules.time_zone is 'The IANA time zone of the wall-clock occurrence times, for cutoffs.';

-- When changes to a reply to the occurrence starting at p_instance close.
create function billing.reply_deadline(p_instance timestamptz, p_minutes int, p_time_zone text)
returns timestamptz language sql stable set search_path = '' as $$
  select ((p_instance at time zone 'UTC') at time zone p_time_zone) - make_interval(mins => p_minutes)
$$;

-- Turning a cutoff on needs the feature; turning it off never does.
create function billing.tg_schedule_cutoff_gate()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.cutoff_minutes_before is not null
     and (tg_op = 'INSERT' or new.cutoff_minutes_before is distinct from old.cutoff_minutes_before)
     and not billing.has_feature(new.group_id, 'reply_cutoffs') then
    raise exception using errcode = 'P0001', message = 'feature_locked';
  end if;
  -- An unknown zone would fail every reply to the schedule: refuse it here.
  perform now() at time zone new.time_zone;
  return new;
end $$;

create trigger schedules_cutoff_gate
  before insert or update of cutoff_minutes_before, time_zone on public.schedules
  for each row execute function billing.tg_schedule_cutoff_gate();

-- After the deadline members can't change or delete their replies. Admins can
-- still answer yes or no, but nobody can delete a reply: that would silently
-- fall back to the default.
create function billing.tg_reply_cutoff()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  r        public.replies;
  v_group  uuid;
  v_cutoff int;
  v_zone   text;
begin
  if tg_op = 'DELETE' then r := old; else r := new; end if;
  select s.group_id, s.cutoff_minutes_before, s.time_zone into v_group, v_cutoff, v_zone
    from public.schedules s where s.id = r.schedule_id;

  if auth.uid() is null                                           -- service role, SQL
     or pg_trigger_depth() > 1                                    -- deleted with its member, schedule or group
     or v_cutoff is null
     or now() < billing.reply_deadline(r.instance_date, v_cutoff, v_zone)
     or not billing.has_feature(v_group, 'reply_cutoffs')
     or (tg_op <> 'DELETE' and public.is_member_of_group(v_group, '{admin}'::public.group_roles[])) then
    return r;
  end if;
  raise exception using errcode = 'P0001', message = 'reply_locked';
end $$;

create trigger replies_cutoff before insert or update or delete on public.replies
  for each row execute function billing.tg_reply_cutoff();

-- Design rule 5 (see 20261025140000).
revoke all on all functions in schema billing from public, anon, authenticated, service_role;
