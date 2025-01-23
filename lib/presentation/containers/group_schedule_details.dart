import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
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
        builder: (context, vm) {
          final scheduleInstance = vm.scheduleInstance;
          final group = vm.group;

          if (scheduleInstance == null || group == null) {
            Navigator.pop(context);
            return Container();
          }

          return GroupScheduleDetailsScreen(
            loading: vm.loading,
            group: group,
            scheduleInstance: scheduleInstance,
            onReplyChanged: vm.onReplyChanged,
            onDefaultRuleChanged: vm.onDefaultRuleChanged,
          );
        });
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

    final scheduleInstance = selectScheduleInstanceForDate(store.state);

    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      group: group,
      scheduleInstance: scheduleInstance,
      onReplyChanged: (reply, replyOption) {
        final hasReplyOption = replyOption != null;

        if (hasReplyOption) {
          store.dispatch(RequestUpdateOne(reply.copyWith(
            selectedOption: replyOption,
          )));
        } else {
          store.dispatch(RequestDeleteReplyAction(reply: reply));
        }
      },
      onDefaultRuleChanged: (defaultRule, recurrenceRule, replyOptions) {
        final hasRecurrenceRule = recurrenceRule != null;
        final hasReplyOptions = replyOptions != null;
        if (hasRecurrenceRule && hasReplyOptions) {
          store.dispatch(RequestUpdateOne(defaultRule.copyWith(
            recurrenceRule: recurrenceRule,
            selectedOption: replyOptions,
          )));
        } else {
          store.dispatch(
              RequestDeleteDefaultRuleAction(defaultRule: defaultRule));
        }
      },
    );
  }
}
