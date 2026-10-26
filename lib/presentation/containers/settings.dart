import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:provider/provider.dart';

/// Provides a [SettingsViewModel] to [builder].
class _Settings extends StatelessWidget {
  const _Settings({required this.builder});

  final Widget Function(BuildContext context, SettingsViewModel vm) builder;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => SettingsViewModel(
      settings: context.read(),
      auth: context.read(),
      profile: context.read(),
      billing: context.read(),
    ),
    child: Consumer<SettingsViewModel>(
      builder: (context, vm, _) => builder(context, vm),
    ),
  );
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({super.key});

  @override
  Widget build(BuildContext context) => _Settings(
    builder: (context, vm) => SettingsScreen(
      themeMode: vm.themeMode,
      onThemeTap: vm.nextThemeMode,
      analytics: vm.analytics,
      onAnalyticsChanged: vm.setAnalytics,
      onSignOut: vm.signOut.running
          ? null
          : () async {
              await vm.signOut.execute();
              if (context.mounted) showFailure(context, vm.signOut.result);
            },
      onManageBilling: vm.showBilling
          ? () async {
              await vm.manageBilling.execute();
              if (context.mounted) {
                await openBillingPage(context, vm.manageBilling.result);
              }
            }
          : null,
    ),
  );
}

class SettingsMoreContainer extends StatelessWidget {
  const SettingsMoreContainer({super.key});

  @override
  Widget build(BuildContext context) => _Settings(
    builder: (context, vm) => SettingsMoreScreen(
      onDeleteProfile: vm.deleteAccount.running
          ? null
          : () async {
              await vm.deleteAccount.execute();
              if (context.mounted) {
                showFailure(context, vm.deleteAccount.result);
              }
            },
    ),
  );
}

class LocaleContainer extends StatelessWidget {
  const LocaleContainer({super.key});

  @override
  Widget build(BuildContext context) => _Settings(
    builder: (context, vm) =>
        LocaleScreen(selectedLocale: vm.locale, onLocaleChanged: vm.setLocale),
  );
}
