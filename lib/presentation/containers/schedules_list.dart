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

part 'schedules_list.freezed.dart';

class SchedulesListContainer extends StatefulWidget {
  final int groupId;

  const SchedulesListContainer({
    super.key,
    required this.groupId,
  });

  @override
  SchedulesListContainerState createState() => SchedulesListContainerState();
}

class SchedulesListContainerState extends State<SchedulesListContainer> {
  late PageController _pageController;
  int currentIndex = 100000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      builder: (context, vm) => PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          final deltaDays = index - currentIndex;
          if (deltaDays != 0 && vm.selectedDate != null) {
            vm.onDateChanged(vm.selectedDate!.add(Duration(days: deltaDays)));
          }
          currentIndex = index;
        },
        itemBuilder: (context, index) {
          return SchedulesList(
            schedules: vm.schedules,
            onReplyChanged: vm.onReplyChanged,
          );
        },
      ),
      converter: (store) => _ViewModel.fromStore(store, widget.groupId),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ValueChanged<DateTime> onDateChanged,
    DateTime? selectedDate,
    Iterable<ScheduleSummary>? schedules,
    OnReplyChangedCallback? onReplyChanged,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, int groupId) {
    return _ViewModel(
      selectedDate: store.state.selectedDate,
      schedules: selectSchedulesForSelectedDate(store.state, groupId),
      onDateChanged: (value) => store.dispatch(SelectDateAction(value)),
      onReplyChanged: (schedule, reply) {
        if (schedule.targetMemberId == null) {
          throw Exception('targetMemberId is null');
        }
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
