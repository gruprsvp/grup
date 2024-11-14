import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';

enum _InviteSource { contacts, manually }

typedef OnInviteCallback = void Function(List<ContactInvite>);

class GroupMembers extends StatelessWidget {
  final Iterable<(Member, Profile?)>? members;
  final OnInviteCallback? onInvite;

  const GroupMembers({
    super.key,
    this.members,
    this.onInvite,
  });

  Future<List<ContactInvite>?> _inviteFromContacts(BuildContext context) async {
    if (!context.mounted) return null;

    final invited = await SelectContactsRoute().push<List<Contact>>(context);

    if (invited == null) return null;

    return [
      for (final contact in invited)
        ContactInvite(displayNameOverride: contact.displayName, invites: [
          for (final e in contact.emails) (InviteMethods.email, e.address),
          for (final p in contact.phones) (InviteMethods.phone, p.number),
        ])
    ];
  }

  Future<List<ContactInvite>?> _inviteManually(BuildContext context) async {
    if (!context.mounted) return null;

    final invited =
        await CreateContactsRoute().push<List<ContactInvite>>(context);

    return invited;
  }

  Future<List<ContactInvite>?> _inviteNew(BuildContext context) async {
    // TODO Is there a better way to check for contact API availability?
    final contactApiAvailable = !kIsWeb;

    if (!contactApiAvailable) {
      return _inviteManually(context);
    }

    final _InviteSource? source = await showAdaptiveDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SimpleDialog(
          title: Text(l10n.invite),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _InviteSource.contacts),
              child: Row(
                children: [
                  const Icon(Icons.contacts_outlined),
                  const SizedBox(width: 16),
                  Text(l10n.inviteFromContacts),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, _InviteSource.manually),
              child: Row(
                children: [
                  const Icon(Icons.person_add_alt_1_outlined),
                  const SizedBox(width: 16),
                  Text(l10n.inviteManual),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return null;

    return switch (source) {
      _InviteSource.contacts => _inviteFromContacts(context),
      _InviteSource.manually => _inviteManually(context),
      null => null,
    };
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
                  'Unknown'; // TODO
              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: memberProfile?.picture != null
                        ? NetworkImage(memberProfile!.picture!)
                        : null,
                    child: memberProfile?.picture == null
                        ? Text(getNameInitials(name)!)
                        : null,
                  ),
                  title: Text(member.displayNameOverride ??
                      memberProfile?.displayName ??
                      'Unknown'),
                  subtitle: Text(l10n.groupRoles(member.role.name)),
                  onTap: () {
                    GroupMemberDetailsRoute(
                            groupId: member.groupId.toString(),
                            memberId: member.id.toString())
                        .push(context);
                  });
            },
          )
        : Image.asset('assets/images/seeyoulateralligator.webp');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Expanded(child: topWidget),
          FilledButton(
              onPressed: () async {
                final invites = await _inviteNew(context);
                if (invites != null) {
                  onInvite?.call(invites);
                }
              },
              child: Text(l10n.inviteMembersCTA)),
        ],
      ),
    );
  }
}
