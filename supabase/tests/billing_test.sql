-- Paid plans: privileges, keys, modes, entitlements, the seat cap and launch
-- (docs/billing-and-entitlements.md 16.1).
--
-- Each section sets the mode it needs. Setup runs as postgres, which bypasses
-- row-level security but still fires the seat triggers.

begin;
select plan(51);

-- ── Privileges ─────────────────────────────────────────────────────────────
select ok(not has_schema_privilege('anon', 'billing', 'usage'), 'anon has no usage on schema billing');
select ok(not has_schema_privilege('authenticated', 'billing', 'usage'), 'authenticated has no usage on schema billing');
select ok(not has_schema_privilege('service_role', 'billing', 'usage'), 'service_role has no usage on schema billing');
select is_empty(
  $$
    select c.relname, r from pg_class c
    cross join unnest(array['anon', 'authenticated', 'service_role']) r
    where c.relnamespace = 'billing'::regnamespace and c.relkind in ('r', 'p', 'v', 'm')
      and has_table_privilege(r, c.oid, 'select, insert, update, delete, truncate, references, trigger')
  $$,
  'no API role holds a privilege on a billing table or view'
);
select is_empty(
  $$
    select p.oid::regprocedure, r from pg_proc p
    cross join unnest(array['anon', 'authenticated', 'service_role']) r
    where p.pronamespace = 'billing'::regnamespace and has_function_privilege(r, p.oid, 'execute')
  $$,
  'no API role can execute a billing function'
);
select ok(has_function_privilege('authenticated', 'public.billing_state()', 'execute'), 'authenticated can execute billing_state');
select ok(not has_function_privilege('anon', 'public.billing_state()', 'execute'), 'anon cannot execute billing_state');

-- ── Setup ──────────────────────────────────────────────────────────────────
-- Alice signed up before the announcement (a founder); the others after.
insert into auth.users (id, email, created_at) values
  ('aaaaaaaa-0000-0000-0000-000000000001', 'alice@billing.test', '2025-01-01'),
  ('aaaaaaaa-0000-0000-0000-000000000002', 'bob@billing.test', now()),
  ('aaaaaaaa-0000-0000-0000-000000000003', 'carol@billing.test', now()),
  ('aaaaaaaa-0000-0000-0000-000000000005', 'erin@billing.test', now()),
  ('aaaaaaaa-0000-0000-0000-000000000006', 'frank@billing.test', now());

-- Groups by purpose: old (created before the cutoff) and the rest (now).
insert into groups (id, display_name, created_at) values
  ('bbbbbbbb-0000-0000-0000-000000000001', 'Old club', '2025-06-01'),
  ('bbbbbbbb-0000-0000-0000-000000000002', 'Plain', now()),
  ('bbbbbbbb-0000-0000-0000-000000000003', 'Granted', now()),
  ('bbbbbbbb-0000-0000-0000-000000000004', 'Subscribed', now()),
  ('bbbbbbbb-0000-0000-0000-000000000005', 'Seats', now()),
  ('bbbbbbbb-0000-0000-0000-000000000006', 'Funded', now()),
  ('bbbbbbbb-0000-0000-0000-000000000007', 'Other', now());

-- Alice administers every group; Bob is a plain member of 'Funded'.
insert into members (group_id, profile_id, role)
select id, 'aaaaaaaa-0000-0000-0000-000000000001', 'admin' from groups where display_name in
  ('Old club', 'Plain', 'Granted', 'Subscribed', 'Seats', 'Funded', 'Other');
insert into members (group_id, profile_id, role) values
  ('bbbbbbbb-0000-0000-0000-000000000006', 'aaaaaaaa-0000-0000-0000-000000000002', 'member');

-- ── Modes ──────────────────────────────────────────────────────────────────
select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000002') - 'sources',
  '{"features": ["export_csv", "kitchen_view", "reply_cutoffs"], "limits": {}}',
  'unlocked (the default): every feature, no limits'
);

select billing.set_mode('prelaunch');
select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000002') - 'sources',
  '{"features": [], "limits": {}}',
  'prelaunch: no features, no limits'
);

select throws_ok(
  $$ select billing.set_mode('live') $$,
  '23514', null,
  'live without a cutoff violates live_requires_cutoff'
);

