part of 'selectors.dart';

bool selectHasSeenFeedbackCard(AppState state) =>
    state.hasSeenFeedbackCard ?? false;

final selectShouldShowFeedbackCard = createSelector2(
  selectHasSeenFeedbackCard,
  selectOwnProfile,
  (hasSeenFeedbackCard, ownProfile) =>
      !hasSeenFeedbackCard &&
      ownProfile?.createdAt?.isBefore(
            DateTime.now().subtract(const Duration(days: 3)),
          ) ==
          true,
);
