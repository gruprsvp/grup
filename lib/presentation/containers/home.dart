import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'home.freezed.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      distinct: true,
      builder: (context, vm) => HomeScreen(
        profile: vm.profile,
        groups: vm.groups,
        loading: vm.loading,
        onGroupCreate: vm.onGroupCreate,
        onRefresh: vm.onRefresh,
        shouldShowFeedback: vm.shouldShowFeedback,
        onFeedbackDismiss: vm.onFeedbackDismiss,
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Profile? profile,
    Iterable<Group>? groups,
    ValueSetter<GroupCreateResult>? onGroupCreate,
    AsyncCallback? onRefresh,
    bool? shouldShowFeedback,
    VoidCallback? onFeedbackDismiss,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loading: store.state.groups.loadingAll || store.state.groups.creating,
      profile: store.state.profiles.entities[store.state.auth.user?.id],
      groups: store.state.groups.entities.values,
      onGroupCreate: (value) => store.dispatch(
        switch (value) {
          GroupCreateResultNew(group: final group, image: final image) =>
            CreateGroupAction(group: group, image: image),
          GroupCreateResultJoin(code: final code) =>
            JoinWithInviteCodeAction(code),
        },
      ),
      onRefresh: () async {
        final action = GroupRefreshAllAction();
        store.dispatch(action);
        await action.completer.future;
      },
      shouldShowFeedback: selectShouldShowFeedbackCard(store.state),
      onFeedbackDismiss: () => store.dispatch(InteractedWithFeedback()),
    );
  }
}
