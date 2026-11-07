import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:provider/provider.dart';

/// The public cancellation page (https://grup.rsvp/cancel).
class CancelContainer extends StatelessWidget {
  const CancelContainer({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => CancelViewModel(
      auth: context.read(),
      billing: context.read(),
      groups: context.read(),
    ),
    child: Consumer<CancelViewModel>(
      builder: (context, viewModel, _) => CancelScreen(
        email: viewModel.email,
        paidGroups: viewModel.paidGroups,
        sending: viewModel.submit.running,
        sent: viewModel.submit.completed,
        onSubmit: (request) async {
          await viewModel.submit.execute(request);
          if (context.mounted) showFailure(context, viewModel.submit.result);
        },
      ),
    ),
  );
}
