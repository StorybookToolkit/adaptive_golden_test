```dart

void main() {
  testAdaptiveWidgets(
    '$App render',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          device: Devices.ios.iPhoneSE,
          orientation: Orientation.portrait,
          isFrameVisible: true,
          showVirtualKeyboard: false,
          child: const App(),
        ),
      );

      await tester.expectGolden<App>(variant);
    },
  );
}
```