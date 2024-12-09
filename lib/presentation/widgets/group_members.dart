import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';
import 'package:styled_text/styled_text.dart';

import 'contact_form.dart';

typedef OnInviteCallback = void Function(List<ContactInvite>);

class GroupMembers extends StatelessWidget {
  final Iterable<(Member, Profile?)>? members;
  final OnInviteCallback? onInvite;

  const GroupMembers({
    super.key,
    this.members,
    this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final topWidget = members?.isNotEmpty ?? false
        ? ListView.builder(
            itemCount: members?.length,
            itemBuilder: (context, index) {
              final (member, memberProfile) = members!.elementAt(index);
              final name = member.displayNameOverride ??
                  memberProfile?.displayName ??
                  l10n.unknown;
              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: memberProfile?.picture != null
                        ? NetworkImage(memberProfile!.picture!)
                        : null,
                    child: memberProfile?.picture == null
                        ? Text(getNameInitials(name)!)
                        : null,
                  ),
                  title: Text(name),
                  subtitle: Text(l10n.groupRoles(member.role.name)),
                  onTap: () {
                    GroupMemberDetailsRoute(
                            groupId: member.groupId.toString(),
                            memberId: member.id.toString())
                        .push(context);
                  });
            },
          )
        // TODO This is actually never shown, because the members list has at least the current user...
        // Refactor this so that the current user is shown differently,
        // and the empty state is shown when there are no members other than the current user.
        : EmptyState(
            image: 'add-members.webp',
            text: StyledText(
              text: l10n.invitesEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
              tags: {
                'invite': StyledTextWidgetTag(TextButton(
                  onPressed: () => _showInviteModal(context),
                  child: Text(l10n.inviteMembersCTA),
                )),
              },
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Expanded(child: topWidget),
          FilledButton(
              onPressed: () => _showInviteModal(context),
              child: Text(l10n.inviteMembersCTA)),
        ],
      ),
    );
  }

  void _showInviteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return InviteModal(
          onOptionSelected: (selectedOption) async {
            final invites = await switch (selectedOption) {
              InviteOptions.email => _inviteEmailDialog(context),
              InviteOptions.phone => _invitePhoneDialog(context),
              InviteOptions.guest => _inviteGuestDialog(context),
              InviteOptions.contacts => _inviteFromContacts(context),
            };

            if (invites != null && invites.isNotEmpty) {
              onInvite?.call(invites);
            }
          },
        );
      },
    );
  }

  Future<List<ContactInvite>?> _showContactDialog({
    required BuildContext context,
    required bool showEmail,
    required bool showPhone,
  }) =>
      showDialog(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          final showButton = ValueNotifier<bool>(false);
          ContactInvite? contact;
          // TODO: The alert dialog is not a very good UI for a form:
          // just tapping outside the dialog will close it, and the user
          // will lose their input. Consider using a modal sheet or a
          // dedicated screen instead. It should also be possible to
          // manage an arbitrary number of contacts to invite,
          // so scrolling may be necessary.
          return AlertDialog(
            title: Text(l10n.contactNew),
            content: ContactForm(
              onChanged: (contactInvite, isValid) {
                showButton.value = isValid;
                if (!isValid) return;
                contact = contactInvite;
              },
              showEmail: showEmail,
              showPhone: showPhone,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: showButton,
                child: Text(l10n.save),
                builder: (context, value, child) => TextButton(
                  onPressed: (value) ? () => context.pop([contact!]) : null,
                  child: child!,
                ),
              ),
            ],
          );
        },
      );

  Future<List<ContactInvite>?> _inviteEmailDialog(BuildContext context) =>
      _showContactDialog(
        context: context,
        showEmail: true,
        showPhone: false,
      );

  Future<List<ContactInvite>?> _invitePhoneDialog(BuildContext context) =>
      _showContactDialog(
        context: context,
        showEmail: false,
        showPhone: true,
      );

  Future<List<ContactInvite>?> _inviteGuestDialog(BuildContext context) =>
      _showContactDialog(
        context: context,
        showEmail: false,
        showPhone: false,
      );

  Future<List<ContactInvite>> _inviteFromContacts(BuildContext context) async {
    if (!context.mounted) return [];

    final invited = await SelectContactsRoute().push<List<Contact>>(context);

    if (invited == null) return [];

    return [
      for (final contact in invited)
        ContactInvite(displayNameOverride: contact.displayName, invites: [
          for (final e in contact.emails) (InviteMethods.email, e.address),
          for (final p in contact.phones) (InviteMethods.phone, p.number),
        ])
    ];
  }
}
