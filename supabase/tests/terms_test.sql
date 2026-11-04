-- Accepting the terms (migration 20261104130000, docs/billing-and-entitlements.md 8.6).

begin;
select plan(11);

insert into auth.users (id, email) values
  ('aaaaaaaa-2222-0000-0000-000000000001', 'alice@terms.test'),
  ('aaaaaaaa-2222-0000-0000-000000000002', 'bob@terms.test');

set local role authenticated;
set local request.jwt.claims to '{"sub":"aaaaaaaa-2222-0000-0000-000000000001","role":"authenticated"}';

select is(billing_state() -> 'terms_version', 'null'::jsonb, 'no version is set by default (self-hosted)');
select is(billing_state() -> 'terms_accepted', 'false'::jsonb, 'so nothing is accepted');

reset role;
update billing.config set terms_version = '2026-11-15';
set local role authenticated;

select is(billing_state() ->> 'terms_version', '2026-11-15', 'billing_state gives the version in force');
select is(billing_state() -> 'terms_accepted', 'false'::jsonb, 'not yet accepted');

select lives_ok(
  $$ insert into public.terms_acceptances (version) values ('2026-11-15') $$,
  'a user records their acceptance'
);
select is(billing_state() -> 'terms_accepted', 'true'::jsonb, 'then billing_state says it is accepted');
select is(
  (select user_id from public.terms_acceptances), 'aaaaaaaa-2222-0000-0000-000000000001',
  'the row is the user''s own'
);

select throws_ok(
  $$ insert into public.terms_acceptances (user_id, version)
     values ('aaaaaaaa-2222-0000-0000-000000000002', '2026-11-15') $$,
  '42501', null,
  'nobody records an acceptance for someone else'
);
select throws_ok(
  $$ insert into public.terms_acceptances (version, accepted_at) values ('2026-01-01', '2026-01-01') $$,
  '42501', null,
  'nor backdates one'
);

update public.terms_acceptances set accepted_at = '2026-01-01';
delete from public.terms_acceptances;
select is(
  (select count(*) from public.terms_acceptances where accepted_at = now())::int, 1,
  'an acceptance can''t be changed or withdrawn'
);

set local request.jwt.claims to '{"sub":"aaaaaaaa-2222-0000-0000-000000000002","role":"authenticated"}';
select is_empty($$ select * from public.terms_acceptances $$, 'users see only their own acceptances');

select * from finish();
rollback;
