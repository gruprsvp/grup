import 'package:flutter/material.dart';
import 'package:parousia/presentation/presentation.dart';

/// A widget to display when no events were created in a group yet.
class EventsEmptyState extends StatelessWidget {
  const EventsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      image: 'assets/images/events.webp',
    );
  }
}
