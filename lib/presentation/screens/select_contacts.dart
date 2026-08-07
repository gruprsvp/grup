import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/util/util.dart';

class SelectContactsScreen extends StatefulWidget {
  const SelectContactsScreen({super.key});

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  final Set<int> selected = {};
  late final Future<List<Contact>> contacts;

  @override
  initState() {
    super.initState();
    contacts = _getContacts();
  }

  Future<List<Contact>> _getContacts() async {
    // TODO handle permissions not granted with error
    await FlutterContacts.permissions.request(PermissionType.read);

    return FlutterContacts.getAll(
      properties: {
        ContactProperty.name,
        ContactProperty.phone,
        ContactProperty.email,
        ContactProperty.photoThumbnail,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectContacts),
        actions: [
          Badge(
            label: Text(selected.length.toString()),
            isLabelVisible: selected.length > 1,
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: selected.isNotEmpty
                  ? () async {
                      final c = await contacts;
                      final selectedContacts = selected
                          .map((i) => c[i])
                          .toList();
                      if (!context.mounted) {
                        // TODO: how can we avoid this?
                        return;
                      }
                      // TODO maybe add a confirmation dialog?
                      Navigator.pop(context, selectedContacts);
                    }
                  : null,
              icon: const Icon(Icons.group_add),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: contacts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final displayName = contact.displayName ?? '';
                final picture =
                    contact.photo?.thumbnail ?? contact.photo?.fullSize;

                return CheckboxListTile.adaptive(
                  secondary: CircleAvatar(
                    backgroundColor: getColorFromHashCode(displayName),
                    backgroundImage: picture != null
                        ? MemoryImage(picture)
                        : null,
                    child: picture != null
                        ? null
                        : Text(getNameInitials(displayName) ?? ''),
                  ),
                  title: Text(displayName),
                  value: selected.contains(index),
                  onChanged: (value) => setState(
                    () => value! ? selected.add(index) : selected.remove(index),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
