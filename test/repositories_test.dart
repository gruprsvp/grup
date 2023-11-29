import 'dart:async';

import 'package:faker/faker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/util.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

final SupabaseConfig config = SupabaseConfig.fromPath('supabase_local.json');

SupabaseClient supabaseAnonClient() =>
    SupabaseClient(config.apiUrl, config.anonKey);

SupabaseClient supabaseAdminClient() =>
    SupabaseClient(config.apiUrl, config.serviceRoleKey);

/// Singleton instance of a Supabase client with admin rights
/// (it's not very useful to have many as there's no auth user)
final supabaseAdmin = supabaseAdminClient();

/// Create a new fake user in Supabase.
/// This replaces the current authenticated user in the provided [supabase].
Future<AuthResponse> signUpWithNewUser(SupabaseClient supabase) =>
    supabase.auth.signUp(password: 'password', email: faker.internet.email());

typedef RunWithUserCallback = FutureOr Function(
    SupabaseClient supabase, AuthResponse user);

/// Run a callback with a new fake user, and keep it for future reference.
Future<AuthResponse> runWithUser(RunWithUserCallback callback) async {
  final supabase = supabaseAnonClient();
  final user = await signUpWithNewUser(supabase);
  await callback(supabase, user);
  return user;
}

/// Run a closure with a temporary user created just for this and then deleted.
Future<void> runWithTemporaryUser(RunWithUserCallback callback) async {
  final user = await runWithUser(callback);
  await supabaseAdmin.auth.admin.deleteUser(user.user!.id);
}

void main() {
  group('repositories', () {
    test(
        'users should be able to sign up and delete their profile',
        () => runWithTemporaryUser(
              (supabase, user) => expect(user.user, isNotNull),
            ));

    test(
      'users should be able to get and update their profile',
      () => runWithTemporaryUser((supabase, user) async {
        final profilesRepository = ProfilesRepository(supabase: supabase);

        final id = user.user!.id;
        final profile = await profilesRepository.getProfileById(id);

        final displayName = faker.person.name();
        final pictureUrl = faker.image.image(height: 128, width: 128);

        await profilesRepository.updateProfile(
          id: id,
          displayName: displayName,
          pictureUrl: pictureUrl,
        );
        final updatedProfile = await profilesRepository.getProfileById(id);

        expect(
            updatedProfile,
            allOf([
              isNotNull,
              isNot(profile),
            ]));

        expect(updatedProfile.displayName, equals(displayName));
        expect(updatedProfile.picture, equals(pictureUrl));
      }),
    );

    test(
      'users should be able to create groups',
      () => runWithTemporaryUser(
        (supabase, user) async {
          final groupsRepository = GroupsRepository(supabase: supabase);

          final newGroup = await groupsRepository.createGroup(Group(
            displayName: faker.conference.name(),
            description: faker.lorem.sentences(3).join(' '),
            picture: faker.image.image(height: 128, width: 128),
            id: 0,
          ));

          expect(newGroup, isNotNull);

          // Another user should not see the group if they are not a member
          await runWithTemporaryUser((supabase, user) async {
            final secondUserGroupsRepository =
                GroupsRepository(supabase: supabase);
            try {
              final group =
                  await secondUserGroupsRepository.getGroupById(newGroup.id);
              fail("Should not be able to get group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }
          });
        },
      ),
    );
  });
}
