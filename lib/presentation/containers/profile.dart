import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'profile.freezed.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, vm) => ProfileScreen(
        profile: vm.profile,
        onSave: vm.onSave,
      ),
      converter: _ViewModel.fromStore,
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  // TODO add loading state

  const factory _ViewModel({
    Profile? profile,
    required OnProfileSaveCallback onSave,
  }) = __ViewModel;

  static _ViewModel fromStore(Store<RootState> store) {
    return _ViewModel(
      profile: store.state.profiles.entities[store.state.auth.user?.id],
      onSave: (name, image) =>
          store.dispatch(SaveProfileAction(name: name, image: image)),
    );
  }
}
