-- Configure a couple of buckets for public and private files.
insert into storage.buckets
    (id, name, public)
values ('public', 'public', true);
--        ('private', 'private', false);

create policy "Allow authenticated uploads to public"
    on storage.objects
    for insert
    to authenticated
    with check (
            bucket_id = 'public' and
            ((storage.foldername(name))[1] = auth.uid()::text)
    );


-- create policy "Allow authenticated uploads and reads to private"
--     on storage.objects
--     for insert
--     to authenticated
--     with check (
--             bucket_id = 'private' and
--             ((storage.foldername(name))[1] = auth.uid()::text)
--     );

-- TODO read policy
-- create policy "Allow users to read their own private files"
--     on storage.objects for select
--     to authenticated
--     using (owner_id = auth.uid()::text);
