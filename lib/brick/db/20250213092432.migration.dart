// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250213092432_up = [
  InsertTable('Group'),
  InsertTable('DefaultRule'),
  InsertTable('Invite'),
  InsertTable('Schedule'),
  InsertTable('Member'),
  InsertTable('Profile'),
  InsertTable('Reply'),
  InsertColumn('id', Column.varchar, onTable: 'Group', unique: true),
  InsertColumn('display_name', Column.varchar, onTable: 'Group'),
  InsertColumn('description', Column.varchar, onTable: 'Group'),
  InsertColumn('picture', Column.varchar, onTable: 'Group'),
  InsertColumn('id', Column.varchar, onTable: 'DefaultRule', unique: true),
  InsertForeignKey('DefaultRule', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('DefaultRule', 'Schedule', foreignKeyColumn: 'schedule_Schedule_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('selected_option', Column.integer, onTable: 'DefaultRule'),
  InsertColumn('recurrence_rule', Column.varchar, onTable: 'DefaultRule'),
  InsertColumn('id', Column.varchar, onTable: 'Invite', unique: true),
  InsertForeignKey('Invite', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('method', Column.integer, onTable: 'Invite'),
  InsertColumn('value', Column.varchar, onTable: 'Invite'),
  InsertColumn('id', Column.varchar, onTable: 'Schedule', unique: true),
  InsertForeignKey('Schedule', 'Group', foreignKeyColumn: 'group_Group_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('display_name', Column.varchar, onTable: 'Schedule'),
  InsertColumn('recurrence_rule', Column.varchar, onTable: 'Schedule'),
  InsertColumn('start_date', Column.datetime, onTable: 'Schedule'),
  InsertColumn('timezone', Column.varchar, onTable: 'Schedule'),
  InsertColumn('id', Column.varchar, onTable: 'Member', unique: true),
  InsertForeignKey('Member', 'Group', foreignKeyColumn: 'group_Group_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('Member', 'Profile', foreignKeyColumn: 'profile_Profile_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('role', Column.integer, onTable: 'Member'),
  InsertColumn('display_name_override', Column.varchar, onTable: 'Member'),
  InsertColumn('id', Column.varchar, onTable: 'Profile', unique: true),
  InsertColumn('display_name', Column.varchar, onTable: 'Profile'),
  InsertColumn('picture', Column.varchar, onTable: 'Profile'),
  InsertColumn('id', Column.varchar, onTable: 'Reply', unique: true),
  InsertForeignKey('Reply', 'Member', foreignKeyColumn: 'member_Member_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('Reply', 'Schedule', foreignKeyColumn: 'schedule_Schedule_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('instance_date', Column.datetime, onTable: 'Reply'),
  InsertColumn('selected_option', Column.integer, onTable: 'Reply'),
  CreateIndex(columns: ['id'], onTable: 'Group', unique: true),
  CreateIndex(columns: ['id'], onTable: 'DefaultRule', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Invite', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Schedule', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Member', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Profile', unique: true),
  CreateIndex(columns: ['id'], onTable: 'Reply', unique: true)
];

const List<MigrationCommand> _migration_20250213092432_down = [
  DropTable('Group'),
  DropTable('DefaultRule'),
  DropTable('Invite'),
  DropTable('Schedule'),
  DropTable('Member'),
  DropTable('Profile'),
  DropTable('Reply'),
  DropColumn('id', onTable: 'Group'),
  DropColumn('display_name', onTable: 'Group'),
  DropColumn('description', onTable: 'Group'),
  DropColumn('picture', onTable: 'Group'),
  DropColumn('id', onTable: 'DefaultRule'),
  DropColumn('member_Member_brick_id', onTable: 'DefaultRule'),
  DropColumn('schedule_Schedule_brick_id', onTable: 'DefaultRule'),
  DropColumn('selected_option', onTable: 'DefaultRule'),
  DropColumn('recurrence_rule', onTable: 'DefaultRule'),
  DropColumn('id', onTable: 'Invite'),
  DropColumn('member_Member_brick_id', onTable: 'Invite'),
  DropColumn('method', onTable: 'Invite'),
  DropColumn('value', onTable: 'Invite'),
  DropColumn('id', onTable: 'Schedule'),
  DropColumn('group_Group_brick_id', onTable: 'Schedule'),
  DropColumn('display_name', onTable: 'Schedule'),
  DropColumn('recurrence_rule', onTable: 'Schedule'),
  DropColumn('start_date', onTable: 'Schedule'),
  DropColumn('timezone', onTable: 'Schedule'),
  DropColumn('id', onTable: 'Member'),
  DropColumn('group_Group_brick_id', onTable: 'Member'),
  DropColumn('profile_Profile_brick_id', onTable: 'Member'),
  DropColumn('role', onTable: 'Member'),
  DropColumn('display_name_override', onTable: 'Member'),
  DropColumn('id', onTable: 'Profile'),
  DropColumn('display_name', onTable: 'Profile'),
  DropColumn('picture', onTable: 'Profile'),
  DropColumn('id', onTable: 'Reply'),
  DropColumn('member_Member_brick_id', onTable: 'Reply'),
  DropColumn('schedule_Schedule_brick_id', onTable: 'Reply'),
  DropColumn('instance_date', onTable: 'Reply'),
  DropColumn('selected_option', onTable: 'Reply'),
  DropIndex('index_Group_on_id'),
  DropIndex('index_DefaultRule_on_id'),
  DropIndex('index_Invite_on_id'),
  DropIndex('index_Schedule_on_id'),
  DropIndex('index_Member_on_id'),
  DropIndex('index_Profile_on_id'),
  DropIndex('index_Reply_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250213092432',
  up: _migration_20250213092432_up,
  down: _migration_20250213092432_down,
)
class Migration20250213092432 extends Migration {
  const Migration20250213092432()
    : super(
        version: 20250213092432,
        up: _migration_20250213092432_up,
        down: _migration_20250213092432_down,
      );
}
