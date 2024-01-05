import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';

enum _InviteSource { contacts, manually }

class ContactInvite {
  final String? displayNameOverride;
  final List<(InviteMethods, String)> invites;

  const ContactInvite(this.displayNameOverride, this.invites);
}

class GroupMembers extends StatelessWidget {
  final Iterable<Member>? members;

  const GroupMembers({
    super.key,
    this.members,
  });

  Future<List<ContactInvite>?> _inviteFromContacts(BuildContext context) async {
    if (!(await FlutterContacts.requestPermission(readonly: true))) {
      throw Exception('Contacts permission not granted');
    }

    final contacts = await FlutterContacts.getContacts(
      withAccounts: true,
      withPhoto: true,
      withProperties: true,
    );

    if (!context.mounted) {
      // TODO: how can we avoid this?
      throw Exception('Context not mounted');
    }

    final invited = await SelectContactsRoute().push<List<Contact>>(context);

    return invited
        ?.map((c) => ContactInvite(c.displayName, [
              ...(c.emails ?? []).map((e) => (InviteMethods.email, e.address)),
              ...(c.phones ?? [])
                  .map((p) => (InviteMethods.phone, p.normalizedNumber)),
            ]))
        .toList();
  }

  Future<List<ContactInvite>?> _inviteManually() async {
    // TODO implement
    return [];
  }

  Future<List<ContactInvite>?> _inviteNew(BuildContext context) async {
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

    if (!context.mounted) {
      // TODO: how can we avoid this?
      throw Exception('Context not mounted');
    }

    return switch (source) {
      _InviteSource.contacts => _inviteFromContacts(context),
      _InviteSource.manually => _inviteManually(),
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
              final member = members!.elementAt(index);
              final name = member.displayNameOverride ??
                  member.profiles?.displayName ??
                  'Unknown'; // TODO
              return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: member.profiles?.picture != null
                        ? NetworkImage(member.profiles!.picture!)
                        : null,
                    child: member.profiles?.picture == null
                        ? Text(getNameInitials(name)!)
                        : null,
                  ),
                  title: Text(member.displayNameOverride ??
                      member.profiles?.displayName ??
                      'Unknown'),
                  subtitle: Text(member.role.name),
                  onTap: () {});
            },
          )
        : Image.asset('assets/images/seeyoulateralligator.webp');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Expanded(child: topWidget),
          FilledButton(
              onPressed: () => _inviteNew(context),
              child: Text(l10n.inviteMembersCTA)),
        ],
      ),
    );
  }
}
