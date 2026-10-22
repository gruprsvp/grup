import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'app_localizations.dart';

/// supabase_auth_ui's strings, in every language the app speaks.
///
/// The package only ships English, but its widgets look their strings up by
/// type, so registering [delegate] translates the sign-in screen. The
/// translations live in the app's ARB files (the `auth...` keys).
class AuthUILocalizations extends SupabaseAuthUILocalizations {
  AuthUILocalizations(this._l10n) : super(_l10n.localeName);

  static const LocalizationsDelegate<SupabaseAuthUILocalizations> delegate =
      _Delegate();

  final AppLocalizations _l10n;

  @override
  String get enterEmail => _l10n.authEnterEmail;
  @override
  String get validEmailError => _l10n.authValidEmailError;
  @override
  String get enterPassword => _l10n.authEnterPassword;
  @override
  String get passwordLengthError => _l10n.authPasswordLengthError;
  @override
  String get signIn => _l10n.authSignIn;
  @override
  String get signUp => _l10n.authSignUp;
  @override
  String get forgotPassword => _l10n.authForgotPassword;
  @override
  String get dontHaveAccount => _l10n.authDontHaveAccount;
  @override
  String get haveAccount => _l10n.authHaveAccount;
  @override
  String get sendPasswordReset => _l10n.authSendPasswordReset;
  @override
  String get passwordResetSent => _l10n.authPasswordResetSent;
  @override
  String get backToSignIn => _l10n.authBackToSignIn;
  @override
  String get unexpectedError => _l10n.authUnexpectedError;
  @override
  String get requiredFieldError => _l10n.authRequiredFieldError;
  @override
  String get confirmPasswordError => _l10n.authConfirmPasswordError;
  @override
  String get confirmPassword => _l10n.authConfirmPassword;
  @override
  String get enterOtpCode => _l10n.authEnterOtpCode;
  @override
  String get enterNewPassword => _l10n.authEnterNewPassword;
  @override
  String get changePassword => _l10n.authChangePassword;
  @override
  String get passwordChangedSuccess => _l10n.authPasswordChangedSuccess;
  @override
  String get otpCodeError => _l10n.authOtpCodeError;
  @override
  String get otpDisabledError => _l10n.authOtpDisabledError;
  @override
  String get enterPhoneNumber => _l10n.authEnterPhoneNumber;
  @override
  String get validPhoneNumberError => _l10n.authValidPhoneNumberError;
  @override
  String get continueWithMagicLink => _l10n.authContinueWithMagicLink;
  @override
  String get checkYourEmail => _l10n.authCheckYourEmail;
  @override
  String get successSignInMessage => _l10n.authSuccessSignInMessage;
  @override
  String get updatePassword => _l10n.authUpdatePassword;
  @override
  String get enterOneTimeCode => _l10n.authEnterOneTimeCode;
  @override
  String get enterCodeSent => _l10n.authEnterCodeSent;
  @override
  String get verifyPhone => _l10n.authVerifyPhone;
  @override
  String continueWithProvider(String provider) =>
      _l10n.authContinueWithProvider(provider);
}

class _Delegate extends LocalizationsDelegate<SupabaseAuthUILocalizations> {
  const _Delegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<SupabaseAuthUILocalizations> load(Locale locale) =>
      SynchronousFuture(AuthUILocalizations(lookupAppLocalizations(locale)));

  @override
  bool shouldReload(_Delegate old) => false;
}
