// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parousia/app.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenAnswer((_) async {
      return null;
    });
    HydratedBloc.storage = storage;
  });

  testWidgets(
    'App has a title and a drawer button',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ParApp());

      // Verify that our app has a title.
      expect(find.text('Parousia'), findsWidgets);

      // Verify that our app has a drawer button.
      expect(find.byType(DrawerButton), findsOneWidget);
    },
  );
}
