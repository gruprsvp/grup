// Legacy-Material island. supabase_auth_ui is still built on the in-framework
// Material library (package:flutter/material.dart), whose types are distinct
// from package:material_ui's. Its widgets look up framework Theme,
// MaterialLocalizations, Material and ScaffoldMessenger ancestors (the latter
// for error SnackBars), so this screen builds that chain from the framework
// library, bridged from the app's material_ui theme. Move it to material_ui
// once supabase_auth_ui migrates; test/auth_screen_test.dart guards it.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart' as modern;
import 'package:parousia/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/util/config.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:universal_html/html.dart' as html;

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The bridge maps the app's material_ui theme (colour scheme, text theme)
    // onto a framework Theme and registers the framework localizations. It is
    // deprecated only because it is meant to be temporary.
    // ignore: deprecated_member_use
    return const modern.MaterialUiCompatibilityBridge(
      child: ScaffoldMessenger(child: _AuthScaffold()),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold();

  @override
  Widget build(BuildContext context) {
    final config = ConfigService().config;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appName,
          style: GoogleFonts.sniglet(
            color: theme.colorScheme.primary,
            textStyle: theme.textTheme.headlineLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Nowhere to go back to while signed out.
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // No navigation in these callbacks: once signed in, the router
              // leaves this page for wherever the user was going (see
              // router.dart), e.g. the invite link that brought them here.
              SupaEmailAuth(
                redirectTo: _getRedirectUrl(),
                onSignInComplete: (_) {},
                // Email confirmation is disabled, so sign-up yields a session
                // immediately. If confirmations get enabled, show a "check your
                // email" state here instead.
                onSignUpComplete: (_) {},
              ),
              Divider(height: 64),
              SupaSocialsAuth(
                socialProviders: [OAuthProvider.apple, OAuthProvider.google],
                nativeGoogleAuthConfig: NativeGoogleAuthConfig(
                  webClientId: config.socialAuthWebClientId,
                  iosClientId: config.socialAuthIosClientId,
                ),
                enableNativeAppleAuth: true,
                redirectUrl: _getRedirectUrl(),
                onSuccess: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get the redirect URL from the web browser.
  /// This is needed to handle different ports
  /// when launching on localhost.
  String? _getRedirectUrl() {
    if (!kIsWeb) return 'grup://auth-callback';

    final currentUrl = html.window.location.href;
    final uri = Uri.parse(currentUrl);
    final redirectUrl = Uri(scheme: uri.scheme, host: uri.host, port: uri.port);
    return redirectUrl.toString();
  }
}
