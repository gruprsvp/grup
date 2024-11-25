import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';

/// A widget to display when the user just joined and has no groups.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyState(
      text: l10n.onboardingMessage,
      image: 'assets/images/home.webp',
    );
  }
}
