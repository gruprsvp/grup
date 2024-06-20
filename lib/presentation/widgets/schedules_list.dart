import 'package:flutter/material.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

typedef OnReplyChangedCallback = void Function(ScheduleInstance, ReplyOptions?);

class SchedulesList extends StatelessWidget {
  final Iterable<ScheduleInstance>? schedules;
  final OnReplyChangedCallback? onReplyChanged;

  const SchedulesList({
    super.key,
    this.schedules,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (schedules == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: schedules!.length,
      itemBuilder: (context, index) => ScheduleTile(
        schedule: schedules!.elementAt(index),
        onReplyChanged: (reply) =>
            onReplyChanged?.call(schedules!.elementAt(index), reply),
        onScheduleTapped: (schedule) => GroupScheduleDetailsRoute(
                groupId: schedule.groupId.toString(),
                scheduleId: schedule.scheduleId.toString())
            .push(context),
      ),
    );
  }
}
