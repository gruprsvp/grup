import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'group_manage.freezed.dart';

class GroupManageContainer extends StatelessWidget {
  final String groupId;

  const GroupManageContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      builder: (context, vm) => GroupManageScreen(
        loading: vm.loading,
        group: vm.group,
        onDelete: vm.onDelete,
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Group? group,
    required ValueSetter<Group> onDelete,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, String groupId) {
    final group = store.state.groups.entities[groupId];

    return _ViewModel(
      group: group,
      loading: store.state.groups.creating ||
          store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      onDelete: (group) => store.dispatch(GroupDeleteAction(group)),
    );
  }
}
