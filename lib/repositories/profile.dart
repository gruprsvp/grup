import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'user_data.dart';

/// The signed-in user's own profile.
class ProfileRepository extends UserData {
  ProfileRepository({
    required ProfilesService profiles,
    required this._storage,
    required LocalCache cache,
    required Stream<AuthState> authChanges,
  }) : _profilesService = profiles,
       super(cache, cacheKey) {
    _subscription = authChanges.listen(
      (state) {
        // Sign in with Apple sends the user's name in an update that comes
        // after the sign-in itself.
        if (state.event == AuthChangeEvent.userUpdated) load();
      },
      onError: (Object _) {}, // AuthRepository handles auth failures.
    );
  }

  /// Where the device copy lives in [LocalCache].
  static const cacheKey = 'profile';

  final ProfilesService _profilesService;
  final StorageService _storage;
  late final StreamSubscription<AuthState> _subscription;

  Profile? _profile;

  Profile? get profile => _profile;

  Future<Result<void>> load() {
    final userId = this.userId;
    if (userId == null) {
      return Future.value(const Result.error(NotSignedInException()));
    }
    final generation = this.generation;
    return guard(() async {
      final profile = await _profilesService.getProfileById(userId);
      ifCurrent(generation, () => _profile = profile);
    });
  }

  /// Saves the user's [name], with [image] as their new picture if set.
  Future<Result<Profile>> save({required String name, XFile? image}) {
    final userId = this.userId;
    if (userId == null) {
      return Future.value(const Result.error(NotSignedInException()));
    }
    final generation = this.generation;
    return guard(() async {
      final old = _profile?.picture;
      final picture = image == null
          ? null
          : await _storage.uploadPublicXFile(const Uuid().v7(), image);
      final profile = await _profilesService.updateProfile(
        id: userId,
        displayName: name,
        pictureUrl: picture,
      );
      ifCurrent(generation, () => _profile = profile);
      if (picture != null) await _forgetFile(old);
      return profile;
    });
  }

  /// Deletes the user's account and files, then signs out everywhere.
  Future<Result<void>> deleteAccount() => guard(() async {
    await _storage.deleteUserFiles();
    await _profilesService.deleteProfile();
    await _profilesService.signOut();
  });

  /// Deletes a replaced picture. Best effort: a file left behind only takes
  /// up space, so a failure doesn't fail the save.
  Future<void> _forgetFile(String? url) async {
    if (url == null) return;
    try {
      await _storage.deletePublicUrl(url);
    } on Object catch (_) {}
  }

  @override
  void clear() => _profile = null;

  @override
  Map<String, dynamic> toCache() => {'profile': _profile?.toJson()};

  @override
  void fromCache(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    _profile = profile == null ? null : Profile.fromJson(profile);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
