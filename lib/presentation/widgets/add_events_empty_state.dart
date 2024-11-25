import 'package:flutter/material.dart';
import 'package:parousia/presentation/presentation.dart';

/// A widget to display how to add new events to a group.
class AddEventsEmptyState extends StatelessWidget {
  const AddEventsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      image: 'assets/images/add-events.webp',
    );
  }
}
