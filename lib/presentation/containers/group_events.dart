import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:rrule/rrule.dart';

part 'group_events.freezed.dart';

class GroupEventsContainer extends StatelessWidget {
  final String groupId;

  const GroupEventsContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      builder: (context, vm) => GroupEvents(
        group: vm.group,
        schedules: vm.schedules,
        onCreate: vm.onScheduleCreate,
        onDelete: vm.onScheduleDelete,
        rrulel10n: vm.rrulel10n,
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Group? group,
    Iterable<Schedule>? schedules,
    ValueSetter<Schedule>? onScheduleCreate,
    ValueSetter<Schedule>? onScheduleDelete,
    Future<RruleL10n>? rrulel10n,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, String groupId) {
    final group = store.state.groups.entities[groupId];

    return _ViewModel(
      group: group,
      schedules: store.state.schedules.entities.values
          // TODO Should have a better data model to represent relationships
          .where((schedule) => schedule.group.id == group?.id)
          .toList(),
      loading: store.state.groups.creating ||
          store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      onScheduleCreate: (schedule) => store.dispatch(
        RequestCreateOne<Schedule>(schedule),
      ),
      onScheduleDelete: (schedule) => store.dispatch(
        RequestDeleteOne<Schedule>(schedule.id!),
      ),
      rrulel10n: rruleL10nSelector(store.state),
    );
  }
}
