import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'group_schedule_details.freezed.dart';

class GroupScheduleDetailsContainer extends StatelessWidget {
  final String groupId;
  final String scheduleId;

  const GroupScheduleDetailsContainer({
    super.key,
    required this.groupId,
    required this.scheduleId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      onInit: (store) =>
          store.dispatch(GroupScheduleDetailsOpenAction(scheduleId)),
      builder: (context, vm) => GroupScheduleDetailsScreen(
        loading: vm.loading,
        group: vm.group,
        scheduleInstance: vm.scheduleInstance,
        onReplyChanged: vm.onReplyChanged,
        onDefaultRuleChanged: vm.onDefaultRuleChanged,
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Group? group,
    ScheduleInstanceDetails? scheduleInstance,
    OnDetailsReplyChangedCallback? onReplyChanged,
    OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, String groupId) {
    final group = store.state.groups.entities[groupId];

    if (group == null) {
      return const _ViewModel(loading: true);
    }

    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      group: group,
      scheduleInstance: selectScheduleInstanceForDate(store.state),
      onReplyChanged: (schedule, targetMemberId, reply) {
        if (reply == null) {
          store.dispatch(RequestDeleteReplyAction(
            memberId: targetMemberId,
            scheduleId: schedule.scheduleId,
            instanceDate: schedule.instanceDate,
          ));
        } else {
          store.dispatch(RequestUpdateOne(Reply(
              memberId: targetMemberId,
              scheduleId: schedule.scheduleId,
              instanceDate: schedule.instanceDate,
              selectedOption: reply)));
        }
      },
      onDefaultRuleChanged: (defaultOption, scheduleId, targetMemberId, reply) {
        if (defaultOption == null) {
          store.dispatch(RequestDeleteDefaultRuleAction(
            memberId: targetMemberId,
            scheduleId: scheduleId,
          ));
        } else {
          store.dispatch(RequestUpdateOne(DefaultRule(
              memberId: targetMemberId,
              scheduleId: scheduleId,
              selectedOption: reply,
              recurrenceRule: defaultOption)));
        }
      },
    );
  }
}
