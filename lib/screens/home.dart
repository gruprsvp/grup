import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/images/wolf.png', height: 320),
              Text(
                AppLocalizations.of(context)!.onboardingMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
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
            onTap: () => SettingsRoute().go(context),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.signOut),
            leading: const Icon(Icons.logout),
            onTap: () {
              // TODO(borgoat): show confirmation dialog and use Redux
              Supabase.instance.client.auth.signOut();
              AuthRoute().replace(context);
            },
          ),
        ],
      ),
    );
  }
}
