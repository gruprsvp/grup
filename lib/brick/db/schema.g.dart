// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250211231434.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250211231434(),};

/// A consumable database structure including the latest generated migration.
final schema = Schema(20250211231434, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Group', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('display_name', Column.varchar),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('picture', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('DefaultRule', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('member_Member_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Member',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('schedule_Schedule_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Schedule',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('selected_option', Column.integer),
    SchemaColumn('recurrence_rule', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Invite', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('member_Member_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Member',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('method', Column.integer),
    SchemaColumn('value', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Schedule', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('group_Group_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Group',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('display_name', Column.varchar),
    SchemaColumn('recurrence_rule', Column.varchar),
    SchemaColumn('start_date', Column.datetime),
    SchemaColumn('timezone', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Member', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('group_Group_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Group',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('profile_Profile_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Profile',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('role', Column.integer),
    SchemaColumn('display_name_override', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Profile', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('display_name', Column.varchar),
    SchemaColumn('picture', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Reply', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('member_Member_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Member',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('schedule_Schedule_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Schedule',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('instance_date', Column.datetime),
    SchemaColumn('selected_option', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  })
});
