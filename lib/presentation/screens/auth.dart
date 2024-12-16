import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/util/config.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:universal_html/html.dart' as html;

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
        // TODO(borgoat): this shouldn't be needed: fix the navigation stack instead
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          SupaPasswordAuth(
            redirectTo: _getRedirectUrl(),
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
            onSuccess: (session) => HomeScreenRoute().go(context),
          ),
        ]),
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
