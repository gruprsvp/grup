import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

sealed class NewGroupReturn {}

class NewGroupReturnNew extends NewGroupReturn {
  final Group group;

  NewGroupReturnNew(this.group);
}

class NewGroupReturnJoin extends NewGroupReturn {
  final String code;

  NewGroupReturnJoin(this.code);
}

class NewGroupScreen extends StatelessWidget {
  const NewGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.newGroup),
          bottom: TabBar(tabs: [
            Tab(
              text: l10n.join,
              icon: const Icon(Icons.waving_hand_outlined),
            ),
            Tab(
              text: l10n.create,
              icon: const Icon(Icons.group_add_outlined),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Center(child: Text(l10n.join)),
            GroupForm(
                onSave: (group) =>
                    context.pop<NewGroupReturn>(NewGroupReturnNew(group))),
          ],
        ),
      ),
    );
  }
}
