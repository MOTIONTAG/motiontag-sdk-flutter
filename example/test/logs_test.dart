import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motiontag_example/logs.dart';

void main() {
  testWidgets(
    'appends logs',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Logs()));
      Logs.print('hello world');
      await tester.pump();
      expect(find.text('hello world'), findsOneWidget);
    },
  );
}
