import 'package:material_ui/material_ui.dart';

@immutable
class ChangeLocaleAction {
  final Locale? locale;

  const ChangeLocaleAction(this.locale);
}
