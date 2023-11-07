import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Center(child: Text(l10n.create)),
          ],
        ),
      ),
    );
  }
}
