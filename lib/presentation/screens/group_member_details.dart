import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';

typedef OnRemoveFromGroupCallback = void Function(Member);

class GroupMemberDetailsScreen extends StatelessWidget {
  final bool loading;
  final Group? group;
  final Member? member;
  final Profile? profile;
  final List<Invite>? invites;
  final OnRemoveFromGroupCallback? onRemove;

  const GroupMemberDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.member,
    this.profile,
    this.invites,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(member?.displayNameOverride ??
            profile?.displayName ??
            l10n.loading),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(group?.displayName ?? l10n.loading),
        ),
      ),
      body: ListView(
        children: [
          // TODO Should the default replies be set here?
          if (profile != null)
            // Only members that already joined can become admins
            if (member?.role == GroupRoles.member)
              ListTile(
                leading: const Icon(Icons.add_moderator_outlined),
                title: Text(l10n.groupMakeAdmin),
                textColor: theme.colorScheme.primary,
              )
            else
              ListTile(
                leading: const Icon(Icons.remove_moderator_outlined),
                title: Text(l10n.groupDismissAdmin),
                iconColor: theme.colorScheme.error,
                textColor: theme.colorScheme.error,
              )
          else ...[
            // Members that haven't joined yet can be invited
            ListTile(
              title: Text(
                l10n.invites,
                style: theme.textTheme.headlineMedium,
              ),
            ),
            for (final invite in invites!)
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(invite.value),
              ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(l10n.addInvite),
            )
          ],
          Divider(),
          ListTile(
            leading: const Icon(Icons.group_remove_outlined),
            title: Text(l10n.groupRemoveMember),
            splashColor: theme.colorScheme.error.withOpacity(0.3),
            iconColor: theme.colorScheme.error,
            textColor: theme.colorScheme.error,
            onTap: () async {
              final confirm = await showAdaptiveDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: Text(l10n.groupRemoveMember),
                    content: Text(l10n.groupRemoveConfirmation),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                        child: Text(l10n.yes),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.no),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                onRemove?.call(member!);

                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
