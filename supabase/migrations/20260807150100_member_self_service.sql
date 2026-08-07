-- Member self-service (MODERNIZATION.md Phase 1 item 15).
--
-- `members` previously had only members_select + admin-only members_all, so a
-- regular member could neither leave a group (DELETE own row) nor set their
-- own display_name_override — despite the column comment saying that's the
-- intent. Any "leave group" UI would silently update 0 rows.

-- A member can edit their own row. WITH CHECK pins everything that must not
-- change through this path: the row must stay theirs (profile_id), they
-- cannot escalate to admin (role), and they cannot re-point the row at a
-- group they don't belong to (group_id; moving it to a group they *are* in is
-- blocked by the unique (group_id, profile_id) constraint). Admins editing
-- their own row (role = 'admin') are covered by members_all instead.
create policy "members_update_self"
    on members
    for update
    to authenticated
    using (profile_id = (select auth.uid()))
    with check (
        profile_id = (select auth.uid())
            and role = 'member'::group_roles
            and is_member_of_group(group_id)
    );
comment on policy "members_update_self" on members is 'Members can edit their own row (e.g. display_name_override) but cannot escalate their role or move it to another group';

-- A member can leave a group by deleting their own row.
create policy "members_delete_self"
    on members
    for delete
    to authenticated
    using (profile_id = (select auth.uid()));
comment on policy "members_delete_self" on members is 'Members can leave a group by deleting their own membership';

-- Keep groups manageable when members leave: if the departing member was the
-- last admin, promote the longest-standing member with a claimed profile; if
-- nobody with a profile remains, delete the group (unclaimed invitee rows
-- cannot manage anything). Mirrors the semantics handle_delete_user already
-- applies on account deletion — that trigger stays as-is; this one also
-- covers the new self-service DELETE path.
create or replace function public.handle_member_left()
    returns trigger
    language plpgsql
    security definer set search_path = public
as
$$
begin
    -- Group already gone (cascade from a group delete): nothing to do.
    if not exists (select 1 from groups where id = old.group_id) then
        return old;
    end if;

    -- Group still has an admin: nothing to do.
    if exists (select 1
               from members
               where group_id = old.group_id
                 and role = 'admin') then
        return old;
    end if;

    update members
    set role = 'admin'
    where id = (select id
                from members
                where group_id = old.group_id
                  and profile_id is not null
                order by created_at
                limit 1);

    if not found then
        delete from groups where id = old.group_id;
    end if;

    return old;
end;
$$;
comment on function public.handle_member_left() is 'After a member row is deleted, keeps the group manageable: promotes a new admin or deletes an unmanageable group';

revoke execute on function public.handle_member_left() from public, anon, authenticated;

create trigger on_member_deleted
    after delete
    on members
    for each row
execute function public.handle_member_left();
comment on trigger on_member_deleted on public.members is 'Promotes a new admin or deletes the group when the last admin leaves';
