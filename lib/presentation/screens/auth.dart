import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    onSuccess(session) => HomeScreenRoute().go(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        // TODO(borgoat): this shouldn't be needed: fix the navigation stack instead
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          EmailOrPhoneAuth(),
          Divider(height: 64),
          SupaSocialsAuth(
            socialProviders: [OAuthProvider.apple, OAuthProvider.google],
            onSuccess: onSuccess,
          ),
        ]),
      ),
    );
  }
}
