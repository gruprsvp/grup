import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:parousia/presentation/widgets/widgets.dart';

class DateDropdownContainer extends StatelessWidget {
  const DateDropdownContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      builder: (context, vm) => DateDropdown(
        date: vm.selectedDate,
        onDateChanged: vm.onDateChanged,
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

class _ViewModel {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  _ViewModel({
    required this.selectedDate,
    required this.onDateChanged,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedDate: store.state.selectedDate,
      onDateChanged: (value) => store.dispatch(SelectDateAction(value)),
    );
  }
}
