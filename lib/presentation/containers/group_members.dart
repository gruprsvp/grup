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

part 'group_members.freezed.dart';

class GroupMembersContainer extends StatelessWidget {
  final String groupId;

  const GroupMembersContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      builder: (context, vm) => GroupMembers(
        members: vm.members,
        onInvite: vm.onInvite,
      ),
      converter: (store) => _ViewModel.fromStore(store, groupId),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    required OnInviteCallback onInvite,
    Iterable<(Member, Profile?)>? members,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, String groupId) =>
      _ViewModel(
        loading: store.state.groups.creating ||
            store.state.groups.loadingAll ||
            (store.state.groups.loadingIds[groupId] ?? false),
        members: groupMembersWithProfilesSelector(store.state),
        onInvite: (contacts) => store.dispatch(InviteGroupMembersAction(
          groupId: groupId,
          contacts: contacts,
        )),
      );
}
