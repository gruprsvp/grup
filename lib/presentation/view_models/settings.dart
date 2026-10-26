import 'package:material_ui/material_ui.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

import 'view_model.dart';

/// App settings, signing out, and deleting the account.
class SettingsViewModel extends ViewModel {
  SettingsViewModel({
    required this._settings,
    required AuthRepository auth,
    required ProfileRepository profile,
    required this._billing,
  }) {
    signOut = Command0(auth.signOut);
    deleteAccount = Command0(profile.deleteAccount);
    manageBilling = Command0(() => _billing.portal('/settings'));
    listenTo([_settings, _billing, signOut, deleteAccount, manageBilling]);
    _billing.refresh().ignore();
  }

  final SettingsRepository _settings;
  final BillingRepository _billing;

  late final Command0<void> signOut;
  late final Command0<void> deleteAccount;

  /// Opens Stripe's Customer Portal: its URL.
  late final Command0<Uri> manageBilling;

  /// The user has paid on the web, where they manage it (Settings → Billing).
  /// It stays even if their group is gone: this is how they cancel then.
  bool get showBilling => appPlatform == null && _billing.state.isCustomer;

  ThemeMode get themeMode => _settings.themeMode;

  /// The language the user picked, or `null` to follow the system.
  Locale? get locale => _settings.locale;

  bool get analytics => _settings.analytics ?? false;

  void nextThemeMode() => _settings.nextThemeMode();

  void setAnalytics(bool enabled) => _settings.setAnalytics(enabled);

  void setLocale(Locale? locale) => _settings.setLocale(locale);
}
