-- A group's picture is uploaded into its uploader's folder, and deleting an
-- account deletes that folder first: the group lost its picture for everyone
-- else. Refuse to delete an object a group's picture points at. The storage
-- API skips what RLS refuses, so released clients (which delete the whole
-- folder) keep working, and GoTrue deletes a user who still owns objects.

-- Security definer: groups the user has left still count.
create function is_group_picture(object_name text)
    returns boolean
    language sql
    stable
    security definer set search_path = public
as
$$
select exists (select 1
               from groups
               where right(picture, length(object_name) + 1) = '/' || object_name);
$$;
comment on function is_group_picture(text) is 'Whether a group''s picture is the storage object with this name (used by storage RLS)';
revoke execute on function is_group_picture(text) from anon;

alter policy "Allow users to delete their own public files"
    on storage.objects
    using (owner_id = auth.uid()::text and not is_group_picture(name));
