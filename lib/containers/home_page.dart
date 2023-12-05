import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/screens/screens.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'home_page.freezed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, vm) => HomeScreen(
        profile: vm.profile,
        groups: vm.groups,
        loading: vm.loading,
        onNewGroup: vm.onNewGroup,
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool loading,
    Profile? profile,
    Iterable<Group>? groups,
    NewGroupReturnCallback? onNewGroup,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store) {
    return _ViewModel(
      loading: store.state.groups.loadingAll || store.state.groups.creating,
      profile: store.state.profiles.entities[store.state.auth.user?.id],
      groups: store.state.groups.entities.values,
      onNewGroup: (value) => store.dispatch(
        switch (value) {
          NewGroupReturnNew(group: final group) =>
            RequestCreateOne<Group>(group),
          // TODO: Handle this case.
          NewGroupReturnJoin() => null,
        },
      ),
    );
  }
}
