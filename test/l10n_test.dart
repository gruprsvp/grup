import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:rrule/rrule.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('recurrenceLabel', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final it = lookupAppLocalizations(const Locale('it'));

    test('names the rules the app creates, in the user language', () {
      expect(
        recurrenceLabel(en, CommonRecurrenceRules.weekdays),
        'On weekdays',
      );
      expect(recurrenceLabel(it, CommonRecurrenceRules.daily), 'Ogni giorno');
    });

    test('recognizes a rule read back from the database', () {
      final stored = RecurrenceRule.fromJson(
        CommonRecurrenceRules.weekends.toJson(),
      );

      expect(recurrenceLabel(en, stored), 'On weekends');
    });

    test('calls anything else custom', () {
      final rule = RecurrenceRule(frequency: Frequency.hourly);

      expect(recurrenceLabel(en, rule), 'Custom');
    });
  });

  testWidgets('dates follow the app language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(Brightness.light),
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: appSupportedLocales,
        locale: const Locale('de'),
        home: Scaffold(body: DateDropdown(date: DateTime(2024, 1, 2))),
      ),
    );

    expect(find.text('Dienstag, 2. Januar'), findsOneWidget);
  });
}
