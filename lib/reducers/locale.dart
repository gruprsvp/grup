import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

final localeReducer = combineReducers<LocaleState?>([
  TypedReducer<LocaleState?, ChangeLocaleAction>(_changeLocale).call,
]);

LocaleState? _changeLocale(LocaleState? locale, ChangeLocaleAction action) {
  final locale = action.locale;

  if (locale == null) {
    return null;
  }

  return LocaleState(
    languageCode: locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  );
}
