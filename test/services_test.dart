@Tags(['live'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:faker/faker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/const.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_data.dart';

final SupabaseConfig config = SupabaseConfig.fromPath(
  'supabase/config/localhost.json',
);

const authOptions = AuthClientOptions(authFlowType: AuthFlowType.implicit);

SupabaseClient supabaseAnonClient() => SupabaseClient(
  config.apiUrl,
  config.publishableKey,
  authOptions: authOptions,
);

SupabaseClient supabaseAdminClient() => SupabaseClient(
  config.apiUrl,
  config.serviceRoleKey!,
  authOptions: authOptions,
);

/// Singleton instance of a Supabase client with admin rights
/// (it's not very useful to have many as there's no auth user)
final supabaseAdmin = supabaseAdminClient();

/// Create a new fake user in Supabase.
/// This replaces the current authenticated user in the provided [supabase].
Future<AuthResponse> signUpWithNewUser(
  SupabaseClient supabase, {
  String? email,
  String? phone,
}) => supabase.auth.signUp(
  password: 'password',
  email: phone == null ? email ?? faker.internet.email() : null,
  phone: phone,
);

typedef RunWithUserCallback<T> = FutureOr<T> Function(
  SupabaseClient supabase,
  AuthResponse user,
);

typedef RunWithGroupCallback<T> = FutureOr<T> Function(
  SupabaseClient supabase,
  Group group,
  GroupsService groupsService,
);

/// Run a callback with a new fake user, and keep it for future reference.
Future<(AuthResponse, T)> runWithUser<T>(
  RunWithUserCallback<T> callback, {
  String? email,
  String? phone,
}) async {
  final supabase = supabaseAnonClient();
  final user = await signUpWithNewUser(supabase, email: email, phone: phone);
  try {
    final result = await callback(supabase, user);
    return (user, result);
  } catch (e) {
    await supabaseAdmin.auth.admin.deleteUser(user.user!.id);
    rethrow;
  }
}

/// Run a closure with a temporary user created just for this and then deleted.
Future<T?> runWithTemporaryUser<T>(
  RunWithUserCallback<T> callback, {
  String? email,
  String? phone,
}) async {
  try {
    final (user, result) = await runWithUser(
      callback,
      email: email,
      phone: phone,
    );
    await supabaseAdmin.auth.admin.deleteUser(user.user!.id);
    return result;
  } catch (e) {
    rethrow;
  }
}

/// Run a closure with a temporary group created just for this and then deleted.
Future<T?> runWithTemporaryGroup<T>(RunWithGroupCallback<T> callback) {
  return runWithTemporaryUser((supabase, user) async {
    final groupsService = GroupsService(supabase: supabase);
    final group = await groupsService.createGroup(FakeData.group());
    late T result;
    try {
      result = await callback(supabase, group, groupsService);
      await groupsService.deleteGroup(group.id);
      return result;
    } catch (e) {
      await groupsService.deleteGroup(group.id);
      rethrow;
    }
  });
}

void main() {
  // These tests run against a live local Supabase. Skip cleanly (instead of
  // erroring) when it isn't configured, so a plain `flutter test` works without
  // Docker. To run them: `supabase start` then
  // `supabase status -o json > supabase/config/localhost.json` — or target them
  // explicitly with `flutter test --tags live` (and exclude with `--exclude-tags live`).
  if (!File('supabase/config/localhost.json').existsSync()) {
    test(
      'service (live Supabase) tests skipped',
      () {},
      skip: 'No supabase/config/localhost.json — run `supabase start` first.',
    );
    return;
  }

  group('profiles', () {
    test('users should be able to sign up and delete their profile', () async {
      // Through the delete_user_account edge function, with the secret key.
      final (user, _) = await runWithUser(
        (supabase, _) => ProfilesService(supabase: supabase).deleteProfile(),
      );
      await expectLater(
        supabaseAdmin.auth.admin.getUserById(user.user!.id),
        throwsA(isA<AuthException>()),
      );
    });

    test(
      'users should be able to get and update their profile',
      () => runWithTemporaryUser((supabase, user) async {
        final profilesService = ProfilesService(supabase: supabase);

        final id = user.user!.id;
        final profile = await profilesService.getProfileById(id);

        final displayName = faker.person.name();
        final pictureUrl = faker.image.loremPicsum(height: 128, width: 128);

        await profilesService.updateProfile(
          id: id,
          displayName: displayName,
          pictureUrl: pictureUrl,
        );
        final updatedProfile = await profilesService.getProfileById(id);

        expect(updatedProfile, allOf([isNotNull, isNot(profile)]));

        expect(updatedProfile.displayName, equals(displayName));
        expect(updatedProfile.picture, equals(pictureUrl));
      }),
    );
  });

  group('storage', () {
    test(
      'deletePublicUrl deletes a replaced picture but not a group\'s',
      () => runWithTemporaryGroup((supabase, group, groupsService) async {
        final storage = StorageService(supabase: supabase);
        final image = XFile.fromData(
          Uint8List.fromList([1, 2, 3]),
          mimeType: 'image/png',
        );
        final replaced = await storage.uploadPublicXFile('replaced', image);
        final shown = await storage.uploadPublicXFile('shown', image);
        await groupsService.updateGroup(group.copyWith(picture: shown));

        await storage.deletePublicUrl(replaced);
        await storage.deletePublicUrl(shown);
        await storage.deletePublicUrl('https://lh3.googleusercontent.com/a');

        final files = await supabase.storage
            .from(Buckets.public.name)
            .list(path: supabase.auth.currentUser!.id);
        expect(files.map((f) => f.name), ['shown.png']);
        await groupsService.updateGroup(group.copyWith(picture: null));
        await storage.deleteUserFiles();
      }),
    );
  });

  group('groups', () {
    test(
      'all users should be able to create groups',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((_, newGroup, _) async {
          expect(newGroup, isNotNull);

          // Another user should not see the group if they are not a member
          await runWithTemporaryUser((supabase, user) async {
            final secondUserGroupsService = GroupsService(supabase: supabase);
            try {
              await secondUserGroupsService.getGroupById(newGroup.id);
              fail("Should not be able to get group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }

            try {
              await secondUserGroupsService.updateGroup(
                newGroup.copyWith(displayName: 'A new name'),
              );
              fail("Should not be able to update group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }

            try {
              await secondUserGroupsService.deleteGroup(newGroup.id);
              fail("Should not be able to delete group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }
          });
        }),
      ),
    );

    test(
      'admins should be able to see all the groups they created',
      () => runWithTemporaryUser((supabase, user) async {
        final groupsService = GroupsService(supabase: supabase);
        const groupsCount = 5;
        final createdGroups = List.generate(
          groupsCount,
          (_) => FakeData.group(),
        );

        await Future.wait(
          createdGroups.map((g) => groupsService.createGroup(g)),
        );

        final userGroups = await groupsService.getUserGroups();

        expect(userGroups.groups, hasLength(groupsCount));

        // ? How to match just user-configured properties?
        // expect(userGroups, unorderedEquals(createdGroups));

        await Future.wait(
          userGroups.groups.map((g) => groupsService.deleteGroup(g.id)),
        );
      }),
    );

    test(
      'admins can edit their groups',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              const newName = 'A new group name';
              final updatedGroup = await groupsService.updateGroup(
                group.copyWith(displayName: newName),
              );

              expect(updatedGroup.displayName, equals(newName));
            }),
      ),
    );
  });

  group('members', () {
    test(
      'admins can add guests to groups',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);

              await membersService.addMemberToGroup(
                group.id,
                displayName: 'A guest',
              );

              await runWithTemporaryUser(
                (_, user2) => membersService.addMemberToGroup(
                  group.id,
                  profileId: user2.user!.id,
                ),
              );
            }),
      ),
    );

    test(
      'admins can manage group members',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);

              final guest = await membersService.addMemberToGroup(
                group.id,
                displayName: 'A guest',
              );

              final updatedGuest = await membersService.updateMember(
                memberId: guest.id,
                displayNameOverride: 'A guest with a name',
              );

              await membersService.deleteMember(updatedGuest.id);
            }),
      ),
    );

    test(
      'an empty override clears it, except on a guest',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);
              final own = await membersService.getOwnMemberByGroupId(group.id);

              await membersService.updateMember(
                memberId: own.id,
                displayNameOverride: 'Nickname',
              );
              final cleared = await membersService.updateMember(
                memberId: own.id,
                displayNameOverride: '',
              );
              expect(cleared.displayNameOverride, isNull);

              // A guest has no profile, so the override is their only name.
              final guest = await membersService.addMemberToGroup(
                group.id,
                displayName: 'A guest',
              );
              await expectLater(
                membersService.updateMember(
                  memberId: guest.id,
                  displayNameOverride: '',
                ),
                throwsA(isA<PostgrestException>()),
              );
            }),
      ),
    );

    test(
      'users can see their groups and members',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);

              final member = await membersService.addMemberToGroup(
                group.id,
                displayName: 'A member',
              );

              final userGroups = await groupsService.getUserGroups();
              expect(userGroups.groups, hasLength(1));

              final userGroup = userGroups.groups.first;
              final members = userGroups.members.where(
                (m) => m.groupId == userGroup.id,
              );

              expect(userGroup.id, equals(group.id));
              expect(members, hasLength(2));

              final userMember = members.where((m) => m.id == member.id).first;
              expect(userMember.id, equals(member.id));
            }),
      ),
    );

    test(
      'admins can make other members admins',
      () => runWithTemporaryUser((supabase, user) async {
        final groupsService = GroupsService(supabase: supabase);
        final membersService = MembersService(supabase: supabase);

        final group = await groupsService.createGroup(FakeData.group());
        final member = await membersService.addMemberToGroup(
          group.id,
          displayName: 'Member',
        );

        final updatedMember = await membersService.updateMember(
          memberId: member.id,
          role: GroupRoles.admin,
        );

        expect(updatedMember.role, equals(GroupRoles.admin));
      }),
    );

    test(
      'members cannot make themselves admins',
      () => runWithTemporaryUser((supabase, user) async {
        final groupsService = GroupsService(supabase: supabase);
        final membersService = MembersService(supabase: supabase);

        final group = await groupsService.createGroup(FakeData.group());

        await runWithTemporaryUser((supabase2, user2) async {
          final membersService2 = MembersService(supabase: supabase2);

          final member = await membersService.addMemberToGroup(
            group.id,
            profileId: user2.user!.id,
          );

          try {
            await membersService2.updateMember(
              memberId: member.id,
              role: GroupRoles.admin,
            );
            fail("Should not be able to make themselves admins");
          } catch (e) {
            expect(e, isA<PostgrestException>());
          }
        });
      }),
    );

    // Fix for https://github.com/appforit/appforit/issues/112 - throws:
    // PostgrestException(message: more than one row returned by a subquery used as an expression, code: 21000, details: Internal Server Error, hint: null)
    test(
      'members can see other members profiles across multiple groups',
      () => runWithTemporaryGroup((supabase, group1, groupsService) async {
        final membersService = MembersService(supabase: supabase);
        final group2 = await groupsService.createGroup(FakeData.group());

        await runWithTemporaryUser((supabase2, user2) async {
          await membersService.addMemberToGroup(
            group1.id,
            profileId: user2.user!.id,
          );
          await membersService.addMemberToGroup(
            group2.id,
            profileId: user2.user!.id,
          );

          final groups = await groupsService.getUserGroups();
          expect(groups.groups, hasLength(2));
          expect(groups.members, hasLength(4));
          expect(groups.profiles, hasLength(2));
        });
        await groupsService.deleteGroup(group2.id);
      }),
    );
  });

  group('invites', () {
    test(
      'an invited user becomes a member on sign up',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);
              final invitesService = InvitesService(supabase: supabase);

              final member = await membersService.addMemberToGroup(
                group.id,
                displayName: 'Member invited with email',
              );

              final invitedUserEmail = faker.internet.email();

              await invitesService.inviteMember(
                member.id,
                InviteMethods.email,
                invitedUserEmail,
              );

              await runWithTemporaryUser((supabase2, user2) async {
                final groupsService2 = GroupsService(supabase: supabase2);
                final userGroups = await groupsService2.getUserGroups();

                expect(userGroups.groups, hasLength(1));

                final group2 = userGroups.groups.first;
                expect(group2.id, equals(group.id));
                // TODO check that there are 2 members
                // TODO check user is member of group and display name override is reset
              }, email: invitedUserEmail);
            }),
      ),
    );

    test(
      'an user invited via phone becomes a member on sign up',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((
          supabase,
          group,
          groupsService,
        ) async {
          final membersService = MembersService(supabase: supabase);
          final invitesService = InvitesService(supabase: supabase);

          final member = await membersService.addMemberToGroup(
            group.id,
            displayName: 'Member invited with phone',
          );

          // Canonical invite format: E.164 with the leading '+'
          // (auth.users.phone stores the digits without it).
          final invitedUserPhone =
              "+1${faker.randomGenerator.integer(999999999, min: 100000000)}";

          await invitesService.inviteMember(
            member.id,
            InviteMethods.phone,
            invitedUserPhone,
          );

          await runWithTemporaryUser((supabase2, user2) async {
            final groupsService2 = GroupsService(supabase: supabase2);
            final userGroups = await groupsService2.getUserGroups();

            expect(userGroups.groups, hasLength(1));
            expect(userGroups.groups.first.id, equals(group.id));
          }, phone: invitedUserPhone);
        }),
      ),
    );

    test(
      'a user may be invited via code',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((
          supabase,
          group,
          groupsService,
        ) async {
          final membersService = MembersService(supabase: supabase);
          final invitesService = InvitesService(supabase: supabase);

          final member = await membersService.addMemberToGroup(
            group.id,
            displayName: 'Member invited with code',
          );
          final invite = await invitesService.inviteWithGeneratedCode(
            member.id,
          );
          final testCode = invite.value;

          await runWithTemporaryUser((supabase2, user2) async {
            final groupsService2 = GroupsService(supabase: supabase2);
            final invitesService2 = InvitesService(supabase: supabase2);

            final userGroups1 = await groupsService2.getUserGroups();
            expect(userGroups1.groups, hasLength(0));

            final memberId = await invitesService2.checkInviteCode(testCode);
            expect(memberId, member.id);

            await invitesService2.consumeInviteCode(testCode);

            // check that the invite code was deleted by now
            try {
              await invitesService2.checkInviteCode(testCode);
              fail("Should not be able to use the same invite code twice");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }

            final userGroups2 = await groupsService2.getUserGroups();
            expect(userGroups2.groups, hasLength(1));
          });
        }),
      ),
    );

    test(
      'an already existing user can be added directly',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);
              final invitesService = InvitesService(supabase: supabase);

              await runWithTemporaryUser((supabase2, user2) async {
                final member = await membersService.addMemberToGroup(
                  group.id,
                  displayName: 'Member invited with email',
                );
                await invitesService.inviteMember(
                  member.id,
                  InviteMethods.email,
                  user2.user!.email!,
                );

                final groupsService2 = GroupsService(supabase: supabase2);
                final userGroups = await groupsService2.getUserGroups();

                expect(userGroups.groups, hasLength(1));
                expect(userGroups.groups.first.id, equals(group.id));
              });
            }),
      ),
    );

    test(
      'an admin can see all invites for a user',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((
          supabase,
          group,
          groupsService,
        ) async {
          final membersService = MembersService(supabase: supabase);
          final invitesService = InvitesService(supabase: supabase);

          final member = await membersService.addMemberToGroup(
            group.id,
            displayName: 'Member invited with email',
          );
          await invitesService.inviteMember(
            member.id,
            InviteMethods.email,
            'user@example.com',
          );

          final invites = await invitesService.getInvitesForMember(member.id);
          expect(invites, hasLength(1));
        }),
      ),
    );
  });

  group('schedules', () {
    test(
      'admins can create schedules',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final schedulesService = SchedulesService(supabase: supabase);

              final schedule = await schedulesService.createSchedule(
                Schedule(
                  id: '',
                  groupId: group.id,
                  displayName: 'A schedule',
                  startDate: DateTime.now(),
                  recurrenceRule: RecurrenceRule(
                    frequency: Frequency.daily,
                    interval: 1,
                  ),
                ),
              );

              expect(schedule, isNotNull);
            }),
      ),
    );

    test(
      'group members can get all schedules for a group',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((
          supabase,
          group,
          groupsService,
        ) async {
          final membersService = MembersService(supabase: supabase);
          final schedulesService = SchedulesService(supabase: supabase);

          final recurrenceRules = [
            CommonRecurrenceRules.daily,
            CommonRecurrenceRules.weekly,
            CommonRecurrenceRules.monthly,
          ];

          await Future.wait(
            recurrenceRules
                .map(
                  (r) => Schedule(
                    id: '',
                    groupId: group.id,
                    displayName: r.toString(),
                    startDate: DateTime.now(),
                    recurrenceRule: r,
                  ),
                )
                .map((s) => schedulesService.createSchedule(s)),
          );

          final schedules = await schedulesService.getGroupSchedules(group.id);
          expect(schedules, hasLength(recurrenceRules.length));

          await runWithTemporaryUser((supabase2, user2) async {
            await membersService.addMemberToGroup(
              group.id,
              profileId: user2.user!.id,
            );
            final schedulesService2 = SchedulesService(supabase: supabase2);
            final schedules2 = await schedulesService2.getGroupSchedules(
              group.id,
            );
            expect(schedules2, equals(schedules));
          });
        }),
      ),
    );
  });

  group('default replies', () {
    test(
      'user can create default replies and get them',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((
          supabase,
          group,
          groupsService,
        ) async {
          final membersService = MembersService(supabase: supabase);
          final schedulesService = SchedulesService(supabase: supabase);
          final defaultRulesService = DefaultRulesService(supabase: supabase);

          final member = await membersService.addMemberToGroup(
            group.id,
            displayName: 'Member invited with code',
          );

          final startDate = DateTime.now().toUtc();
          final recurrenceRule = RecurrenceRule(
            frequency: Frequency.daily,
            interval: 1,
          );

          final schedule = await schedulesService.createSchedule(
            Schedule(
              id: '',
              groupId: group.id,
              displayName: 'A schedule',
              startDate: startDate,
              recurrenceRule: recurrenceRule,
            ),
          );

          await defaultRulesService.createDefaultRule(
            DefaultRule(
              scheduleId: schedule.id,
              memberId: member.id,
              selectedOption: ReplyOptions.yes,
              recurrenceRule: recurrenceRule,
            ),
          );

          final list = await defaultRulesService.getDefaultRules(group.id);
          expect(list, hasLength(1));

          await schedulesService.getGroupSchedules(group.id);
          // TODO
          // expect(schedules.single.defaultRules?.single, equals(defaultRule));
        }),
      ),
    );
  });

  group('replies', () {
    test(
      'users can create replies and get them per day',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsService) async {
              final membersService = MembersService(supabase: supabase);
              final schedulesService = SchedulesService(supabase: supabase);
              final repliesService = RepliesService(supabase: supabase);

              final member = await membersService.addMemberToGroup(
                group.id,
                displayName: 'Member invited with code',
              );

              final startDate = DateTime.now().toUtc();
              final recurrenceRule = RecurrenceRule(
                frequency: Frequency.daily,
                interval: 1,
              );

              final schedule = await schedulesService.createSchedule(
                Schedule(
                  id: '',
                  groupId: group.id,
                  displayName: 'A schedule',
                  startDate: startDate,
                  recurrenceRule: recurrenceRule,
                ),
              );

              await Future.wait(
                recurrenceRule
                    .getInstances(start: startDate)
                    .take(5)
                    .map(
                      (s) => repliesService.createReply(
                        Reply(
                          scheduleId: schedule.id,
                          memberId: member.id,
                          instanceDate: s,
                          selectedOption: ReplyOptions.yes,
                        ),
                      ),
                    ),
              );

              final replies = await repliesService.getRepliesForDateRange(
                group.id,
                startDate.add(const Duration(days: 1)).toUtc().getDayRange(),
              );
              expect(replies, hasLength(1));
            }),
      ),
    );
  });

  group('failures are explicit', () {
    Future<Schedule> createSchedule(SupabaseClient supabase, Group group) =>
        SchedulesService(supabase: supabase).createSchedule(
          Schedule(
            id: '',
            groupId: group.id,
            displayName: 'A schedule',
            startDate: DateTime.utc(2024, 1, 1, 18),
            recurrenceRule: RecurrenceRule(frequency: Frequency.daily),
          ),
        );

    Matcher throwsNotFound() => throwsA(
      isA<PostgrestException>().having((e) => e.code, 'code', 'PGRST116'),
    );

    test(
      'getGroupById returns the group with its members and profiles',
      () => runWithTemporaryGroup((supabase, group, groupsService) async {
        final result = await groupsService.getGroupById(group.id);
        expect(result.groups.single.id, group.id);
        // create_group made the creator its admin.
        expect(result.members.single.role, GroupRoles.admin);
        expect(result.profiles.single.id, supabase.auth.currentUser!.id);
      }),
    );

    test(
      'deleting a schedule that is already gone fails',
      () => runWithTemporaryGroup((supabase, group, _) async {
        final schedulesService = SchedulesService(supabase: supabase);
        final schedule = await createSchedule(supabase, group);

        await schedulesService.deleteSchedule(schedule.id);
        await expectLater(
          schedulesService.deleteSchedule(schedule.id),
          throwsNotFound(),
        );
      }),
    );

    test(
      'deleting a schedule row-level security hides fails',
      () => runWithTemporaryGroup((supabase, group, _) async {
        final schedule = await createSchedule(supabase, group);

        await runWithTemporaryUser((outsider, _) async {
          await expectLater(
            SchedulesService(supabase: outsider).deleteSchedule(schedule.id),
            throwsNotFound(),
          );
        });

        // Still there for the admin.
        final schedules = await SchedulesService(supabase: supabase)
            .getGroupSchedules(group.id);
        expect(schedules.single.id, schedule.id);
      }),
    );

    test(
      'removing a member that is already gone fails',
      () => runWithTemporaryGroup((supabase, group, _) async {
        final membersService = MembersService(supabase: supabase);
        final guest = await membersService.addMemberToGroup(
          group.id,
          displayName: 'Guest',
        );

        await membersService.deleteMember(guest.id);
        await expectLater(
          membersService.deleteMember(guest.id),
          throwsNotFound(),
        );
      }),
    );

    test(
      'changing a reply updates it in place (upsert on conflict)',
      () => runWithTemporaryGroup((supabase, group, groupsService) async {
        final repliesService = RepliesService(supabase: supabase);
        final schedule = await createSchedule(supabase, group);
        final own = (await groupsService.getGroupById(group.id)).members.single;
        final instanceDate = DateTime.utc(2024, 1, 2, 18);

        Reply reply(ReplyOptions option) => Reply(
          memberId: own.id,
          scheduleId: schedule.id,
          instanceDate: instanceDate,
          selectedOption: option,
        );
        await repliesService.createReply(reply(ReplyOptions.yes));
        await repliesService.createReply(reply(ReplyOptions.no));

        final replies = await repliesService.getRepliesForDateRange(
          group.id,
          instanceDate.getDayRange(),
        );
        expect(replies.single.selectedOption, ReplyOptions.no);

        await repliesService.deleteReply(
          memberId: own.id,
          scheduleId: schedule.id,
          instanceDate: instanceDate,
        );
        await expectLater(
          repliesService.deleteReply(
            memberId: own.id,
            scheduleId: schedule.id,
            instanceDate: instanceDate,
          ),
          throwsNotFound(),
        );
      }),
    );

    test(
      'an unknown invite code fails with InvalidInviteCodeException',
      () => runWithTemporaryUser((supabase, _) async {
        await expectLater(
          InvitesService(supabase: supabase).consumeInviteCode('ZZZZ-ZZZZ'),
          throwsA(isA<InvalidInviteCodeException>()),
        );
      }),
    );

    test(
      'a code for a group the user is already in fails with '
      'AlreadyMemberException',
      () => runWithTemporaryGroup((supabase, group, _) async {
        final membersService = MembersService(supabase: supabase);
        final invitesService = InvitesService(supabase: supabase);
        final slot = await membersService.addMemberToGroup(
          group.id,
          displayName: 'Another slot',
        );
        final invite = await invitesService.inviteWithGeneratedCode(slot.id);

        // The admin is already a member of the group the code is for.
        await expectLater(
          invitesService.consumeInviteCode(invite.value),
          throwsA(isA<AlreadyMemberException>()),
        );
      }),
    );
  });

  // Paid plans (docs/billing-and-entitlements.md). Local Supabase stays in
  // the mode the migrations leave, unlocked; the other modes, seat caps and
  // the SQL itself are covered by pgTAP (supabase/tests/billing_test.sql).
  group('billing', () {
    test(
      'billing_state decodes, and names only features the app knows',
      () => runWithTemporaryGroup((supabase, group, _) async {
        final state = await BillingService(supabase: supabase)
            .getBillingState();

        const features = {
          FeatureKey.kitchenView,
          FeatureKey.replyCutoffs,
          FeatureKey.exportCsv,
        };
        expect(state.mode, BillingMode.unlocked);
        expect(state.groups[group.id]?.features.toSet(), features);
        expect(state.groups[group.id]?.limits, isEmpty);
        expect(state.groups[group.id]?.seats, 1);
        expect(state.catalog.map((plan) => plan.plan), [
          'community_s',
          'community_m',
          'community_l',
        ]);
        for (final plan in state.catalog) {
          expect(features, containsAll(plan.features));
          expect(plan.limits.keys, everyElement(LimitKey.maxSeats));
          expect(
            plan.prices.map((price) => (price.provider, price.interval)),
            unorderedEquals([('stripe', 'month'), ('stripe', 'year')]),
          );
        }
      }),
    );
  });
}
