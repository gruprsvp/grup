import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(
                Icons.camera_alt_rounded,
                size: 32,
                color: Colors.white.withOpacity(0.8),
              ),
              backgroundImage: const AssetImage('assets/images/wolf.png'),
              radius: 64,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.enterYourName,
              ),
            ),
            // TODO(borgoat): options to link additional auth providers
          ],
        ),
      ),
    );
  }
}
