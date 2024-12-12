-- This is a fix for the profiles_select policy that was not working as intended.
-- It would throw an error when a user tried to read multiple groups with the same other user appearing as a member
-- of those multiple groups. This was because the subquery was returning multiple rows, which is not allowed.
-- PostgrestException(message: more than one row returned by a subquery used as an expression, code: 21000, details: Internal Server Error, hint: null)
-- See https://github.com/appforit/appforit/issues/112

alter policy "profiles_select" on profiles
    using (
    (select auth.uid()) = id
        or
    exists (select 1
            from members
            where members.profile_id = auth.uid()
              and members.group_id = (select group_id from members where members.profile_id = profiles.id limit 1))
    );
comment on policy "profiles_select" on profiles is 'Users can see their own profile and profiles of members of groups they are in';
