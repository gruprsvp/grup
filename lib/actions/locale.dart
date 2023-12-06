import 'package:flutter/material.dart';

@immutable
class ChangeLocaleAction {
  final Locale? locale;

  const ChangeLocaleAction(this.locale);
}
