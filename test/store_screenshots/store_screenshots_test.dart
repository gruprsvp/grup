@Tags(['screenshots'])
library;

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/app.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/recurrence_rules.dart';

import 'staging.dart';

// Store-screenshot harness: renders real screens with staged demo data at
// store resolutions, one per screen × locale × device profile, into
// test/store_screenshots/raw/ (gitignored): the bare screen, where its key
// widgets sit, and the captions. tools/store-art/ turns them into the store
// images (see docs/STORE_SCREENSHOTS.md).
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
  // One per screen, in `screens` order; *stars* mark the accent words.
  List<String> captions,
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
      "See *who's coming* at a glance",
      'Every plan, *one tap* to answer',
      'Always in on Saturdays? *Say it once*',
      'Family, friends, team: *all in one place*',
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
      'Auf einen Blick sehen, *wer kommt*',
      'Jeder Termin, eine Antwort *per Tipp*',
      'Samstags immer dabei? *Einmal sagen reicht*',
      'Familie, Freunde, Team: *alles an einem Ort*',
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
      'Mira de un vistazo *quién viene*',
      'Cada plan, responde *con un toque*',
      '¿Siempre vas los sábados? *Dilo una vez*',
      'Familia, amigos, equipo: *todo en un lugar*',
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
      "Voyez d'un coup d'œil *qui vient*",
      "Chaque sortie, une réponse *d'un geste*",
      'Toujours là le samedi\u00a0? *Dites-le une fois*',
      'Famille, amis, équipe\u00a0: *tout au même endroit*',
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
      'Vedi subito *chi viene*',
      'Ogni impegno, rispondi *con un tocco*',
      'Sempre presente il sabato? *Dillo una volta*',
      'Famiglia, amici, squadra: *tutto in un posto*',
    ],
  ),
};

final _demoProfile = Profile(
  id: 'me',
  displayName: 'Alex',
  picture: avatarUrl('me'),
);

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
      Profile(id: id, displayName: name, picture: avatarUrl(id)),
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

/// Who answered what at the pizza: the store images' state.
const _pizzaAnswers = {'marta': ReplyOptions.yes, 'diego': ReplyOptions.yes};

/// Called when a screen's answer buttons are tapped: (schedule id, member
/// id, answer). The previews use it to play the answer out.
typedef _OnReply = void Function(String, String, ReplyOptions?);

/// One entry per store screenshot, in store order: name -> screen under test
/// with [demo] data, laid out for a [wide] window or not.
Map<String, Widget> _screens(
  _Demo demo, {
  required bool wide,
  Map<String, ReplyOptions> answers = _answers,
  Map<String, ReplyOptions> pizzaAnswers = _pizzaAnswers,
  _OnReply? onReply,
}) {
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
  final matchInstance = _instance(match, answers);
  final pizzaInstance = _instance(pizza, pizzaAnswers);
  GroupScheduleDetailsScreen event(
    Schedule schedule,
    ScheduleInstanceSummary instance,
  ) => GroupScheduleDetailsScreen(
    loading: false,
    group: football,
    scheduleInstance: scheduleInstanceDetails(
      instance,
      _members,
      canEditOthers: true,
    ),
    scheduleRule: schedule.recurrenceRule,
    automaticallyImplyLeading: !wide,
    onReplyChanged: ({
      required memberId,
      required reply,
      required previous,
      name,
    }) => onReply?.call(schedule.id, memberId, reply),
    onDefaultRuleChanged: ({
      required memberId,
      required rule,
      required reply,
      required previous,
      name,
    }) {},
  );
  GroupDetailsScreen day(ScheduleInstanceSummary? open) => GroupDetailsScreen(
    groupId: football.id,
    group: football,
    isAdmin: true,
    date: _day,
    onDateChanged: (_) {},
    instancesOn: (_) => [matchInstance, pizzaInstance],
    hasSchedules: true,
    onReplyChanged: (instance, reply) =>
        onReply?.call(instance.scheduleId, 'me', reply),
    selected: open == null
        ? null
        : (scheduleId: open.scheduleId, at: open.instanceDate),
  );
  // As the app lays them out: wide windows show the event next to the day.
  Widget panes(Schedule schedule, ScheduleInstanceSummary open) =>
      TwoPane(list: day(open), detail: event(schedule, open));
  return {
    'event': wide ? panes(match, matchInstance) : event(match, matchInstance),
    'group': wide ? panes(pizza, pizzaInstance) : day(null),
    'usual': wide ? panes(match, matchInstance) : event(match, matchInstance),
    'home': ReadableWidth(
      child: HomeScreen(profile: _demoProfile, groups: groups),
    ),
  };
}

