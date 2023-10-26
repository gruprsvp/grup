import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The home screen of the app.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.appName,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      drawer: NavigationDrawer(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(child: Text('JD')),
            accountName: const Text('John Doe'),
            accountEmail: const Text('john.doe@example.com'),
            onDetailsPressed: () {},
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.newGroup),
            leading: const Icon(Icons.group_add),
            onTap: () => context.push('/groups/new'),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
            leading: const Icon(Icons.settings),
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}
