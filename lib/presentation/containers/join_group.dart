import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

/// Uses an invite link, then shows the user their groups.
class JoinGroupContainer extends StatefulWidget {
  const JoinGroupContainer({super.key, required this.code});

  final String code;

  @override
  State<JoinGroupContainer> createState() => _JoinGroupContainerState();
}

class _JoinGroupContainerState extends State<JoinGroupContainer> {
  late final _viewModel = JoinGroupViewModel(
    code: widget.code,
    groups: context.read(),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onJoined);
  }

  void _onJoined() {
    if (!_viewModel.join.completed) return;
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context)!.joinedGroup;
    const HomeScreenRoute().go(context);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, _) => JoinGroupScreen(
      error: switch (_viewModel.join.result) {
        Error(:final error) => error,
        _ => null,
      },
    ),
  );
}
