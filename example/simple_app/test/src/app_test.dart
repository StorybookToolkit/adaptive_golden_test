import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:simple_app_example/src/app.dart';
import 'package:flutter/material.dart';

void main() {
  testAdaptiveWidgets(
    'Adaptive test with default path',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          device: variant,
          orientation: Orientation.portrait,
          isFrameVisible: true,
          showVirtualKeyboard: false,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(variant, suffix: 'simple');
    },
  );

  testAdaptiveWidgets(
    'Adaptive test with custom path',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          device: variant,
          orientation: Orientation.portrait,
          isFrameVisible: true,
          showVirtualKeyboard: false,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(
        variant,
        path: "golden/simple/without_keyboard/${variant.name.replaceAll(' ', '_')}.png",
      );

      await tester.pumpWidget(
        AdaptiveWrapper(
          device: variant,
          orientation: Orientation.portrait,
          isFrameVisible: true,
          showVirtualKeyboard: true,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(
        variant,
        path: "golden/simple/with_keyboard/${variant.name.replaceAll(' ', '_')}.png",
      );
    },
  );
}
