import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'edit_group.freezed.dart';

class EditGroup extends StatelessWidget {
  final String groupId;

  const EditGroup({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      builder: (context, vm) => GroupForm(
        onSave: vm.onSave,
        group: vm.group,
      ),
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    required OnGroupSaveCallback onSave,
    Group? group,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store, String groupId) {
    final group = store.state.groups.entities[groupId];

    return _ViewModel(
      group: group,
      loading: store.state.groups.creating ||
          store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      // TODO unique action per source
      onSave: (group) => store.dispatch(
        RequestUpdateOne<Group>(group),
      ),
    );
  }
}
