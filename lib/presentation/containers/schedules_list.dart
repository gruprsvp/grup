import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'schedules_list.freezed.dart';

class SchedulesListContainer extends StatelessWidget {
  final int groupId;

  const SchedulesListContainer({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      distinct: true,
      builder: (context, vm) => SchedulesList(schedules: vm.schedules),
      converter: (store) => _ViewModel.fromStore(store, groupId),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    Iterable<ScheduleInstance>? schedules,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store, int groupId) {
    return _ViewModel(
      schedules: selectSchedulesAndReplies(store.state, groupId),
    );
  }
}