update billing.config set mode = 'live', cutoff_at = '2026-01-01';
select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000002'),
  '{"features": [], "limits": {"max_seats": 10}, "sources": []}',
  'live, free only: no features, 10 seats'
);

-- ── Entitlements (live) ────────────────────────────────────────────────────
insert into billing.grants (group_id, source, features, limits, ends_at) values
  ('bbbbbbbb-0000-0000-0000-000000000003', 'manual', '{kitchen_view}', '{"max_seats": 15}', now() + interval '1 day'),
  ('bbbbbbbb-0000-0000-0000-000000000003', 'early_access', '{export_csv}', '{}', null),
  ('bbbbbbbb-0000-0000-0000-000000000003', 'manual', '{reply_cutoffs}', '{"max_seats": 99}', now() - interval '1 second');

select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000003') -> 'features',
  '["export_csv", "kitchen_view"]',
  'grants add their features, unioned with the free plan''s; an expired grant is ignored'
);
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000003', 'max_seats'),
  15,
  'per limit the maximum wins (a grant''s 15 over the free 10, not the expired 99)'
);
select is(
  jsonb_array_length(billing.entitlements('bbbbbbbb-0000-0000-0000-000000000003') -> 'sources'),
  2,
  'sources list the live grants only'
);

-- Subscriptions: Alice pays for 'Subscribed'.
insert into billing.customers (id, user_id, stripe_customer_id) values
  ('dddddddd-0000-0000-0000-000000000001', 'aaaaaaaa-0000-0000-0000-000000000001', 'cus_alice'),
  ('dddddddd-0000-0000-0000-000000000002', 'aaaaaaaa-0000-0000-0000-000000000002', 'cus_bob');

insert into billing.subscriptions (customer_id, provider, provider_ref, plan_id, group_id, status, current_period_end)
select 'dddddddd-0000-0000-0000-000000000001', 'manual', 'sub-active', p.id,
       'bbbbbbbb-0000-0000-0000-000000000004', 'active', now() + interval '1 month'
  from billing.plans p where p.code = 'community_m' and p.current;

select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000004') - 'sources',
  '{"features": ["export_csv", "kitchen_view", "reply_cutoffs"], "limits": {"max_seats": 40}}',
  'an entitled subscription gives its plan''s features and limits'
);
select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000004') -> 'sources' -> 0,
  jsonb_build_object('kind', 'subscription', 'plan', 'community_m', 'rank', 20, 'provider', 'manual',
                     'status', 'active', 'payer', 'aaaaaaaa-0000-0000-0000-000000000001',
                     'until', now() + interval '1 month', 'renews', true),
  'a subscription source says who pays, for which plan, until when'
);

update billing.subscriptions set status = 'billing_retry' where provider_ref = 'sub-active';
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000004', 'max_seats'),
  10,
  'a subscription that is not entitled gives nothing'
);

update billing.subscriptions set status = 'canceled_pending', current_period_end = now() - interval '6 days'
 where provider_ref = 'sub-active';
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000004', 'max_seats'),
  40,
  'a period that ended less than a week ago is still honoured (webhooks may be late)'
);

update billing.subscriptions set current_period_end = now() - interval '8 days' where provider_ref = 'sub-active';
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000004', 'max_seats'),
  10,
  'a period that ended more than a week ago is not'
);

update billing.subscriptions set current_period_end = now() + interval '1 month' where provider_ref = 'sub-active';
insert into billing.grants (group_id, source, limits) values
  ('bbbbbbbb-0000-0000-0000-000000000004', 'legacy', '{"max_seats": null}');
select is(
  billing.entitlements('bbbbbbbb-0000-0000-0000-000000000004') -> 'limits',
  '{"max_seats": null}',
  'for a limit, null (unlimited) beats any number'
);
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000004', 'max_seats'),
  null,
  'limit_value reads null as unlimited'
);
select ok(
  billing.has_feature('bbbbbbbb-0000-0000-0000-000000000004', 'kitchen_view')
    and not billing.has_feature('bbbbbbbb-0000-0000-0000-000000000002', 'kitchen_view'),
  'has_feature follows the entitlements'
);

