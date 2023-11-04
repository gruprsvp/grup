import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class HomeScreen extends StatelessWidget {
  final Profile? profile;

  const HomeScreen({super.key, this.profile});

  ImageProvider? _profilePicture() {
    if (profile?.picture != null) {
      return NetworkImage(profile!.picture!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          ProfilePicture(
            onPressed: () => ProfileRoute().push(context),
            image: _profilePicture(),
            name: profile?.displayName,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                l10n.onboardingMessage,
                style: theme.textTheme.bodyLarge,
              ),
              Image.asset('assets/images/wolf.png', height: 320),
            ],
          ),
        ),
      ),
    );
  }
}
