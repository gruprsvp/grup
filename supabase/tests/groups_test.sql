begin;
select plan(5);

-- call auth.login_as_user('giorgio.azzinnaro@gmail.com');

-- Test case 1: Test if create_group returns a valid group_id
select ok(
               create_group('test group') is not null,
               'create_group should return a valid group_id'
       );

-- Test case 2: Test if the group exists in the groups table
select is(
               (select count(*) from groups where display_name = 'test group'),
               1,
               'The group should exist in the groups table'
       );

-- Test case 3: Test if a member exists in the members table
select is(
               (select count(*)
                from members
                where group_id = (select id from groups where display_name = 'test group')
                  and role_id = 1),
               1,
               'A member with role_id 1 should exist in the members table for the created group'
       );

select ok(
               create_group('test group') is null,
               'create_group should return null if the group already exists'
       );

commit;
