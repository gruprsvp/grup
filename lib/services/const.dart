/// The tables the app reads and writes.
enum Tables {
  profiles('profiles'),
  groups('groups'),
  members('members'),
  invites('invites'),
  schedules('schedules'),
  defaultRules('default_rules'),
  replies('replies');

  const Tables(this.table);

  /// The table's name in the database.
  final String table;
}

/// The storage buckets the app uses.
enum Buckets { public }
