import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';

class SchedulesList extends StatelessWidget {
  final timeFormat = DateFormat.jm();

  final Iterable<ScheduleInstance>? schedules;

  SchedulesList({super.key, this.schedules});

  @override
  Widget build(BuildContext context) {
    if (schedules == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: schedules!.length,
      itemBuilder: (context, index) {
        final s = schedules!.elementAt(index);
        return ListTile(
          title: Text(s.displayName),
          subtitle: Text(timeFormat.format(s.eventDate)),
          trailing: SegmentedButton<ReplyOptions>(
            segments: const [
              ButtonSegment(value: ReplyOptions.yes, label: Text('Yes')),
              ButtonSegment(value: ReplyOptions.no, label: Text('No')),
            ],
            selected: {},
            onSelectionChanged: (value) {
              print(value);
            },
            emptySelectionAllowed: true,
            style: const ButtonStyle(
              visualDensity: VisualDensity.comfortable,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          onTap: () {
            // TODO Route to event details
          },
        );
      },
    );
  }
}
