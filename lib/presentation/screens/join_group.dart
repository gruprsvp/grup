import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';

/// Shown while an invite link is used, or why it couldn't be.
class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key, this.error});

  /// Why joining failed; `null` while joining.
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = this.error;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.joinGroup)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: error == null
                  ? [
                      const CircularProgressIndicator.adaptive(),
                      const SizedBox(height: 16),
                      Text(l10n.joiningGroup),
                    ]
                  : [
                      Text(
                        errorMessage(l10n, error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => const HomeScreenRoute().go(context),
                        child: Text(l10n.goToGroups),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
