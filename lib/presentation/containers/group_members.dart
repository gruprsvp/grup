import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'group_members.freezed.dart';

class GroupMembersContainer extends StatelessWidget {
  final String groupId;

  const GroupMembersContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      distinct: true,
      builder: (context, vm) => GroupMembers(
        members: vm.members,
      ),
      converter: (store) => _ViewModel.fromStore(store, groupId),
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Iterable<Member>? members,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store, String groupId) {
    return _ViewModel(
        loading: store.state.groups.creating ||
            store.state.groups.loadingAll ||
            (store.state.groups.loadingIds[groupId] ?? false),
        members: store.state.groups.entities[groupId]?.members);
  }
}
