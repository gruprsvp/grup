alter policy "profiles_select"
    on profiles
    to authenticated
    using (
      exists (
        select 1
        from   members
        where  members.profile_id = auth.uid()
          and  members.group_id = (select group_id from members where members.profile_id = profiles.id)
      )
    );