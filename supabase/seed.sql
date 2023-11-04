insert into roles (display_name,
                   can_manage_group,
                   can_manage_members,
                   can_manage_invites,
                   can_manage_schedules,
                   can_manage_replies)
values ('Admin', true, true, true, true, true),
       ('ReadOnly', false, false, false, false, false);
