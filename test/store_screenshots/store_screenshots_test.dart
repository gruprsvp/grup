@Tags(['screenshots'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/app.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/recurrence_rules.dart';

// Store-screenshot harness: renders real screens with staged demo data at
// store resolutions and captures one PNG per screen × locale × device profile.
// Raw captures land in test/store_screenshots/raw/; compositing them into
// framed, captioned store images is a separate step (see docs/STORE_SCREENSHOTS.md).
//
// Generate with:
//   STORE_SCREENSHOTS=true flutter test --tags screenshots --update-goldens
//
// Gated behind the env var so a plain `flutter test` (CI) never runs or
// compares these goldens.

/// [padding] is the system UI the app must avoid (status bar / Dynamic
/// Island on top, home indicator or nav bar below), in logical pixels.
typedef _Profile = ({
  Size logical,
  double dpr,
  TargetPlatform platform,
  EdgeInsets padding,
});

// Only the largest size of each store's device classes: both stores scale
// it down for the smaller ones.
const _ios = TargetPlatform.iOS;
const _android = TargetPlatform.android;
const _iPhonePadding = EdgeInsets.only(top: 62, bottom: 34);
const _iPadPadding = EdgeInsets.only(top: 24, bottom: 20);
const _androidPadding = EdgeInsets.only(top: 24, bottom: 24);
const _profiles = <String, _Profile>{
  // 1320×2868: iPhone 6.9" (Dynamic Island, large)
  'ios-iphone-6.9': (
    logical: Size(440, 956),
    dpr: 3,
    platform: _ios,
    padding: _iPhonePadding,
  ),
  // 1206×2622: iPhone 6.3" (Dynamic Island, medium; ASC lists it as required)
  'ios-iphone-6.3': (
    logical: Size(402, 874),
    dpr: 3,
    platform: _ios,
    padding: _iPhonePadding,
  ),
  // 2064×2752: iPad 13", required because the app runs on iPad
  'ios-ipad-13': (
    logical: Size(1032, 1376),
    dpr: 2,
    platform: _ios,
    padding: _iPadPadding,
  ),
  // 1440×2560 (9:16): Play phone, ≥1080 px so it qualifies for featuring
  'android-phone': (
    logical: Size(360, 640),
    dpr: 4,
    platform: _android,
    padding: _androidPadding,
  ),
  // Play tablets must be exactly 16:9 (or 9:16), landscape like a tablet
  // 2048×1152: 7" tablet
  'android-tablet-7': (
    logical: Size(1024, 576),
    dpr: 2,
    platform: _android,
    padding: _androidPadding,
  ),
  // 2560×1440: 10" tablet
  'android-tablet-10': (
    logical: Size(1280, 720),
    dpr: 2,
    platform: _android,
    padding: _androidPadding,
  ),
};

// Demo data: fixed dates so captures don't drift, no emoji (the test can't
// render colour emoji). Names and captions are per language; the app's own
// strings come from l10n.
typedef _Demo = ({
  List<(String, String?)> groups, // name, description; the 2nd is football
  String match,
  String pizza,
  List<String> captions, // one per screen, in `screens` order
});

const _demo = <String, _Demo>{
  'en': (
    groups: [
      ('Family', 'Sunday lunches'),
      ('Saturday Football', 'Five-a-side, every week'),
      ('Book Club', 'One book a month'),
      ('D&D Night', null),
      ('Choir', 'Thursdays, 8pm'),
    ],
    match: 'Five-a-side',
    pizza: 'Pizza after the match',
    captions: [
      "See who's coming at a glance",
      'Every plan, one tap to answer',
      'Always in on Saturdays? Say it once',
      'Family, friends, team: all in one place',
    ],
  ),
  'de': (
    groups: [
      ('Familie', 'Sonntagsessen'),
      ('Fußball am Samstag', 'Jede Woche fünf gegen fünf'),
      ('Buchclub', 'Ein Buch im Monat'),
      ('D&D-Abend', null),
      ('Chor', 'Donnerstags, 20 Uhr'),
    ],
    match: 'Kicken',
    pizza: 'Pizza nach dem Spiel',
    captions: [
      'Auf einen Blick sehen, wer kommt',
      'Jeder Termin, eine Antwort per Tipp',
      'Samstags immer dabei? Einmal sagen reicht',
      'Familie, Freunde, Team: alles an einem Ort',
    ],
  ),
  'es': (
    groups: [
      ('Familia', 'Comidas del domingo'),
      ('Fútbol del sábado', 'Fútbol 5, cada semana'),
      ('Club de lectura', 'Un libro al mes'),
      ('Noche de D&D', null),
      ('Coro', 'Los jueves, 20:00'),
    ],
    match: 'Fútbol 5',
    pizza: 'Pizza después del partido',
    captions: [
      'Mira de un vistazo quién viene',
      'Cada plan, responde con un toque',
      '¿Siempre vas los sábados? Dilo una vez',
      'Familia, amigos, equipo: todo en un lugar',
    ],
  ),
  // French puts a no-break space before ? and :
  'fr': (
    groups: [
      ('Famille', 'Déjeuners du dimanche'),
      ('Foot du samedi', 'Foot à cinq, chaque semaine'),
      ('Club de lecture', 'Un livre par mois'),
      ('Soirée D&D', null),
      ('Chorale', 'Le jeudi, 20 h'),
    ],
    match: 'Foot à cinq',
    pizza: 'Pizza après le match',
    captions: [
      "Voyez d'un coup d'œil qui vient",
      "Chaque sortie, une réponse d'un geste",
      'Toujours là le samedi\u00a0? Dites-le une fois',
      'Famille, amis, équipe\u00a0: tout au même endroit',
    ],
  ),
  'it': (
    groups: [
      ('Famiglia', 'Pranzi della domenica'),
      ('Calcetto del sabato', 'Ogni settimana, cinque contro cinque'),
      ('Club del libro', 'Un libro al mese'),
      ('Serata D&D', null),
      ('Coro', 'Il giovedì, ore 20'),
    ],
    match: 'Calcetto',
    pizza: 'Pizza dopo la partita',
    captions: [
      'Vedi subito chi viene',
      'Ogni impegno, rispondi con un tocco',
      'Sempre presente il sabato? Dillo una volta',
      'Famiglia, amici, squadra: tutto in un posto',
    ],
  ),
};

final _demoProfile = Profile(id: 'me', displayName: 'Alex');

final _day = DateTime.utc(2026, 11, 7); // a Saturday

final _members = [
  (Member(id: 'me', groupId: 'football', role: GroupRoles.admin), _demoProfile),
  for (final (id, name) in [
    ('marta', 'Marta Rossi'),
    ('kwame', 'Kwame Mensah'),
    ('lena', 'Lena Fischer'),
    ('diego', 'Diego Herrera'),
    ('aiko', 'Aiko Tanaka'),
    ('sam', 'Sam Okafor'),
    ('chloe', 'Chloé Martin'),
    ('ravi', 'Ravi Patel'),
  ])
    (
      Member(id: id, groupId: 'football', role: GroupRoles.member),
      Profile(id: id, displayName: name),
    ),
];

// The user is in by their usual answer; the rest answered, but not everyone.
const _answers = {
  'marta': ReplyOptions.yes,
  'kwame': ReplyOptions.yes,
  'lena': ReplyOptions.no,
  'diego': ReplyOptions.yes,
  'aiko': ReplyOptions.yes,
  'sam': ReplyOptions.no,
};

ScheduleInstanceSummary _instance(
  Schedule schedule,
  Map<String, ReplyOptions> answers,
) => getScheduleInstances(
  schedule: schedule,
  startDate: _day,
  endDate: _day.add(const Duration(days: 1)),
  members: _members.map((m) => m.$1),
  targetMemberId: 'me',
  replies: [
    for (final MapEntry(key: memberId, value: answer) in answers.entries)
      Reply(
        memberId: memberId,
        scheduleId: schedule.id,
        instanceDate: _day.copyWith(
          hour: schedule.startDate.hour,
          minute: schedule.startDate.minute,
        ),
        selectedOption: answer,
      ),
  ],
  defaultRules: [
    DefaultRule(
      memberId: 'me',
      scheduleId: 'match',
      selectedOption: ReplyOptions.yes,
      recurrenceRule: CommonRecurrenceRules.weekly,
    ),
  ],
).single;

/// One entry per store screenshot, in store order: name -> screen under test
/// with [demo] data.
Map<String, Widget> _screens(_Demo demo) {
  final groups = [
    for (final (i, (name, description)) in demo.groups.indexed)
      Group(
        id: i == 1 ? 'football' : '$i',
        displayName: name,
        description: description,
      ),
  ];
  final football = groups[1];
  final match = Schedule(
    id: 'match',
    groupId: football.id,
    displayName: demo.match,
    startDate: DateTime.utc(2026, 1, 3, 10),
    recurrenceRule: CommonRecurrenceRules.weekly,
  );
  final pizza = Schedule(
    id: 'pizza',
    groupId: football.id,
    displayName: demo.pizza,
    startDate: DateTime.utc(2026, 11, 7, 12, 30),
    recurrenceRule: CommonRecurrenceRules.once,
  );
  final matchInstance = _instance(match, _answers);
  final event = GroupScheduleDetailsScreen(
    loading: false,
    group: football,
    scheduleInstance: scheduleInstanceDetails(
      matchInstance,
      _members,
      canEditOthers: true,
    ),
    scheduleRule: match.recurrenceRule,
    onReplyChanged: ({
      required memberId,
      required reply,
      required previous,
      name,
    }) {},
    onDefaultRuleChanged: ({
      required memberId,
      required rule,
      required reply,
      required previous,
      name,
    }) {},
  );
  return {
    'event': event,
    'group': GroupDetailsScreen(
      groupId: football.id,
      group: football,
      isAdmin: true,
      date: _day,
      onDateChanged: (_) {},
      instances: [
        matchInstance,
        _instance(pizza, {
          'marta': ReplyOptions.yes,
          'diego': ReplyOptions.yes,
        }),
      ],
      hasSchedules: true,
      onReplyChanged: (_, _) {},
    ),
    'usual': event,
    'home': HomeScreen(profile: _demoProfile, groups: groups),
  };
}

Widget _wrap(Widget screen, Locale locale) => MaterialApp(
  debugShowCheckedModeBanner: false,
  localizationsDelegates: appLocalizationsDelegates,
  supportedLocales: appSupportedLocales,
  locale: locale,
  // The real app theme. Cabin/Sniglet come from the bundled assets
  // (assets/google_fonts/), because runtime fetching is off in setUpAll.
  theme: appTheme(Brightness.light),
  home: screen,
);

/// Load real Roboto + MaterialIcons from the Flutter SDK cache so captures
/// don't use the blocky test font.
Future<void> _loadRealFonts() async {
  final loaders = <String, FontLoader>{};
  final root = Platform.environment['FLUTTER_ROOT'];
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  final sdkFonts = root != null && dir.existsSync()
      ? dir.listSync().whereType<File>()
      : const <File>[];
  for (final file in sdkFonts) {
    final name = file.uri.pathSegments.last;
    final family = switch (name) {
      _ when name.startsWith('Roboto-') => 'Roboto',
      _ when name.startsWith('MaterialIcons') => 'MaterialIcons',
      _ => null,
    };
    if (family == null) continue;
    final bytes = file.readAsBytesSync();
    (loaders[family] ??= FontLoader(
      family,
    )).addFont(Future.value(bytes.buffer.asByteData()));
  }
  // Fonts the app's packages declare (font_awesome_flutter's reply icons).
  final manifest = jsonDecode(await rootBundle.loadString('FontManifest.json'));
  for (final entry in (manifest as List).cast<Map<String, dynamic>>()) {
    final loader = loaders[entry['family'] as String] ??= FontLoader(
      entry['family'] as String,
    );
    for (final font in (entry['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
  }
  await Future.wait(loaders.values.map((l) => l.load()));
}

const _framedKey = Key('framed');

/// [app] laid out at full device size ([device]), scaled down under [caption]
/// on the brand colour. Captions stay within the top ~20% (Play's limit).
Widget _framed(
  Widget app, {
  required String caption,
  required MediaQueryData device,
}) {
  final colors = appTheme(Brightness.light).colorScheme;
  final size = device.size;
  final captionHeight = size.height * 0.18;
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      key: _framedKey,
      color: colors.primary,
      child: Column(
        children: [
          SizedBox(
            height: captionHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                size.shortestSide * 0.08,
                device.padding.top,
                size.shortestSide * 0.08,
                0,
              ),
              child: Center(
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: appTheme(Brightness.light).textTheme.headlineMedium!
                      .copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: size.shortestSide * 0.075,
                        height: 1.15,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.04),
              child: FittedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: const [
                      BoxShadow(blurRadius: 40, color: Color(0x55000000)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    // Device-sized, so the app lays out as on the device.
                    child: SizedBox.fromSize(
                      size: size,
                      child: MediaQuery(data: device, child: app),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

FakeViewPadding _viewPadding(EdgeInsets p) =>
    FakeViewPadding(left: p.left, top: p.top, right: p.right, bottom: p.bottom);

void main() {
  final enabled = Platform.environment['STORE_SCREENSHOTS'] == 'true';
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadRealFonts();
  });

  // Screens captured after a tap: the user's own row opens their usual answer.
  final taps = {'usual': find.byType(ScheduleMemberTile).first};

  group(
    'store screenshots',
    skip: enabled ? false : 'STORE_SCREENSHOTS not set',
    () {
      for (final MapEntry(key: profileName, value: profile)
          in _profiles.entries) {
        for (final locale in AppLocalizations.supportedLocales) {
          final demo = _demo[locale.languageCode]!;
          final screens = _screens(demo);
          for (final (index, MapEntry(key: screenName, value: screen))
              in screens.entries.indexed) {
            testWidgets('$profileName $locale $screenName', (tester) async {
              final view = tester.view;
              view.physicalSize = profile.logical * profile.dpr;
              view.devicePixelRatio = profile.dpr;
              view.padding = view.viewPadding = _viewPadding(
                profile.padding * profile.dpr,
              );
              addTearDown(view.reset);

              // Real shadows, not the test's black outlines. Restored in the
              // body: the binding checks it before tear-downs run.
              debugDisableShadows = false;
              try {
                await tester.pumpWidget(_wrap(screen, locale));
                await tester.pumpAndSettle();
                if (taps[screenName] case final tap?) {
                  await tester.tap(tap);
                  await tester.pumpAndSettle();
                }

                await expectLater(
                  find.byType(MaterialApp),
                  matchesGoldenFile('raw/$profileName/$locale/$screenName.png'),
                );

                // The same screen, smaller, under its caption.
                await tester.pumpWidget(
                  _framed(
                    _wrap(screen, locale),
                    caption: demo.captions[index],
                    device: MediaQueryData(
                      size: profile.logical,
                      devicePixelRatio: profile.dpr,
                      padding: profile.padding,
                      viewPadding: profile.padding,
                    ),
                  ),
                );
                await tester.pumpAndSettle();
                if (taps[screenName] case final tap?) {
                  await tester.tap(tap);
                  await tester.pumpAndSettle();
                }
                await expectLater(
                  find.byKey(_framedKey),
                  matchesGoldenFile(
                    'store/$profileName/$locale/${index + 1}_$screenName.png',
                  ),
                );
              } finally {
                debugDisableShadows = true;
              }
            }, variant: TargetPlatformVariant.only(profile.platform));
          }
        }
      }
    },
  );
}
