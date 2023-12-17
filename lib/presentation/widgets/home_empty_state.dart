import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A widget to display when the user just joined and has no groups.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            l10n.onboardingMessage,
            style: theme.textTheme.bodyLarge,
          ),
          Expanded(child: Image.asset('assets/images/wolf.webp')),
        ],
      ),
    );
  }
}
