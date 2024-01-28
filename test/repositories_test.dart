import 'dart:async';

import 'package:faker/faker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:test/test.dart';

final SupabaseConfig config =
    SupabaseConfig.fromPath('supabase/config/localhost.json');

const authOptions = AuthClientOptions(authFlowType: AuthFlowType.implicit);

SupabaseClient supabaseAnonClient() =>
    SupabaseClient(config.apiUrl, config.anonKey, authOptions: authOptions);

SupabaseClient supabaseAdminClient() =>
    SupabaseClient(config.apiUrl, config.serviceRoleKey!,
        authOptions: authOptions);

/// Singleton instance of a Supabase client with admin rights
/// (it's not very useful to have many as there's no auth user)
final supabaseAdmin = supabaseAdminClient();

/// Create a new fake user in Supabase.
/// This replaces the current authenticated user in the provided [supabase].
Future<AuthResponse> signUpWithNewUser(SupabaseClient supabase,
        {String? email, String? phone}) =>
    supabase.auth.signUp(
      password: 'password',
      email: phone == null ? email ?? faker.internet.email() : null,
      phone: phone,
    );

typedef RunWithUserCallback<T> = FutureOr<T> Function(
    SupabaseClient supabase, AuthResponse user);

typedef RunWithGroupCallback<T> = FutureOr<T> Function(
    SupabaseClient supabase, Group group, GroupsRepository groupsRepository);

/// Run a callback with a new fake user, and keep it for future reference.
Future<(AuthResponse, T)> runWithUser<T>(RunWithUserCallback<T> callback,
    {String? email, String? phone}) async {
  final supabase = supabaseAnonClient();
  final user = await signUpWithNewUser(supabase, email: email, phone: phone);
  final result = await callback(supabase, user);
  return (user, result);
}

/// Run a closure with a temporary user created just for this and then deleted.
Future<T> runWithTemporaryUser<T>(RunWithUserCallback<T> callback,
    {String? email, String? phone}) async {
  final (user, result) =
      await runWithUser(callback, email: email, phone: phone);
  await supabaseAdmin.auth.admin.deleteUser(user.user!.id);
  return result;
}

/// Run a closure with a temporary group created just for this and then deleted.
Future<T> runWithTemporaryGroup<T>(RunWithGroupCallback<T> callback) {
  return runWithTemporaryUser((supabase, user) async {
    final groupsRepository = GroupsRepository(supabase: supabase);
    final group = await groupsRepository.createGroup(Fake.group());
    final result = await callback(supabase, group, groupsRepository);
    await groupsRepository.deleteGroup(group.id);
    return result;
  });
}

