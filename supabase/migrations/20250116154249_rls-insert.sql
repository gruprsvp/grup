create policy "groups_insert"
    on groups
    for insert
    to authenticated
    with check (is_member_of_group(id, '{admin}'::group_roles[]));
comment on policy "groups_insert" on groups is 'Admins can insert into groups';

create policy "schedules_insert"
    on schedules
    for insert
    to authenticated
    with check (is_member_of_group(id, '{admin}'::group_roles[]));
comment on policy "schedules_insert" on schedules is 'Admins can insert into schedules';

create policy "profiles_insert"
    on profiles
    for insert
    to authenticated
    with check ((select auth.uid()) = id);
comment on policy "profiles_insert" on profiles is 'Users can insert their own profile';

create policy "profiles_update"
    on profiles
    for update
    to authenticated
    using ((select auth.uid()) = id)
    with check ((select auth.uid()) = id);
comment on policy "profiles_update" on profiles is 'Users can update their own profile';