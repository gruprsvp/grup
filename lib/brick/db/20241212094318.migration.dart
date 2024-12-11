// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241212094318_up = [
  InsertTable('Group'),
  InsertTable('Invite'),
  InsertTable('Schedule'),
  InsertTable('Member'),
  InsertTable('DefaultReply'),
  InsertTable('Profile'),
  InsertTable('Reply'),
  InsertColumn('id', Column.varchar, onTable: 'Group', unique: true),
  InsertColumn('display_name', Column.varchar, onTable: 'Group'),
  InsertColumn('description', Column.varchar, onTable: 'Group'),
  InsertColumn('picture', Column.varchar, onTable: 'Group'),
  InsertColumn('created_at', Column.datetime, onTable: 'Group'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Group'),
  InsertColumn('id', Column.varchar, onTable: 'Invite', unique: true),
  InsertForeignKey('Invite', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('method', Column.integer, onTable: 'Invite'),
  InsertColumn('value', Column.varchar, onTable: 'Invite'),
  InsertColumn('created_at', Column.datetime, onTable: 'Invite'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Invite'),
  InsertColumn('id', Column.varchar, onTable: 'Schedule', unique: true),
  InsertForeignKey('Schedule', 'Group', foreignKeyColumn: 'group_Group_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('display_name', Column.varchar, onTable: 'Schedule'),
  InsertColumn('start_date', Column.datetime, onTable: 'Schedule'),
  InsertColumn('recurrence_rule', Column.varchar, onTable: 'Schedule'),
  InsertColumn('created_at', Column.datetime, onTable: 'Schedule'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Schedule'),
  InsertColumn('id', Column.varchar, onTable: 'Member', unique: true),
  InsertForeignKey('Member', 'Group', foreignKeyColumn: 'group_Group_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('Member', 'Profile', foreignKeyColumn: 'profile_Profile_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('role', Column.integer, onTable: 'Member'),
  InsertColumn('display_name_override', Column.varchar, onTable: 'Member'),
  InsertColumn('created_at', Column.datetime, onTable: 'Member'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Member'),
  InsertForeignKey('DefaultReply', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('DefaultReply', 'Schedule', foreignKeyColumn: 'schedule_Schedule_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('selected_option', Column.integer, onTable: 'DefaultReply'),
  InsertColumn('recurrence_rule', Column.varchar, onTable: 'DefaultReply'),
  InsertColumn('created_at', Column.datetime, onTable: 'DefaultReply'),
  InsertColumn('updated_at', Column.datetime, onTable: 'DefaultReply'),
  InsertColumn('id', Column.varchar, onTable: 'Profile'),
  InsertColumn('display_name', Column.varchar, onTable: 'Profile'),
  InsertColumn('picture', Column.varchar, onTable: 'Profile'),
  InsertColumn('created_at', Column.datetime, onTable: 'Profile'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Profile'),
  InsertForeignKey('Reply', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('Reply', 'Schedule', foreignKeyColumn: 'schedule_Schedule_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('instance_date', Column.datetime, onTable: 'Reply'),
  InsertColumn('selected_option', Column.integer, onTable: 'Reply'),
  InsertColumn('created_at', Column.datetime, onTable: 'Reply'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Reply'),
  CreateIndex(columns: ['id'], onTable: 'Group', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Invite', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Schedule', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Member', unique: true)
];

const List<MigrationCommand> _migration_20241212094318_down = [
  DropTable('Group'),
  DropTable('Invite'),
  DropTable('Schedule'),
  DropTable('Member'),
  DropTable('DefaultReply'),
  DropTable('Profile'),
  DropTable('Reply'),
  DropColumn('id', onTable: 'Group'),
  DropColumn('display_name', onTable: 'Group'),
  DropColumn('description', onTable: 'Group'),
  DropColumn('picture', onTable: 'Group'),
  DropColumn('created_at', onTable: 'Group'),
  DropColumn('updated_at', onTable: 'Group'),
  DropColumn('id', onTable: 'Invite'),
  DropColumn('member_Member_brick_id', onTable: 'Invite'),
  DropColumn('method', onTable: 'Invite'),
  DropColumn('value', onTable: 'Invite'),
  DropColumn('created_at', onTable: 'Invite'),
  DropColumn('updated_at', onTable: 'Invite'),
  DropColumn('id', onTable: 'Schedule'),
  DropColumn('group_Group_brick_id', onTable: 'Schedule'),
  DropColumn('display_name', onTable: 'Schedule'),
  DropColumn('start_date', onTable: 'Schedule'),
  DropColumn('recurrence_rule', onTable: 'Schedule'),
  DropColumn('created_at', onTable: 'Schedule'),
  DropColumn('updated_at', onTable: 'Schedule'),
  DropColumn('id', onTable: 'Member'),
  DropColumn('group_Group_brick_id', onTable: 'Member'),
  DropColumn('profile_Profile_brick_id', onTable: 'Member'),
  DropColumn('role', onTable: 'Member'),
  DropColumn('display_name_override', onTable: 'Member'),
  DropColumn('created_at', onTable: 'Member'),
  DropColumn('updated_at', onTable: 'Member'),
  DropColumn('member_Member_brick_id', onTable: 'DefaultReply'),
  DropColumn('schedule_Schedule_brick_id', onTable: 'DefaultReply'),
  DropColumn('selected_option', onTable: 'DefaultReply'),
  DropColumn('recurrence_rule', onTable: 'DefaultReply'),
  DropColumn('created_at', onTable: 'DefaultReply'),
  DropColumn('updated_at', onTable: 'DefaultReply'),
  DropColumn('id', onTable: 'Profile'),
  DropColumn('display_name', onTable: 'Profile'),
  DropColumn('picture', onTable: 'Profile'),
  DropColumn('created_at', onTable: 'Profile'),
  DropColumn('updated_at', onTable: 'Profile'),
  DropColumn('member_Member_brick_id', onTable: 'Reply'),
  DropColumn('schedule_Schedule_brick_id', onTable: 'Reply'),
  DropColumn('instance_date', onTable: 'Reply'),
  DropColumn('selected_option', onTable: 'Reply'),
  DropColumn('created_at', onTable: 'Reply'),
  DropColumn('updated_at', onTable: 'Reply'),
  DropIndex('index_Group_on_id'),
  DropIndex('index_Invite_on_id'),
  DropIndex('index_Schedule_on_id'),
  DropIndex('index_Member_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241212094318',
  up: _migration_20241212094318_up,
  down: _migration_20241212094318_down,
)
class Migration20241212094318 extends Migration {
  const Migration20241212094318()
    : super(
        version: 20241212094318,
        up: _migration_20241212094318_up,
        down: _migration_20241212094318_down,
      );
}
