import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Asks the user to accept the terms in force before anything else.
class TermsContainer extends StatelessWidget {
  const TermsContainer({super.key});

  // The legal pages live on the website, not in the app (grup.rsvp).
  static final termsUrl = Uri.parse('https://www.grup.rsvp/terms/');
  static final privacyUrl = Uri.parse('https://www.grup.rsvp/privacy-policy/');

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) =>
        TermsViewModel(billing: context.read(), auth: context.read()),
    child: Consumer<TermsViewModel>(
      builder: (context, viewModel, _) => TermsScreen(
        busy: viewModel.accept.running || viewModel.signOut.running,
        onOpenTerms: () => launchUrl(termsUrl),
        onOpenPrivacy: () => launchUrl(privacyUrl),
        onAccept: () async {
          await viewModel.accept.execute();
          if (context.mounted) showFailure(context, viewModel.accept.result);
        },
        onSignOut: () async {
          await viewModel.signOut.execute();
          if (context.mounted) showFailure(context, viewModel.signOut.result);
        },
      ),
    ),
  );
}
