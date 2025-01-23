import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';

sealed class GroupCreateResult {}

class GroupCreateResultNew extends GroupCreateResult {
  final Group group;
  final XFile? image;

  GroupCreateResultNew(this.group, this.image);
}

class GroupCreateResultJoin extends GroupCreateResult {
  final String code;

  GroupCreateResultJoin(this.code);
}

class GroupCreateScreen extends StatelessWidget {
  const GroupCreateScreen({super.key});

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
            GroupJoin(
                onJoin: (code) => context
                    .pop<GroupCreateResult>(GroupCreateResultJoin(code))),
            GroupForm(
                onSave: (group) => context.pop<GroupCreateResult>(
                    GroupCreateResultNew(group.$1, group.$2))),
          ],
        ),
      ),
    );
  }
}
