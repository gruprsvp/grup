import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

class GroupEvents extends StatelessWidget {
  final Group? group; // TODO is this needed?
  final Iterable<Schedule>? schedules;
  final ValueSetter<Schedule>? onCreate;
  final Future<RruleL10n>? rrulel10n;

  const GroupEvents({
    super.key,
    this.group,
    this.schedules,
    this.onCreate,
    this.rrulel10n,
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

    final topWidget = schedules?.isNotEmpty ?? false
        ? ListView.builder(
            itemCount: schedules?.length,
            itemBuilder: (context, index) {
              final schedule = schedules!.elementAt(index);
              return ListTile(
                title: Text(schedule.displayName),
                subtitle: FutureBuilder(
                    future: rrulel10n,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final rrl10n = snapshot.data as RruleL10n;
                        return Text(
                            schedule.recurrenceRule.toText(l10n: rrl10n));
                      }
                      return Text(l10n.loading);
                    }),
                onTap: () {
                  // TODO Go to schedule edit form
                },
              );
            },
          )
        : Image.asset('assets/images/hare.webp');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Expanded(child: topWidget),
          FilledButton(
            onPressed: () => _createNewEvent(context),
            child: Text(l10n.createNewEvent),
          ),
        ],
      ),
    );
  }
}
