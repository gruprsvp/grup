import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class SchedulesList extends StatelessWidget {
  final Iterable<ScheduleInstance>? schedules;

  const SchedulesList({super.key, this.schedules});

  @override
  Widget build(BuildContext context) {
    if (schedules == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: schedules!.length,
      itemBuilder: (context, index) =>
          ScheduleTile(schedule: schedules!.elementAt(index)),
    );
  }
}
