import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        : AddMembersEmptyState();

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
            switch (selectedOption) {
              case InviteOptions.email:
                _showEmailDialog(context, onInvite);
                break;
              case InviteOptions.phone:
                _showPhoneDialog(context, onInvite);
                break;
              case InviteOptions.guest:
                _showGuestDialog(context, onInvite);
                break;
              case InviteOptions.contacts:
                final invites = await _inviteFromContacts(context);
                if (invites.isNotEmpty) {
                  onInvite?.call(invites);
                }
                break;
            }
          },
        );
      },
    );
  }

  void _showContactDialog({
    required BuildContext context,
    required bool showEmail,
    required bool showPhone,
    required Function(String? name, String? contact) onSubmit,
  }) {
    String? name;
    String? contact; // Can represent either email or phone.
    bool showButton = false;
    final l10n = AppLocalizations.of(context)!;

    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.contactNew),
              content: ContactForm(
                onChanged: (contactInvite, isValid) {
                  setState(() {
                    showButton = isValid;
                    if (!isValid) return;
                    contact = contactInvite.invites.first.$2;
                    name = contactInvite.displayNameOverride;
                  });
                },
                showEmail: showEmail,
                showPhone: showPhone,
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: (showButton)
                      ? () {
                          onSubmit(name, contact);
                          context.pop();
                        }
                      : null,
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEmailDialog(BuildContext context, OnInviteCallback? onInvite) =>
      _showContactDialog(
        context: context,
        showEmail: true,
        showPhone: false,
        onSubmit: (name, email) {
          if (email == null) return;
          final contactInvite = ContactInvite(
            displayNameOverride: name,
            invites: [(InviteMethods.email, email)],
          );
          onInvite?.call([contactInvite]);
        },
      );

  void _showPhoneDialog(BuildContext context, OnInviteCallback? onInvite) =>
      _showContactDialog(
        context: context,
        showEmail: false,
        showPhone: true,
        onSubmit: (name, phone) {
          if (phone == null) return;
          final contactInvite = ContactInvite(
            displayNameOverride: name,
            invites: [(InviteMethods.email, phone)],
          );
          onInvite?.call([contactInvite]);
        },
      );

  void _showGuestDialog(BuildContext context, OnInviteCallback? onInvite) =>
      _showContactDialog(
        context: context,
        showEmail: false,
        showPhone: false,
        onSubmit: (name, _) {
          final contactInvite = ContactInvite(
            displayNameOverride: name,
            invites: [],
          );
          onInvite?.call([contactInvite]);
        },
      );
}
