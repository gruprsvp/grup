-- Profile edits stick (migration 20261024120000).
--
-- handle_upsert_user copies auth metadata into the profile only while the
-- profile still holds the previous metadata value, so an edit made in the app
-- survives a provider rewriting the metadata at sign-in, while old clients
-- (which save the profile as metadata) and Sign in with Apple's late name
-- still reach it. profiles_update_self lets a user edit their own profile.

begin;
select plan(12);

-- ── Setup: Rob signs up with a provider name and picture ───────────────────
insert into auth.users (id, email, raw_user_meta_data) values
  ('11111111-1111-1111-1111-111111111111', 'rob@test.com',
   '{"full_name":"Robert","avatar_url":"https://example.com/a.png"}'),
  ('22222222-2222-2222-2222-222222222222', 'val@test.com', '{"full_name":"Val"}');

select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Robert',
  'sign-up copies the metadata name into the profile'
);

-- An auth update that leaves the metadata alone changes nothing.
update auth.users set last_sign_in_at = now()
where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Robert',
  'a sign-in that keeps the metadata keeps the profile'
);

-- 1.x/2.0.0 clients save the profile as metadata: it still reaches the profile.
update auth.users set raw_user_meta_data = '{"full_name":"Bob","avatar_url":"https://example.com/a.png"}'
where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Bob',
  'a metadata edit reaches a profile that still matches the metadata'
);

-- ── profiles_update_self ───────────────────────────────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

select lives_ok(
  $$ update profiles set display_name = 'Bobby'
     where id = '11111111-1111-1111-1111-111111111111' $$,
  'a user can update their own profile'
);
select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Bobby',
  'the profile update stuck'
);

set local request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';
select lives_ok(
  $$ update profiles set display_name = 'Hacked'
     where id = '11111111-1111-1111-1111-111111111111' $$,
  'an update of another user''s profile does not error'
);
select throws_ok(
  $$ update profiles set id = '11111111-1111-1111-1111-111111111111'
     where id = '22222222-2222-2222-2222-222222222222' $$,
  '42501', null,
  'a user cannot re-point their profile at another user'
);

reset role;
select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Bobby',
  'another user''s profile is untouched (0 rows matched)'
);

-- ── A provider rewrites the metadata at sign-in ────────────────────────────
update auth.users set raw_user_meta_data = '{"full_name":"Robert","avatar_url":"https://example.com/b.png"}'
where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select display_name from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'Bobby',
  'a provider rewriting the metadata keeps the name edited in the app'
);
select is(
  (select picture from profiles where id = '11111111-1111-1111-1111-111111111111'),
  'https://example.com/b.png',
  'a picture never edited in the app follows the metadata'
);

-- A provider sending no name doesn't clear one.
update auth.users set raw_user_meta_data = '{}'
where id = '22222222-2222-2222-2222-222222222222';
select is(
  (select display_name from profiles where id = '22222222-2222-2222-2222-222222222222'),
  'Val',
  'metadata without a name keeps the profile name'
);

-- ── Sign in with Apple: the name arrives in an update after sign-up ────────
insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'apple@test.com');
update auth.users set raw_user_meta_data = '{"full_name":"Ada"}'
where id = '33333333-3333-3333-3333-333333333333';
select is(
  (select display_name from profiles where id = '33333333-3333-3333-3333-333333333333'),
  'Ada',
  'a name that arrives after sign-up fills the profile'
);

select * from finish();
rollback;
