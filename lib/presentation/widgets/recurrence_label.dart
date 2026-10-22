import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:rrule/rrule.dart';

/// Names [rule] in the user's language.
///
/// The app only creates the [CommonRecurrenceRules], so those get proper
/// names; anything else (made outside the app) is "Custom". rrule's own
/// text encoder only speaks English.
String recurrenceLabel(AppLocalizations l10n, RecurrenceRule rule) =>
    switch (rule) {
      _ when rule == CommonRecurrenceRules.once => l10n.recurrenceOnce,
      _ when rule == CommonRecurrenceRules.daily => l10n.recurrenceDaily,
      _ when rule == CommonRecurrenceRules.weekly => l10n.recurrenceWeekly,
      _ when rule == CommonRecurrenceRules.monthly => l10n.recurrenceMonthly,
      _ when rule == CommonRecurrenceRules.yearly => l10n.recurrenceYearly,
      _ when rule == CommonRecurrenceRules.weekdays => l10n.recurrenceWeekdays,
      _ when rule == CommonRecurrenceRules.weekends => l10n.recurrenceWeekends,
      _ => l10n.recurrenceCustom,
    };
