import 'dart:core';

import 'package:collection/collection.dart';
import 'package:material_ui/material_ui.dart';
import 'package:memoized/memoized.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:reselect/reselect.dart';
import 'package:rrule/rrule.dart';
import 'package:supabase/supabase.dart';

part 'auth.dart';
part 'default_rules.dart';
part 'feedback.dart';
part 'groups.dart';
part 'locale.dart';
part 'members.dart';
part 'profiles.dart';
part 'replies.dart';
part 'schedules.dart';
part 'selected_date.dart';
part 'theme.dart';

// TODO Where to group these view model selectors?

final selectSchedules = createSelector3(
  selectScheduleEntities,
  selectGroupId,
  selectedDateRangeSelector,
  (schedules, groupId, range) => schedules.where(
    (s) =>
        s.groupId.toString() == groupId &&
        (s.startDate.isBefore(range.start) ||
            (s.startDate.compareTo(range.start) >= 0 &&
                s.startDate.compareTo(range.end) <= 0)),
  ),
);

final selectDefaultRules = createSelector2(
  selectAllDefaultRules,
  selectSchedulesIds,
  (replies, scheduleIds) =>
      replies.where((r) => scheduleIds.contains(r.scheduleId)),
);

final selectReplies = createSelector3(
  selectAllReplies,
  selectSchedulesIds,
  selectedDateRangeSelector,
  (replies, scheduleIds, range) => replies.where(
    (r) => scheduleIds.contains(r.scheduleId) && range.contains(r.instanceDate),
  ),
);

// TODO This selector and selectScheduleInstanceForDate are very similar,
// however, this one is used in the list view and the other in the detail view.
// This one is simpler because it doesn't need to group the members by their reply,
// however, by doing so, there is a mismatch as some replies may still be counted,
// even if a member is no longer part of the group.
final selectScheduleInstancesForSelectedDate = createSelector6(
  selectedDateRangeSelector,
  selectMyMember,
  selectSchedules,
  selectDefaultRules,
  selectReplies,
  groupMembersSelector,
  (range, myMember, schedules, defaultRules, replies, members) =>
      schedules.expand(
        (schedule) => getScheduleInstances(
          schedule: schedule,
          defaultRules: defaultRules,
          startDate: range.start,
          endDate: range.end,
          replies: replies,
          members: members,
          targetMemberId: myMember?.$1.id,
        ),
      ),
);

String? selectScheduleId(AppState state) => state.selectedScheduleId;

final selectScheduleInstanceSummary = createSelector2(
  selectScheduleInstancesForSelectedDate,
  selectScheduleId,
  (instances, id) =>
      instances.firstWhereOrNull((s) => s.scheduleId.toString() == id),
);

final getMember = Memoized2((Member member, Map<String, Profile> profiles) {
  final profile = profiles[member.profileId.toString()];

  return member.copyWith(
    displayNameOverride: member.displayNameOverride ?? profile?.displayName,
  );
});

Map<String, Profile> selectAllProfiles(AppState state) =>
    state.profiles.entities;

final selectScheduleInstanceForDate = createSelector3(
  selectScheduleInstanceSummary,
  groupMembersWithProfilesSelector,
  selectIsAdmin,
  (instance, members, canEditOthers) => instance == null
      ? null
      : scheduleInstanceDetails(
          instance,
          members,
          canEditOthers: canEditOthers,
        ),
);
