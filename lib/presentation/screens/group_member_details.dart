import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:share_plus/share_plus.dart';

typedef OnRemoveFromGroupCallback = void Function(Member);

class GroupMemberDetailsScreen extends StatelessWidget {
  final bool loading;
  final bool isCurrentUser;
  final Group? group;
  final Member? member;
  final Profile? profile;
  final List<Invite>? invites;
  final ValueSetter<Member>? onUpdate;
  final OnRemoveFromGroupCallback? onRemove;

  const GroupMemberDetailsScreen({
    super.key,
    required this.loading,
    required this.isCurrentUser,
    this.group,
    this.member,
    this.profile,
    this.invites,
    this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final displayName =
        member?.displayNameOverride ?? profile?.displayName ?? l10n.unknown;

    final isNotPending = profile != null;
    final isPlainMember = member?.role == GroupRoles.member;

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(group?.displayName ?? l10n.loading),
        ),
      ),
      body: ListView(
        children: [
          // TODO Should the default replies be set here?

          if (!isCurrentUser) ...[
            if (isNotPending)
              // Only members that already joined can become admins
              if (isPlainMember)
                ListTile(
                  leading: const Icon(Icons.add_moderator_outlined),
                  title: Text(l10n.groupMakeAdmin),
                  textColor: theme.colorScheme.primary,
                  onTap: () =>
                      _confirmUpdateRole(context, member!, GroupRoles.admin),
                )
              else
                ListTile(
                  leading: const Icon(Icons.remove_moderator_outlined),
                  title: Text(l10n.groupDismissAdmin),
                  iconColor: theme.colorScheme.error,
                  textColor: theme.colorScheme.error,
                  onTap: () =>
                      _confirmUpdateRole(context, member!, GroupRoles.member),
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
                // TODO Should probably be its own widget
                switch (invite.method) {
                  InviteMethods.email => ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(invite.value),
                    ),
                  InviteMethods.phone => ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(invite.value), // TODO Format phone number
                    ),
                  InviteMethods.code => ListTile(
                      leading: const Icon(Icons.copy),
                      title: Text(invite.value),
                      subtitle: Text(l10n.inviteCodeExplanation(displayName)),
                      onTap: () => _copyInviteToClipboard(context, invite),
                      trailing: IconButton(
                        icon: Icon(Icons.adaptive.share),
                        onPressed: () => _shareInvite(context, invite),
                      ),
                    ),
                },

              // TODO Create and remove invites
              // ListTile(
              //   leading: const Icon(Icons.add_circle_outline),
              //   title: Text(l10n.addInvite),
              // )
            ],
            Divider(),
            ListTile(
              leading: const Icon(Icons.group_remove_outlined),
              title: Text(l10n.groupRemoveMember),
              splashColor: theme.colorScheme.error.withOpacity(0.3),
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              onTap: () => _confirmRemoveMember(context, member!),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.waving_hand),
              title: Text(l10n.groupLeave),
              splashColor: theme.colorScheme.error.withOpacity(0.3),
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              onTap: () => _confirmRemoveMember(context, member!),
            )
          ],
        ],
      ),
    );
  }

  /// Copies the [value] to the clipboard and shows a snackbar with a confirmation.
  Future<void> _copyInviteToClipboard(
      BuildContext context, Invite invite) async {
    await Clipboard.setData(ClipboardData(text: invite.value));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedToClipboard),
      ),
    );
  }

  /// Shares the invite using the platform's share dialog.
  Future<ShareResult?> _shareInvite(BuildContext context, Invite invite) async {
    if (invite.method != InviteMethods.code) {
      return null;
    }

    final l10n = AppLocalizations.of(context)!;
    final code = invite.value;
    final deeplink = Uri.https('grup.rsvp', '/join/$code').toString();

    return Share.share(l10n.inviteMessage(code, deeplink));
  }

  /// Shows a confirmation dialog before updating the role of a member.
  Future<void> _confirmUpdateRole(
      BuildContext context, Member member, GroupRoles newRole) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final title = newRole == GroupRoles.admin
        ? l10n.groupMakeAdmin
        : l10n.groupDismissAdmin;

    final confirmation = newRole == GroupRoles.admin
        ? l10n.groupMakeAdminConfirmation
        : l10n.groupDismissAdminConfirmation;

    final actionColor = newRole == GroupRoles.admin
        ? theme.colorScheme.secondary
        : theme.colorScheme.error;

    final confirm = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(confirmation),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(l10n.no),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(
                foregroundColor: actionColor,
              ),
              child: Text(l10n.yes),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      onUpdate?.call(member.copyWith(role: newRole));
    }
  }

  /// Shows a confirmation dialog before removing a member from the group.
  Future<void> _confirmRemoveMember(BuildContext context, Member member) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final title = isCurrentUser ? l10n.groupLeave : l10n.groupRemoveMember;
    final confirmation = isCurrentUser
        ? l10n.groupLeaveConfirmation
        : l10n.groupRemoveConfirmation;

    final confirm = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(confirmation),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(l10n.no),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(l10n.yes),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      onRemove?.call(member);
      if (context.mounted) context.pop();
    }
  }
}
