import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';

class GroupEvents extends StatelessWidget {
  final Group group;

  const GroupEvents({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/images/hare.webp'),
          FilledButton(
            onPressed: () =>
                GroupScheduleRoute(groupId: group.id.toString()).push(context),
            child: Text(l10n.createNewEvent),
          ),
        ],
      ),
    );
  }
}
