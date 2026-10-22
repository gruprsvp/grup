import 'package:material_ui/material_ui.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

/// App settings, signing out, and deleting the account.
class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required this._settings,
    required AuthRepository auth,
    required ProfileRepository profile,
  }) {
    signOut = Command0(auth.signOut);
    deleteAccount = Command0(profile.deleteAccount);
    _settings.addListener(notifyListeners);
  }

  final SettingsRepository _settings;

  late final Command0<void> signOut;
  late final Command0<void> deleteAccount;

  ThemeMode get themeMode => _settings.themeMode;

  /// The language the user picked, or `null` to follow the system.
  Locale? get locale => _settings.locale;

  void nextThemeMode() => _settings.nextThemeMode();

  void setLocale(Locale? locale) => _settings.setLocale(locale);

  @override
  void dispose() {
    _settings.removeListener(notifyListeners);
    super.dispose();
  }
}
