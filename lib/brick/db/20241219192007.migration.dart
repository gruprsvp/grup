// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241219192007_up = [
  DropColumn('instance_date', onTable: 'Reply'),
  InsertColumn('instance_date', Column.datetime, onTable: 'Reply', unique: true),
  CreateIndex(columns: ['instance_date'], onTable: 'Reply', unique: true)
];

const List<MigrationCommand> _migration_20241219192007_down = [
  DropColumn('instance_date', onTable: 'Reply'),
  DropIndex('index_Reply_on_instance_date')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241219192007',
  up: _migration_20241219192007_up,
  down: _migration_20241219192007_down,
)
class Migration20241219192007 extends Migration {
  const Migration20241219192007()
    : super(
        version: 20241219192007,
        up: _migration_20241219192007_up,
        down: _migration_20241219192007_down,
      );
}
