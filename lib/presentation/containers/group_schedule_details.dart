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
      converter: (store) => _ViewModel.fromStore(
          store, int.parse(groupId), int.parse(scheduleId)),
      onInit: (store) => store.dispatch(GroupDetailsOpenAction(groupId)),
      builder: (context, vm) => GroupScheduleDetailsScreen(
        loading: vm.loading,
        schedule: vm.schedule,
      ),
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    ScheduleInstance? schedule,
  }) = __ViewModel;

  static _ViewModel fromStore(
      Store<AppState> store, int groupId, int scheduleId) {
    return _ViewModel(
        loading: store.state.groups.loadingAll ||
            (store.state.groups.loadingIds[groupId] ?? false),
        schedule: selectScheduleForDate(store.state, groupId, scheduleId));
  }
}
