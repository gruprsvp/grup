import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';

import 'view_model.dart';

/// The user's own profile.
class ProfileViewModel extends ViewModel {
  ProfileViewModel({required this._profile, required this._groups}) {
    save = Command1(_save);
    listenTo([_profile, save]);
  }

  final ProfileRepository _profile;
  final GroupsRepository _groups;

  late final Command1<Profile, ({String name, XFile? image})> save;

  Profile? get profile => _profile.profile;

  Future<Result<Profile>> _save(({String name, XFile? image}) args) async {
    final result = await _profile.save(name: args.name, image: args.image);
    // Group member lists hold their own copy of the profile.
    if (result case Ok(:final value)) _groups.updateProfile(value);
    return result;
  }
}
