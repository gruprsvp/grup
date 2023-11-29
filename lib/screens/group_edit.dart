import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupEditScreen extends StatelessWidget {
  final bool loading;
  final OnGroupSaveCallback onSave;
  final Group? group;

  const GroupEditScreen({
    super.key,
    required this.loading,
    required this.onSave,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group?.displayName ?? 'Loading...'),
      ),
      body: GroupForm(
        loading: loading,
        onSave: onSave,
        group: group,
      ),
    );
  }
}
