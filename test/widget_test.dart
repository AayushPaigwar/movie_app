// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_stream_app/main.dart';

void main() {
  testWidgets('App builds without errors and shows navigation', (
    WidgetTester tester,
  ) async {
    // Provide env vars for tests to avoid dotenv NotInitializedError
    dotenv.testLoad(
      fileInput: 'OMDB_API_KEY=demo\nOMDB_BASE_URL=https://www.omdbapi.com',
    );
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
