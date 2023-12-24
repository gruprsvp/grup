import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'date_fab.freezed.dart';

class DateFabContainer extends StatelessWidget {
  const DateFabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      distinct: true,
      builder: (context, vm) => DateFab(
        date: vm.selectedDate,
        onDateChanged: vm.onDateChanged,
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateChanged,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store) {
    return _ViewModel(
        selectedDate: store.state.selectedDate,
        onDateChanged: (value) => store.dispatch(SelectDateAction(value)));
  }
}
