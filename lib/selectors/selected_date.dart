part of 'selectors.dart';

DateTime selectedDateSelector(AppState state) => state.selectedDate;

/// Provide the begin and end of day for the selected date.
final selectedDateRangeSelector =
    createSelector1(selectedDateSelector, (date) => date.getDayRange());
