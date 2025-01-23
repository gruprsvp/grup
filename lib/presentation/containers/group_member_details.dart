import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'group_member_details.freezed.dart';

class GroupMemberDetailsContainer extends StatelessWidget {
  final String groupId;
  final String memberId;

  const GroupMemberDetailsContainer({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId, memberId),
      onInit: (store) => store.dispatch(MemberDetailsOpenAction(memberId)),
      builder: (context, vm) => GroupMemberDetailsScreen(
        loading: vm.loading,
        isCurrentUser: vm.isCurrentUser,
        group: vm.group,
        member: vm.member,
        profile: vm.profile,
        invites: vm.invites,
        onUpdate: vm.onUpdate,
        onRemove: vm.onRemove,
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    required bool isCurrentUser,
    Group? group,
    Member? member,
    Profile? profile,
    List<Invite>? invites,
    ValueSetter<Member>? onUpdate,
    OnRemoveFromGroupCallback? onRemove,
  }) = __ViewModel;

  static _ViewModel fromStore(
      Store<AppState> store, String groupId, String memberId) {
    final group = store.state.groups.entities[groupId];

    if (group == null) {
      return const _ViewModel(loading: true, isCurrentUser: false);
    }

    // TODO: should use selectors
    final member = store.state.members.entities[memberId];
    final profile = store.state.profiles.entities[member?.profile?.id];
    final invites = store.state.invites.entities.values
        .where((invite) => invite.member.id.toString() == memberId)
        .toList();

    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      isCurrentUser: store.state.auth.user?.id == profile?.id,
      group: group,
      member: member,
      profile: profile,
      invites: invites,
      onUpdate: (member) => store.dispatch(RequestUpdateOne<Member>(member)),
      onRemove: (member) =>
          store.dispatch(RequestDeleteMemberAction(member: member)),
    );
  }
}