Widget _wrap(Widget screen, Locale locale, {Widget? overlay}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  localizationsDelegates: appLocalizationsDelegates,
  supportedLocales: appSupportedLocales,
  locale: locale,
  // The real app theme. Cabin/Sniglet come from the bundled assets
  // (assets/google_fonts/), because runtime fetching is off in setUpAll.
  theme: appTheme(Brightness.light),
  home: screen,
  // Device frames show the status bar: draw a clean one on iOS.
  // The previews' captions and touch hotspots go on top.
  builder: (context, child) => Stack(
    children: [
      child!,
      if (Theme.of(context).platform == TargetPlatform.iOS)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.paddingOf(context).top,
          child: const IosStatusBar(),
        ),
      ?overlay,
    ],
  ),
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

/// Where each screen's key widgets sit, for the callouts the store art floats
/// out of the screen (tools/store-art/). Private widgets go by type name.
Map<String, Finder> _anchors(String screen) {
  Finder named(String type) =>
      find.byWidgetPredicate((w) => w.runtimeType.toString() == type);
  return switch (screen) {
    'event' => {
      'headcount': named('_Headcount'),
      'you': find.byType(ScheduleMemberTile).first,
      'member': find.byType(ScheduleMemberTile).at(1),
      'member_yes': find
          .descendant(
            of: find.byType(ScheduleMemberTile).at(1),
            matching: find.byType(YesButton),
          )
          .first,
    },
    'group' => {
      'event': find.byType(ScheduleTile).first,
      'event2': find.byType(ScheduleTile).at(1),
      'event2_yes': find
          .descendant(
            of: find.byType(ScheduleTile).at(1),
            matching: find.byType(YesButton),
          )
          .first,
    },
    'usual' => {'sheet': find.byType(DefaultRuleActionSheet)},
    'home' => {
      'group': find
          .descendant(
            of: find.byType(GroupsList),
            matching: find.byType(ListTile),
          )
          .at(1),
    },
    _ => {},
  };
}

/// [rect] in physical pixels of a [dpr] capture, as `[left, top, width, height]`.
List<double> _px(Rect rect, double dpr) =>
    [rect.left, rect.top, rect.width, rect.height].map((v) => v * dpr).toList();

FakeViewPadding _viewPadding(EdgeInsets p) =>
    FakeViewPadding(left: p.left, top: p.top, right: p.right, bottom: p.bottom);

// App Store app previews: in-app footage only (Guideline 2.3.4), so the
// harness plays the real screens: taps answer buttons, the screens update,
// and every frame goes to ffmpeg. Captions and touch hotspots are overlays,
// which Apple allows; scenes are joined with dissolves.
//
//   STORE_PREVIEWS=true flutter test --tags screenshots --plain-name previews
//
// → build/store-art/app-previews/<locale>/<device>.mp4, for App Store
// Connect (fastlane can't upload previews).

/// Apple's accepted preview sizes: 886×1920 for every iPhone class, 1200×1600
/// for iPad 13". Logical sizes close to the real devices'.
const _previewProfiles = <String, _Profile>{
  'iphone': (
    logical: Size(443, 960),
    dpr: 2,
    platform: _ios,
    padding: _iPhonePadding,
  ),
  'ipad': (
    logical: Size(1032, 1376),
    dpr: 1200 / 1032,
    platform: _ios,
    padding: _iPadPadding,
  ),
};
const _fps = 30;
const _dissolve = 0.4; // seconds

/// A scene: a screenshot's screen, how long it plays, and when what is tapped.
typedef _Scene = ({
  String screen,
  double seconds,
  List<(double, Finder Function())> taps,
  bool captionOnTop,
});

Finder _yesOf(Finder tile) =>
    find.descendant(of: tile, matching: find.byType(YesButton)).first;
Finder _memberTile(String name) => find.ancestor(
  of: find.text(name),
  matching: find.byType(ScheduleMemberTile),
);

// The two who hadn't answered come in, the user answers the pizza, sets
// their usual answer, and lands on their groups.
final _previewScenes = <_Scene>[
  (
    screen: 'event',
    seconds: 6,
    taps: [
      (1.6, () => _yesOf(_memberTile('Chloé Martin'))),
      (3.5, () => _yesOf(_memberTile('Ravi Patel'))),
    ],
    captionOnTop: false,
  ),
  (
    screen: 'group',
    seconds: 5,
    taps: [(1.8, () => _yesOf(find.byType(ScheduleTile).at(1)))],
    captionOnTop: false,
  ),
  (
    screen: 'usual',
    seconds: 5.5,
    taps: [(1.4, () => find.byType(ScheduleMemberTile).first)],
    // The sheet comes up from the bottom: keep it in view.
    captionOnTop: true,
  ),
  (screen: 'home', seconds: 4, taps: [], captionOnTop: false),
];

