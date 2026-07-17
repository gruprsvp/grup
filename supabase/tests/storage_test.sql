-- Storage RLS tests: the three policies on storage.objects for the 'public'
-- bucket (folder-scoped INSERT, owner-scoped SELECT and DELETE).
--
-- Inserts go straight into storage.objects (no storage-api in the test DB), so
-- owner_id — normally stamped by the storage service — is set explicitly to
-- mirror what an authenticated upload produces.
--
-- The DELETE policy cannot be exercised behaviorally here: the storage service
-- installs a statement-level protect_objects_delete trigger that rejects ALL
-- direct SQL deletes (the API deletes with it suspended), and the test
-- connection (postgres) cannot disable a trigger on a table owned by
-- supabase_storage_admin. It is pinned declaratively instead.

begin;
select plan(7);

-- ── Setup ──────────────────────────────────────────────────────────────────
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'alice@test.com'),
  ('22222222-2222-2222-2222-222222222222', 'bob@test.com');

-- ── Alice ──────────────────────────────────────────────────────────────────
set local role authenticated;
set local request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

-- INSERT policy, positive: upload under your own user folder.
select lives_ok(
  $$ insert into storage.objects (bucket_id, name, owner_id)
     values ('public',
             '11111111-1111-1111-1111-111111111111/avatar.png',
             '11111111-1111-1111-1111-111111111111') $$,
  'a user can upload into their own folder in the public bucket'
);

-- INSERT policy, negative: another user's folder is off limits.
select throws_ok(
  $$ insert into storage.objects (bucket_id, name, owner_id)
     values ('public',
             '22222222-2222-2222-2222-222222222222/sneaky.png',
             '11111111-1111-1111-1111-111111111111') $$,
  '42501', null,
  'a user cannot upload into another user''s folder'
);

-- SELECT policy, positive: owners see their own objects.
select is(
  (select count(*)::int from storage.objects
   where bucket_id = 'public'
     and name = '11111111-1111-1111-1111-111111111111/avatar.png'),
  1,
  'a user can read their own uploaded object'
);

-- ── Bob ────────────────────────────────────────────────────────────────────
set local request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

-- SELECT policy, negative: object listing is owner-scoped (the bucket itself
-- is public, so files are still world-readable via the public URL — this
-- policy only gates the storage list/select API).
select is(
  (select count(*)::int from storage.objects
   where bucket_id = 'public'
     and name = '11111111-1111-1111-1111-111111111111/avatar.png'),
  0,
  'a user cannot list another user''s objects'
);

-- ── DELETE policy, declarative (see header) ────────────────────────────────
set local role postgres;

select policies_are(
  'storage', 'objects',
  array[
    'Allow authenticated uploads to public',
    'Allow users to read their own public files',
    'Allow users to delete their own public files'
  ],
  'storage.objects has exactly the three expected policies'
);

select policy_cmd_is(
  'storage', 'objects', 'Allow users to delete their own public files', 'DELETE',
  'the delete policy applies to DELETE'
);

select policy_roles_are(
  'storage', 'objects', 'Allow users to delete their own public files',
  array['authenticated'],
  'the delete policy applies to authenticated users only'
);

select * from finish();
rollback;
