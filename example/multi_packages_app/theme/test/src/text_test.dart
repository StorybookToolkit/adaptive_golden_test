import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_packages_app/src/widgets/text.dart';
import 'package:flutter/material.dart';

void main() {
  testAdaptiveWidgets(
    '$AppText render',
    (tester, variant) async {
      await tester.pumpWidget(const MaterialApp(home: AppText('Hello World')));

      expect(find.text('Hello World'), findsOneWidget);
    },
  );
}
