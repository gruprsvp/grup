import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/config.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:universal_html/html.dart' as html;

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    onSuccess(session) => HomeScreenRoute().go(context);

    final config = ConfigService().config;

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
            nativeGoogleAuthConfig: NativeGoogleAuthConfig(
              webClientId: config.socialAuthWebClientId,
              iosClientId: config.socialAuthIosClientId,
            ),
            enableNativeAppleAuth: true,
            redirectUrl: _getRedirectUrl(),
            onSuccess: onSuccess,
          ),
        ]),
      ),
    );
  }

  /// Get the redirect URL from the web browser.
  /// This is needed to handle different ports
  /// when launching on localhost.
  String? _getRedirectUrl() {
    if (!kIsWeb) return null;

    final currentUrl = html.window.location.href;
    final uri = Uri.parse(currentUrl);
    return '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';
  }
}