/// [caption] on two lines of about equal length when it's long, split at a
/// space outside the *starred* words, as tools/store-art/art.py does.
String _balanced(String caption, {int minChars = 26}) {
  final plain = caption.replaceAll('*', '');
  if (plain.length < minChars) return caption;
  var starred = false;
  var visible = 0;
  final spaces = <int>[]; // indices into caption
  for (var i = 0; i < caption.length; i++) {
    if (caption[i] == '*') {
      starred = !starred;
      continue;
    }
    if (caption[i] == ' ' && !starred) spaces.add(i);
    visible++;
  }
  int plainIndex(int i) => caption.substring(0, i).replaceAll('*', '').length;
  final best = spaces.reduce(
    (a, b) =>
        (visible - 2 * plainIndex(a)).abs() <=
            (visible - 2 * plainIndex(b)).abs()
        ? a
        : b,
  );
  return '${caption.substring(0, best)}\n${caption.substring(best + 1)}';
}

/// [caption] (with *starred* accent words) as a card above the home
/// indicator (or under the status bar, [onTop]), faded by [t] in 0..1.
Widget _captionOverlay(
  String caption,
  double t,
  double scale, {
  bool onTop = false,
}) {
  final colors = appTheme(Brightness.light).colorScheme;
  final style = TextStyle(
    fontFamily: appTheme(Brightness.light).textTheme.bodyLarge!.fontFamily,
    fontSize: 27 * scale,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  return Builder(
    builder: (context) => Positioned(
      left: 20 * scale,
      right: 20 * scale,
      top: onTop ? MediaQuery.paddingOf(context).top + 8 * scale : null,
      bottom: onTop ? null : MediaQuery.paddingOf(context).bottom + 20 * scale,
      // Above the Navigator, so no Material: without one, text is styled
      // as an error (underlined).
      child: Material(
        type: MaterialType.transparency,
        child: IgnorePointer(
          child: Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 24 * scale),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(24 * scale),
                  boxShadow: const [
                    BoxShadow(blurRadius: 30, color: Color(0x40000000)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22 * scale,
                    vertical: 18 * scale,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        for (final (i, part) in _balanced(
                          caption,
                        ).split('*').indexed)
                          TextSpan(
                            text: part,
                            style: i.isOdd
                                ? const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF9BE89A),
                                  )
                                : null,
                          ),
                      ],
                    ),
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// A touch hotspot at [at], [t] seconds after the tap (negative: before).
Widget _hotspot(Offset at, double t, double scale) {
  // In over 0.15 s before the tap, out over 0.3 s after it.
  final opacity = t < 0
      ? (1 + t / 0.15).clamp(0.0, 1.0)
      : (1 - t / 0.3).clamp(0.0, 1.0);
  final size = 58 * scale * (t < 0 ? 0.8 + 0.2 * opacity : 1 + t * 0.5);
  return Positioned(
    left: at.dx - size / 2,
    top: at.dy - size / 2,
    width: size,
    height: size,
    child: IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.35),
            border: Border.all(color: Colors.white, width: 2.5 * scale),
            boxShadow: const [
              BoxShadow(blurRadius: 12, color: Color(0x33000000)),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<Process> _ffmpeg(List<String> args) async {
  final process = await Process.start('ffmpeg', ['-v', 'error', '-y', ...args]);
  process.stderr.listen(stderr.add);
  return process;
}

void main() {
  final enabled = Platform.environment['STORE_SCREENSHOTS'] == 'true';
  final previews = Platform.environment['STORE_PREVIEWS'] == 'true';
  // Bare Android footage (no captions or audio) for the 3D Play promo film,
  // tools/store-art/films.py: STORE_FOOTAGE=true.
  final footage = Platform.environment['STORE_FOOTAGE'] == 'true';
  final recordings = <String, _Profile>{
    if (previews) ..._previewProfiles,
    // 1080×2340, a modern phone: tall enough that every row is on screen.
    if (footage)
      'android': (
        logical: const Size(432, 936),
        dpr: 2.5,
        platform: _android,
        padding: _androidPadding,
      ),
  };
  Map<String, ui.Image>? avatars;
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadRealFonts();
    // google_fonts loads on first use, asynchronously: the first screen to
    // use the wordmark's Sniglet would otherwise capture it unloaded.
    GoogleFonts.sniglet();
    GoogleFonts.cabin();
    await GoogleFonts.pendingFonts();
    if (!enabled) return;
    // The store art reads the captions from here, the source of truth.
    File('test/store_screenshots/raw/captions.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert({
          for (final MapEntry(:key, :value) in _demo.entries)
            key: value.captions,
        }),
      );
  });

  // Screens captured after a tap: the user's own row opens their usual answer.
  final taps = {'usual': find.byType(ScheduleMemberTile).first};

  group('store screenshots', skip: enabled ? false : 'STORE_SCREENSHOTS not set', () {
    for (final MapEntry(key: profileName, value: profile)
        in _profiles.entries) {
      for (final locale in AppLocalizations.supportedLocales) {
        final demo = _demo[locale.languageCode]!;
        final screens = _screens(
          demo,
          wide: profile.logical.width >= TwoPane.expandedWidth,
        );
        for (final MapEntry(key: screenName, value: screen)
            in screens.entries) {
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
              avatars ??= await tester.runAsync(drawAvatars);
              seedAvatars(avatars!);
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
              File(
                'test/store_screenshots/raw/$profileName/$locale/$screenName.json',
              ).writeAsStringSync(
                jsonEncode({
                  'size': _px(Offset.zero & profile.logical, profile.dpr),
                  'top': profile.padding.top * profile.dpr,
                  for (final MapEntry(:key, :value) in _anchors(
                    screenName,
                  ).entries)
                    key: _px(tester.getRect(value), profile.dpr),
                }),
              );
            } finally {
              debugDisableShadows = true;
            }
          }, variant: TargetPlatformVariant.only(profile.platform));
        }
      }
    }
  });

  group('previews', skip: recordings.isEmpty ? 'STORE_PREVIEWS not set' : false, () {
    for (final MapEntry(key: device, value: profile) in recordings.entries) {
      final bare = device == 'android';
      for (final locale in AppLocalizations.supportedLocales) {
        testWidgets(
          '$device $locale',
          (tester) async {
            final view = tester.view;
            view.physicalSize = profile.logical * profile.dpr;
            view.devicePixelRatio = profile.dpr;
            view.padding = view.viewPadding = _viewPadding(
              profile.padding * profile.dpr,
            );
            addTearDown(view.reset);
            final (w, h) = (
              view.physicalSize.width.round(),
              view.physicalSize.height.round(),
            );
            final demo = _demo[locale.languageCode]!;
            final wide = profile.logical.width >= TwoPane.expandedWidth;
            final scale = wide ? 1.3 : 1.0;
            final dir = Directory('build/store-art/.scenes/$device-$locale')
              ..createSync(recursive: true);
            final scenes = <(String, double)>[];
            debugDisableShadows = false;
            try {
              avatars ??= await tester.runAsync(drawAvatars);
              for (final (index, scene) in _previewScenes.indexed) {
                seedAvatars(avatars!);
                var answers = Map.of(_answers);
                var pizza = Map.of(_pizzaAnswers);
                void onReply(String schedule, String member, ReplyOptions? r) {
                  final map = schedule == 'pizza' ? pizza : answers;
                  final next = Map.of(map);
                  r == null ? next.remove(member) : next[member] = r;
                  schedule == 'pizza' ? pizza = next : answers = next;
                }

                final hotspots = <(double, Offset)>[];
                Widget frame(double t) {
                  final screens = _screens(
                    demo,
                    wide: wide,
                    answers: answers,
                    pizzaAnswers: pizza,
                    onReply: onReply,
                  );
                  // Captions ease in after the dissolve and out before the next.
                  final fade =
                      ((t - 0.3) / 0.35).clamp(0.0, 1.0) *
                      ((scene.seconds - 0.25 - t) / 0.35).clamp(0.0, 1.0);
                  return _wrap(
                    screens[scene.screen]!,
                    locale,
                    overlay: Stack(
                      children: [
                        for (final (at, where) in hotspots)
                          if (t - at > -0.15 && t - at < 0.3)
                            _hotspot(where, t - at, scale),
                        if (!bare)
                          _captionOverlay(
                            demo.captions[index],
                            Curves.easeOut.transform(fade),
                            scale,
                            onTop: scene.captionOnTop,
                          ),
                      ],
                    ),
                  );
                }

                final path = '${dir.path}/$index.mp4';
                final out = (await tester.runAsync(
                  () => _ffmpeg([
                    '-f', 'rawvideo', '-pix_fmt', 'rgba', //
                    '-s', '${w}x$h', '-r', '$_fps', '-i', '-',
                    '-c:v', 'libx264', '-preset', 'medium', '-crf', '10',
                    '-pix_fmt', 'yuv420p', path,
                  ]),
                ))!;
                await tester.pumpWidget(frame(0));
                await tester.pumpAndSettle();
                final frames = (scene.seconds * _fps).round();
                final pending = [...scene.taps];
                for (var i = 0; i < frames; i++) {
                  final t = i / _fps;
                  // Hotspot shows just before the tap: find its target early.
                  for (final (at, target) in pending) {
                    if (t >= at - 0.15 && !hotspots.any((e) => e.$1 == at)) {
                      hotspots.add((at, tester.getCenter(target())));
                    }
                  }
                  if (pending.isNotEmpty && t >= pending.first.$1) {
                    await tester.tap(pending.removeAt(0).$2());
                  }
                  await tester.pumpWidget(
                    frame(t),
                    duration: const Duration(microseconds: 1000000 ~/ _fps),
                  );
                  await tester.runAsync(() async {
                    final image = await captureImage(
                      find.byType(MaterialApp).evaluate().single,
                    );
                    final bytes = (await image.toByteData())!;
                    image.dispose();
                    out.stdin.add(bytes.buffer.asUint8List());
                    await out.stdin.flush();
                  });
                }
                await tester.runAsync(() async {
                  await out.stdin.close();
                  expect(await out.exitCode, 0, reason: path);
                });
                scenes.add((path, scene.seconds));
                // The next scene starts from scratch: drop this one's routes.
                await tester.pumpWidget(const SizedBox());
              }

              // Dissolves between scenes, a silent stereo track (the spec asks
              // for audio), and Apple's encoding: H.264 High 4.0, 10–12 Mbps.
              final iosLocale = switch (locale.languageCode) {
                'it' => 'it',
                final lang =>
                  '$lang-${{'de': 'DE', 'en': 'GB', 'es': 'ES', 'fr': 'FR'}[lang]}',
              };
              final target = File(
                bare
                    ? 'build/store-art/footage/$locale/$device.mp4'
                    : 'build/store-art/app-previews/$iosLocale/$device.mp4',
              )..parent.createSync(recursive: true);
              final chain = StringBuffer();
              var offset = 0.0;
              var last = '0:v';
              for (var i = 1; i < scenes.length; i++) {
                offset += scenes[i - 1].$2 - _dissolve;
                final label = i == scenes.length - 1 ? 'v' : 'x$i';
                chain.write(
                  '[$last][$i:v]xfade=transition=fade:duration=$_dissolve:offset=${offset.toStringAsFixed(3)}[$label];',
                );
                last = label;
              }
              final total =
                  scenes.fold(0.0, (sum, s) => sum + s.$2) -
                  _dissolve * (scenes.length - 1);
              expect(total, inInclusiveRange(15, 30), reason: 'Apple: 15–30 s');
              await tester.runAsync(() async {
                final join = await _ffmpeg([
                  for (final (path, _) in scenes) ...['-i', path],
                  if (!bare) ...[
                    '-f',
                    'lavfi',
                    '-i',
                    'anullsrc=r=48000:cl=stereo',
                  ],
                  '-filter_complex',
                  chain.toString().replaceAll(RegExp(r';$'), ''),
                  '-map', '[v]', //
                  if (bare) ...[
                    '-c:v',
                    'libx264',
                    '-crf',
                    '12',
                    '-pix_fmt',
                    'yuv420p',
                  ] else ...[
                    '-map', '${scenes.length}:a', '-shortest', //
                    '-c:v', 'libx264', '-profile:v', 'high', '-level:v', '4.0',
                    // Constant 11 Mbps: still UI would otherwise encode far
                    // below the spec's 10–12 Mbps.
                    '-b:v', '11M', '-minrate', '11M', '-maxrate', '11M',
                    '-bufsize', '22M', '-x264-params', 'nal-hrd=cbr',
                    '-r', '$_fps', '-pix_fmt', 'yuv420p',
                    '-c:a', 'aac', '-b:a', '256k', '-ar', '48000',
                  ],
                  '-movflags', '+faststart', target.path,
                ]);
                await join.stdin.close();
                expect(await join.exitCode, 0, reason: target.path);
              });
            } finally {
              debugDisableShadows = true;
            }
          },
          variant: TargetPlatformVariant.only(profile.platform),
          timeout: Timeout.none,
        );
      }
    }
  });
}
