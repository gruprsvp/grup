import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';

typedef OnScheduleCreateCallback = void Function(Schedule schedule);

class GroupEvents extends StatelessWidget {
  final Group? group; // TODO is this needed?
  final Iterable<Schedule>? schedules;
  final OnScheduleCreateCallback? onCreate;

  const GroupEvents({
    super.key,
    this.group,
    this.schedules,
    this.onCreate,
  });

  _createNewEvent(BuildContext context) async {
    final result = await GroupScheduleCreateRoute(groupId: group!.id.toString())
        .push(context);

    if (result is! Schedule) {
      // TODO error handling
      return;
    }

    final newSchedule = result.copyWith(groupId: group!.id);
    onCreate?.call(newSchedule);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // TODO events list
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(child: Image.asset('assets/images/hare.webp')),
          FilledButton(
            onPressed: () => _createNewEvent(context),
            child: Text(l10n.createNewEvent),
          ),
        ],
      ),
    );
  }
}
