import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupManageScreen extends StatelessWidget {
  final Group? group;
  final bool loading;

  const GroupManageScreen({
    super.key,
    required this.loading,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          bottom: TabBar(tabs: [
            Tab(
              text: l10n.members,
              icon: const FaIcon(FontAwesomeIcons.peopleGroup),
            ),
            Tab(
              text: l10n.events,
              icon: const FaIcon(FontAwesomeIcons.calendarDay),
            ),
            Tab(
              text: l10n.details,
              icon: const FaIcon(FontAwesomeIcons.quoteRight),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            group != null
                ? GroupMembersContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
            group != null
                ? GroupEventsContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
            group != null
                ? GroupFormContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
          ],
        ),
      ),
    );
  }
}
