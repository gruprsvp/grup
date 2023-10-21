create or replace function create_group(
    display_name text
)
    returns bigint
    language sql as
$$
with new_group as (insert into groups (display_name) values (create_group.display_name) returning id),
     new_member as (insert into members (group_id, profile_id, role_id) select id, auth.uid(), 1 from new_group)
select id
from new_group;
    -- TODO(borgoat): get admin role id from config
$$;
comment on function create_group(text) is 'Creates a group with the given display name and adds the current user as an admin';
