import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'group_details.freezed.dart';

class GroupDetailsContainer extends StatelessWidget {
  final String groupId;

  const GroupDetailsContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      builder: (context, vm) => GroupDetailsScreen(
        loading: vm.loading,
        group: vm.group,
      ),
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Group? group,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store, String groupId) {
    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      group: store.state.groups.entities[groupId],
    );
  }
}
