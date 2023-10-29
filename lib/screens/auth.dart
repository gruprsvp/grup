import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SupaEmailAuth(
            onSignInComplete: (response) => HomeScreenRoute().go(context),
            onSignUpComplete: (response) => HomeScreenRoute().go(context),
          ),
        ),
      ),
    );
  }
}