-- ── Seats ──────────────────────────────────────────────────────────────────
-- A 3-seat free plan keeps the setup short. 'Seats' has Alice (one seat) and
-- three members the admins manage: no account, no invite.
update billing.plans set limits = '{"max_seats": 3}' where code = 'free' and current;
insert into members (id, group_id, display_name_override) values
  ('cccccccc-0000-0000-0000-000000000001', 'bbbbbbbb-0000-0000-0000-000000000005', 'Mo'),
  ('cccccccc-0000-0000-0000-000000000002', 'bbbbbbbb-0000-0000-0000-000000000005', 'Max'),
  ('cccccccc-0000-0000-0000-000000000003', 'bbbbbbbb-0000-0000-0000-000000000005', 'Mia');

select is(billing.seats('bbbbbbbb-0000-0000-0000-000000000005'), 1, 'managed members never take a seat');

set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000001","role":"authenticated"}';

select lives_ok(
  $$ insert into invites (member_id, method, value) values
       ('cccccccc-0000-0000-0000-000000000001', 'email', 'dave@billing.test') $$,
  'inviting a managed member takes a seat'
);
select lives_ok(
  $$ insert into invites (member_id, method, value) values
       ('cccccccc-0000-0000-0000-000000000002', 'code', 'SEAT-CODE') $$,
  'the last free seat can be taken'
);
reset role;
select is(billing.seats('bbbbbbbb-0000-0000-0000-000000000005'), 3, 'pending invites take seats');
set local role authenticated;
select lives_ok(
  $$ insert into invites (member_id, method, value) values
       ('cccccccc-0000-0000-0000-000000000001', 'code', 'SEAT-CODE-2') $$,
  'a second invite for an invited member passes: it holds its seat already'
);
select throws_ok(
  $$ insert into invites (member_id, method, value) values
       ('cccccccc-0000-0000-0000-000000000003', 'email', 'mia@billing.test') $$,
  'P0001', 'group_full',
  'an invite into a full group raises group_full'
);
select throws_ok(
  $$ update members set profile_id = 'aaaaaaaa-0000-0000-0000-000000000005'
      where id = 'cccccccc-0000-0000-0000-000000000003' $$,
  'P0001', 'group_full',
  'an admin linking an account to an uninvited member of a full group raises group_full'
);
select throws_ok(
  $$ insert into members (group_id, profile_id) values
       ('bbbbbbbb-0000-0000-0000-000000000005', 'aaaaaaaa-0000-0000-0000-000000000006') $$,
  'P0001', 'group_full',
  'adding an account member to a full group raises group_full'
);
select throws_ok(
  $$ update members set group_id = 'bbbbbbbb-0000-0000-0000-000000000007'
      where id = 'cccccccc-0000-0000-0000-000000000001' $$,
  '42501', null,
  'a member can''t be moved to another group, even by an admin of both'
);

-- Following an invite never fails: the invite already holds its seat.
set local request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000003","role":"authenticated"}';
select lives_ok(
  $$ select consume_invite_code('SEAT-CODE') $$,
  'redeeming an invite code in a full group passes'
);
reset role;
select lives_ok(
  $$ insert into auth.users (id, email, created_at) values
       ('aaaaaaaa-0000-0000-0000-000000000004', 'dave@billing.test', now()) $$,
  'signing up with an invited email in a full group passes'
);
select is(
  (select count(*)::int from members
    where group_id = 'bbbbbbbb-0000-0000-0000-000000000005' and profile_id is not null),
  3,
  'both invitees joined'
);

-- The cap only applies while live, and never to a legacy group.
select billing.set_mode('prelaunch');
insert into invites (member_id, method, value) values
  ('cccccccc-0000-0000-0000-000000000003', 'email', 'mia@billing.test');
select is(billing.seats('bbbbbbbb-0000-0000-0000-000000000005'), 4, 'no cap outside live');

update billing.config set mode = 'live';
select throws_ok(
  $$ insert into members (group_id, profile_id) values
       ('bbbbbbbb-0000-0000-0000-000000000005', 'aaaaaaaa-0000-0000-0000-000000000006') $$,
  'P0001', 'group_full',
  'a group over its limit keeps everyone but takes no new seat'
);
insert into billing.grants (group_id, source, limits) values
  ('bbbbbbbb-0000-0000-0000-000000000005', 'legacy', '{"max_seats": null}');
