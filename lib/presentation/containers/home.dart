import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late final _viewModel = HomeViewModel(
    groups: context.read(),
    profile: context.read(),
    settings: context.read(),
  );
  var _askedForName = false;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_askForName);
  }

  /// A new user has no name yet: ask for it, once.
  void _askForName() {
    if (_askedForName || !_viewModel.needsName) return;
    _askedForName = true;
    const ProfileRoute().push<void>(context);
  }

  Future<void> _onGroupCreate(GroupCreateResult result) async {
    switch (result) {
      case GroupCreateResultNew(:final group, :final image):
        await _viewModel.create.execute((group: group, image: image));
        if (mounted) showFailure(context, _viewModel.create.result);
      case GroupCreateResultJoin(:final code):
        await _viewModel.join.execute(code);
        if (mounted) showFailure(context, _viewModel.join.result);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, _) {
      final vm = _viewModel;
      return HomeScreen(
        profile: vm.profile,
        groups: vm.groups,
        loading: vm.refresh.running || vm.create.running || vm.join.running,
        error: switch (vm.refresh.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRefresh: vm.refresh.execute,
        onGroupCreate: _onGroupCreate,
        shouldShowFeedback: vm.showFeedbackCard,
        onFeedbackDismiss: vm.dismissFeedback,
        onAnalyticsChoice: vm.showAnalyticsCard ? vm.setAnalytics : null,
      );
    },
  );
}
