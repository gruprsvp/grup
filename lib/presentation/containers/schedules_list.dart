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

part 'schedules_list.freezed.dart';

class SchedulesListContainer extends StatefulWidget {
  final String? groupId;

  const SchedulesListContainer({
    super.key,
    this.groupId,
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
            groupId: widget.groupId,
            scheduleInstances: vm.schedules,
            isAdmin: vm.isAdmin,
            onReplyChanged: vm.onReplyChanged,
          );
        },
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ValueChanged<DateTime> onDateChanged,
    required bool isAdmin,
    DateTime? selectedDate,
    Iterable<ScheduleInstanceSummary>? schedules,
    OnReplyChangedCallback? onReplyChanged,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isAdmin: selectIsAdmin(store.state),
      selectedDate: store.state.selectedDate,
      schedules: selectScheduleInstancesForSelectedDate(store.state),
      onDateChanged: (value) => store.dispatch(SelectDateAction(value)),
      onReplyChanged: (schedule, reply, replyOption) {
        if (schedule.targetMember?.id == null) {
          throw Exception('targetMemberId is null');
        }
        if (reply != null && replyOption == null) {
          store.dispatch(RequestDeleteReplyAction(reply: reply));
        } else if (replyOption != null) {
          store.dispatch(RequestUpdateOne<Reply>(Reply(
            instanceDate: schedule.instanceDate,
            schedule: schedule.schedule,
            member: store.state.members.entities[schedule.targetMember?.id]!,
            selectedOption: replyOption,
          )));
        }
      },
    );
  }
}
