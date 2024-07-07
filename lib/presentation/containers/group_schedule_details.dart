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
      converter: (store) => _ViewModel.fromStore(store, groupId, scheduleId),
      onInit: (store) => store.dispatch(GroupDetailsOpenAction(groupId)),
      builder: (context, vm) => GroupScheduleDetailsScreen(
        loading: vm.loading,
        group: vm.group,
        schedule: vm.schedule,
        onReplyChanged: vm.onReplyChanged,
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Group? group,
    ScheduleSummary? schedule,
    OnReplyChangedCallback? onReplyChanged,
  }) = __ViewModel;

  static _ViewModel fromStore(
      Store<AppState> store, String groupId, String scheduleId) {
    final group = store.state.groups.entities[groupId];

    if (group == null) {
      return const _ViewModel(loading: true);
    }

    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      group: group,
      schedule:
          selectScheduleForDate(store.state, group.id, int.parse(scheduleId)),
      onReplyChanged: (schedule, reply) {
        if (reply == null) {
          store.dispatch(RequestDeleteReplyAction(
            memberId: schedule.targetMemberId!,
            scheduleId: schedule.scheduleId,
            eventDate: schedule.eventDate,
          ));
        } else {
          store.dispatch(RequestUpdateOne(Reply(
              memberId: schedule.targetMemberId!,
              scheduleId: schedule.scheduleId,
              eventDate: schedule.eventDate,
              selectedOption: reply)));
        }
      },
    );
  }
}