select lives_ok(
  $$ insert into members (group_id, profile_id) values
       ('bbbbbbbb-0000-0000-0000-000000000005', 'aaaaaaaa-0000-0000-0000-000000000006') $$,
  'a legacy group has no seat limit'
);
update billing.plans set limits = '{"max_seats": 10}' where code = 'free' and current;

-- ── billing_state ──────────────────────────────────────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000001","role":"authenticated"}';
select is(
  (select jsonb_build_object('mode', s -> 'mode', 'is_founder', s -> 'is_founder', 'is_customer', s -> 'is_customer',
                             'groups', (select count(*) from jsonb_object_keys(s -> 'groups')),
                             'plans', jsonb_path_query_array(s, '$.catalog[*].plan'))
     from billing_state() s),
  '{"mode": "live", "is_founder": true, "is_customer": true, "groups": 7,
    "plans": ["community_s", "community_m", "community_l"]}',
  'billing_state: the mode, the user''s standing, their groups and the plans on sale'
);
select is(
  billing_state() #> '{groups,bbbbbbbb-0000-0000-0000-000000000005,seats}',
  '5',
  'billing_state gives each group''s seats'
);
set local request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000003","role":"authenticated"}';
select is(
  (select jsonb_build_object('is_founder', s -> 'is_founder', 'is_customer', s -> 'is_customer',
                             'groups', jsonb_path_query_array(s -> 'groups', '$.keyvalue().key'))
     from billing_state() s),
  '{"is_founder": false, "is_customer": false, "groups": ["bbbbbbbb-0000-0000-0000-000000000005"]}',
  'billing_state shows only the user''s own groups'
);
reset role;

-- ── Launch ─────────────────────────────────────────────────────────────────
delete from billing.grants;
update billing.config set mode = 'unlocked', cutoff_at = null;
select throws_ok(
  $$ select billing.launch('2026-01-01') $$,
  'P0001', 'launch needs prelaunch mode, not unlocked',
  'launch refuses to run outside prelaunch (self-hosted installs stay unlocked)'
);
select billing.set_mode('prelaunch');
select throws_ok(
  $$ select billing.launch(now() + interval '1 day') $$,
  'P0001', null,
  'launch refuses a cutoff in the future'
);
select lives_ok($$ select billing.launch('2026-01-01') $$, 'launch runs in prelaunch');
select is_empty(
  $$
    select g.id from groups g
    where (select count(*) from billing.grants b where b.group_id = g.id and b.source = 'legacy')
       <> (g.created_at < '2026-01-01')::int
  $$,
  'launch gives exactly the groups created before the cutoff one legacy grant'
);
select is_empty(
  $$
    select g.id from groups g
    where (select count(*) from billing.grants b
            where b.group_id = g.id and b.source = 'founder_trial' and b.ends_at = now() + interval '6 months'
              and b.features @> '{kitchen_view,reply_cutoffs,export_csv}')
       <> (g.created_at < '2026-01-01')::int
  $$,
  '... and one founder trial with Community''s features, for 6 months from launch'
);
select is(
  (select row(mode, cutoff_at)::text from billing.config),
  row('live'::billing.mode, '2026-01-01'::timestamptz)::text,
  'launch goes live with the cutoff'
);
select throws_ok(
  $$ select billing.launch('2026-01-01') $$,
  'P0001', null,
  'launch refuses a second run'
);
select is(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000002', 'max_seats'),
  10,
  'a group created after the cutoff is capped at 10 seats'
);
select ok(
  billing.limit_value('bbbbbbbb-0000-0000-0000-000000000001', 'max_seats') is null
    and billing.has_feature('bbbbbbbb-0000-0000-0000-000000000001', 'reply_cutoffs'),
  'a legacy group has no seat limit and Community features'
);

-- ── Keys (4.2) ─────────────────────────────────────────────────────────────
select is_empty(
  $$
    select k from billing.plans, unnest(features) k
    union select k from billing.grants, unnest(features) k
    except select unnest(array['kitchen_view', 'reply_cutoffs', 'export_csv'])
  $$,
  'every feature key in plans and grants is a pinned one'
);
select is_empty(
  $$
    select k from billing.plans, jsonb_object_keys(limits) k
    union select k from billing.grants, jsonb_object_keys(limits) k
    except select 'max_seats'
  $$,
  'every limit key in plans and grants is a pinned one'
);

select * from finish();
rollback;
