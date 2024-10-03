import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders Scaffold', (tester) async {
      await tester.pumpWidget(const AppView());
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
