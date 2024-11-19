import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/members.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'group_details.freezed.dart';

class GroupDetailsContainer extends StatelessWidget {
  final String groupId;

  const GroupDetailsContainer({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, groupId),
      onInit: (store) => store.dispatch(GroupDetailsOpenAction(groupId)),
      builder: (context, vm) => GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && vm.selectedDate != null) {
            if (details.primaryVelocity! < 0) {
              // Swipe left to increment date
              vm.onDateChanged(vm.selectedDate!.add(Duration(days: 1)));
            } else if (details.primaryVelocity! > 0) {
              // Swipe right to decrement date
              vm.onDateChanged(vm.selectedDate!.subtract(Duration(days: 1)));
            }
          }
        },
        child: GroupDetailsScreen(
          loading: vm.loading,
          group: vm.group,
          isAdmin: vm.isAdmin,
        ),
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    required bool isAdmin,
    required ValueChanged<DateTime> onDateChanged,
    Group? group,
    DateTime? selectedDate,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<AppState> store, String groupId) {
    return _ViewModel(
      loading: store.state.groups.loadingAll ||
          (store.state.groups.loadingIds[groupId] ?? false),
      group: store.state.groups.entities[groupId],
      selectedDate: store.state.selectedDate,
      isAdmin: selectIsAdmin(store.state, int.parse(groupId)),
      onDateChanged: (value) => store.dispatch(SelectDateAction(value)),
    );
  }
}