void main() {
  group('profiles', () {
    test(
        'users should be able to sign up and delete their profile',
        () => runWithTemporaryUser(
            (supabase, user) => expect(user.user, isNotNull)));

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
  });

  group('groups', () {
    test(
      'all users should be able to create groups',
      () => runWithTemporaryUser(
        (supabase, user) => runWithTemporaryGroup((_, newGroup, __) async {
          expect(newGroup, isNotNull);

          // Another user should not see the group if they are not a member
          await runWithTemporaryUser((supabase, user) async {
            final secondUserGroupsRepository =
                GroupsRepository(supabase: supabase);
            try {
              await secondUserGroupsRepository.getGroupById(newGroup.id);
              fail("Should not be able to get group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }

            try {
              await secondUserGroupsRepository
                  .updateGroup(newGroup.copyWith(displayName: 'A new name'));
              fail("Should not be able to update group without being a member");
            } catch (e) {
              expect(e, isA<PostgrestException>());
            }

            try {
              await secondUserGroupsRepository.deleteGroup(newGroup.id);
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
        final groupsRepository = GroupsRepository(supabase: supabase);
        const groupsCount = 5;
        final createdGroups = List.generate(groupsCount, (_) => Fake.group());

        await Future.wait(
            createdGroups.map((g) => groupsRepository.createGroup(g)));

        final userGroups = await groupsRepository.getUserGroups();

        expect(userGroups, hasLength(groupsCount));

        // ? How to match just user-configured properties?
        // expect(userGroups, unorderedEquals(createdGroups));

        await Future.wait(
            userGroups.map((g) => groupsRepository.deleteGroup(g.id)));
      }),
    );

    test(
      'admins can edit their groups',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          const newName = 'A new group name';
          final updatedGroup = await groupsRepository
              .updateGroup(group.copyWith(displayName: newName));

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
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);

          await membersRepository.addMemberToGroup(group.id,
              displayName: 'A guest');

          await runWithTemporaryUser((_, user2) => membersRepository
              .addMemberToGroup(group.id, profileId: user2.user!.id));
        }),
      ),
    );

    test(
      'admins can manage group members',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);

          final guest = await membersRepository.addMemberToGroup(group.id,
              displayName: 'A guest');

          final updatedGuest = await membersRepository.updateMember(
              memberId: guest.id, displayNameOverride: 'A guest with a name');

          await membersRepository.removeMember(updatedGuest.id);
        }),
      ),
    );
  });

  group('invites', () {
    test(
      'an invited user becomes a member on sign up',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final invitesRepository = InvitesRepository(supabase: supabase);

          final member = await membersRepository.addMemberToGroup(group.id,
              displayName: 'Member invited with email');

          final invitedUserEmail = faker.internet.email();

          await invitesRepository.inviteMember(
              member.id, InviteMethods.email, invitedUserEmail);

          await runWithTemporaryUser(
            (supabase2, user2) async {
              final groupsRepository2 = GroupsRepository(supabase: supabase2);
              final userGroups = await groupsRepository2.getUserGroups();

              expect(userGroups, hasLength(1));

              final group2 = userGroups.first;
              expect(group2.id, equals(group.id));
              // TODO check that there are 2 members
              // TODO check user is member of group and display name override is reset
            },
            email: invitedUserEmail,
          );
        }),
      ),
    );

    test(
      'an user invited via phone becomes a member on sign up',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final invitesRepository = InvitesRepository(supabase: supabase);

          final member = await membersRepository.addMemberToGroup(group.id,
              displayName: 'Member invited with phone');

          // TODO convert numbers to E.164 format
          final invitedUserPhone =
              "+1${faker.randomGenerator.integer(999999999)}";

          await invitesRepository.inviteMember(
              member.id, InviteMethods.phone, invitedUserPhone);

          await runWithTemporaryUser(
            (supabase2, user2) async {
              final groupsRepository2 = GroupsRepository(supabase: supabase2);
              final userGroups = await groupsRepository2.getUserGroups();

              expect(userGroups, hasLength(1));
              expect(userGroups.first.id, equals(group.id));
            },
            phone: invitedUserPhone,
          );
        }),
      ),
    );

    test(
      'a user may be invited via code',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final invitesRepository = InvitesRepository(supabase: supabase);

          final member = await membersRepository.addMemberToGroup(group.id,
              displayName: 'Member invited with code');
          await invitesRepository.inviteMember(
              member.id, InviteMethods.code, 'CODE');

          await runWithTemporaryUser((supabase2, user2) async {
            final groupsRepository2 = GroupsRepository(supabase: supabase2);
            final invitesRepository2 = InvitesRepository(supabase: supabase2);

            final userGroups1 = await groupsRepository2.getUserGroups();
            expect(userGroups1, hasLength(0));

            await invitesRepository2.consumeInviteCode('CODE');

            // TODO check that the invite code was deleted by now

            final userGroups2 = await groupsRepository2.getUserGroups();
            expect(userGroups2, hasLength(1));
          });
        }),
      ),
    );
  });

  group('schedules', () {
    test(
      'admins can create schedules',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final schedulesRepository = SchedulesRepository(supabase: supabase);

          final schedule = await schedulesRepository.createSchedule(
            Schedule(
              id: 0,
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
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final schedulesRepository = SchedulesRepository(supabase: supabase);

          final recurrenceRules = [
            CommonRecurrenceRules.daily,
            CommonRecurrenceRules.weekly,
            CommonRecurrenceRules.monthly
          ];

          await Future.wait(recurrenceRules
              .map((r) => Schedule(
                  id: 0,
                  groupId: group.id,
                  displayName: r.toString(),
                  startDate: DateTime.now(),
                  recurrenceRule: r))
              .map((s) => schedulesRepository.createSchedule(s)));

          final schedules =
              await schedulesRepository.getGroupSchedules(group.id);
          expect(schedules, hasLength(recurrenceRules.length));

          await runWithTemporaryUser((supabase2, user2) async {
            await membersRepository.addMemberToGroup(group.id,
                profileId: user2.user!.id);
            final schedulesRepository2 =
                SchedulesRepository(supabase: supabase2);
            final schedules2 =
                await schedulesRepository2.getGroupSchedules(group.id);
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
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final schedulesRepository = SchedulesRepository(supabase: supabase);
          final defaultRepliesRepository =
              DefaultRepliesRepository(supabase: supabase);

          final member = await membersRepository.addMemberToGroup(group.id,
              displayName: 'Member invited with code');

          final startDate = DateTime.now().toUtc();
          final recurrenceRule = RecurrenceRule(
            frequency: Frequency.daily,
            interval: 1,
          );

          final schedule = await schedulesRepository.createSchedule(
            Schedule(
              id: 0,
              groupId: group.id,
              displayName: 'A schedule',
              startDate: startDate,
              recurrenceRule: recurrenceRule,
            ),
          );

          final defaultReply =
              await defaultRepliesRepository.createDefaultReply(
            DefaultReply(
              scheduleId: schedule.id,
              memberId: member.id,
              selectedOption: ReplyOptions.yes,
              recurrenceRule: recurrenceRule,
            ),
          );

          final list =
              await defaultRepliesRepository.getDefaultReplies(group.id);
          expect(list, hasLength(1));

          final schedules =
              await schedulesRepository.getGroupSchedules(group.id);
          // TODO
          // expect(schedules.single.defaultReplies?.single, equals(defaultReply));
        }),
      ),
    );
  });

  group('replies', () {
    test(
      'users can create replies and get them per day',
      () => runWithTemporaryUser(
        (supabase, user) =>
            runWithTemporaryGroup((supabase, group, groupsRepository) async {
          final membersRepository = MembersRepository(supabase: supabase);
          final schedulesRepository = SchedulesRepository(supabase: supabase);
          final repliesRepository = RepliesRepository(supabase: supabase);

          final member = await membersRepository.addMemberToGroup(group.id,
              displayName: 'Member invited with code');

          final startDate = DateTime.now().toUtc();
          final recurrenceRule = RecurrenceRule(
            frequency: Frequency.daily,
            interval: 1,
          );

          final schedule = await schedulesRepository.createSchedule(
            Schedule(
              id: 0,
              groupId: group.id,
              displayName: 'A schedule',
              startDate: startDate,
              recurrenceRule: recurrenceRule,
            ),
          );

          await Future.wait(
            recurrenceRule.getInstances(start: startDate).take(5).map(
                  (s) => repliesRepository.createReply(
                    Reply(
                      scheduleId: schedule.id,
                      memberId: member.id,
                      eventDate: s,
                      selectedOption: ReplyOptions.yes,
                    ),
                  ),
                ),
          );

          final replies = await repliesRepository.getRepliesForDay(
            group.id,
            startDate.add(const Duration(days: 1)),
          );
          expect(replies, hasLength(1));
        }),
      ),
    );
  });
}
