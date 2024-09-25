import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_packages_example_theme/src/widgets/text.dart';

void main() {
  testAdaptiveWidgets(
    '$AppText render',
    (tester, variant) async {
      await tester.pumpWidget(const MaterialApp(home: AppText('Hello World')));

      expect(find.text('Hello World'), findsOneWidget);
    },
  );
}
