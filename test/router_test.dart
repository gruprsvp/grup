// go_router picks its page type by looking for a MaterialApp ancestor. Since
// Flutter 3.47 there are two MaterialApp types (package:flutter/material.dart
// and package:material_ui); if go_router looks for the one the app doesn't
// use, it silently falls back to NoTransitionPage and every page transition
// disappears. Nothing else in CI would notice.
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/app.dart';
import 'package:parousia/presentation/screens/auth.dart';
import 'package:parousia/reducers/root_reducer.dart';
import 'package:parousia/router.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

import 'support/fake_supabase.dart';

void main() {
  setUpAll(initFakeSupabase);

  testWidgets('routes are built as MaterialPage', (tester) async {
    // Routes build Redux-connected containers, so provide a store (no epics:
    // nothing here should reach the backend).
    final store = Store<AppState>(
      rootReducer,
      initialState: AppState.initialState(),
    );
    await tester.pumpWidget(
      StoreProvider(
        store: store,
        child: MaterialApp.router(
          theme: appTheme(Brightness.light),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: appSupportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Signed out, so the guard lands on the auth screen.
    expect(find.byType(AuthScreen), findsOneWidget);

    final navigator = tester.widget<Navigator>(find.byType(Navigator).first);
    expect(navigator.pages, isNotEmpty);
    for (final page in navigator.pages) {
      expect(
        page.runtimeType.toString(),
        startsWith('MaterialPage'),
        reason: 'go_router did not detect the MaterialApp',
      );
    }
  });
}
