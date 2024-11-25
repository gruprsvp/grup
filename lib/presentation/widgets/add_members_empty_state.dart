import 'package:flutter/material.dart';
import 'package:parousia/presentation/presentation.dart';

/// A widget to display how to add new members to a group.
class AddMembersEmptyState extends StatelessWidget {
  const AddMembersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      image: 'assets/images/add-members.webp',
    );
  }
}
