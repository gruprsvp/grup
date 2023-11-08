import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/create_group_form.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

part 'create_group.freezed.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) => CreateGroupForm(
        creationInProgress: vm.creatingGroup,
        onCreateGroup: vm.onSave,
      ),
    );
  }
}

@freezed
class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required bool creatingGroup,
    required OnCreateGroupCallback onSave,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store) {
    return _ViewModel(
      creatingGroup: store.state.groups.creating,
      // TODO unique action per source
      onSave: (displayName) => store.dispatch(
          RequestCreateOne<Group>(Group(id: 0, displayName: displayName))),
    );
  }
}
