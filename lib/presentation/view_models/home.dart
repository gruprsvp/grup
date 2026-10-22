import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';

/// The home screen: the user's groups.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this._groups,
    required this._profile,
    required this._settings,
  }) {
    refresh = Command0(_refresh)..execute();
    create = Command1((args) => _groups.create(args.group, image: args.image));
    join = Command1(_groups.join);
    for (final repository in _repositories) {
      repository.addListener(notifyListeners);
    }
  }

  final GroupsRepository _groups;
  final ProfileRepository _profile;
  final SettingsRepository _settings;

  List<ChangeNotifier> get _repositories => [_groups, _profile, _settings];

  late final Command0<void> refresh;
  late final Command1<Group, ({Group group, XFile? image})> create;
  late final Command1<void, String> join;

  List<Group> get groups => _groups.groups;

  Profile? get profile => _profile.profile;

  /// The profile has loaded, and the user hasn't told us their name yet.
  bool get needsName =>
      profile != null && (profile!.displayName?.trim().isEmpty ?? true);

  /// Ask for feedback once the user has been around for a few days.
  bool get showFeedbackCard =>
      !_settings.feedbackDismissed &&
      (profile?.createdAt?.isBefore(
            DateTime.now().subtract(const Duration(days: 3)),
          ) ??
          false);

  void dismissFeedback() => _settings.dismissFeedback();

  Future<Result<void>> _refresh() async {
    final results = await Future.wait([_groups.refresh(), _profile.load()]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  @override
  void dispose() {
    for (final repository in _repositories) {
      repository.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
