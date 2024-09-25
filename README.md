## adaptive_golden_test

A Flutter package to generate adaptive golden files during widget tests.

> This package is in beta. Use it with caution and [file any potential issues here](https://github.com/mjablecnik/adaptive_golden_test/issues).

<p>
  <img  alt="Example" src="https://raw.githubusercontent.com/mjablecnik/adaptive_golden_test/main/doc/example.png"/>
</p>

## Features
Use this package in your test to:
- Generated golden files during test for different devices.
- Load fonts.
- Set window sizes and pixel density.
- Await for images rendering.
- Render Physical and system UI layers.
- Render a keyboard during tests.
- Set a preferred OS to run the tests.
- Configure a difference tolerance threshold for files comparison.

## Getting started

Add `adaptive_golden_test` to your dev dependencies

At the root of your `test` folder create a `flutter_test_config.dart` file with a `testExecutable` function.

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await testMain();
}
```

See the [official doc](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html).

## Usage

### To render custom fonts:
- Add your fonts to your app assets folders.
- Add your fonts to your flutter assets.
```yaml
flutter:
  fonts:
  - family: Roboto
    fonts:
      - asset: fonts/Roboto-Black.ttf
...
```
- In your flutter_test_config, call `loadAppFonts()`.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  await testMain();
}
```
> ℹ️  `loadAppFonts` loads the fonts from the `pubspec.yaml`, and from every separate package dependencies as well.

### Setup devices to run test on
Define a set of device variant corresponding to your definition of done.
```dart
final defaultDeviceConfigs = {
  Devices.ios.iPhoneSE,
  Devices.ios.iPhone12,
  Devices.ios.iPad,
  Devices.linux.laptop,
  Devices.android.pixel4,
  Devices.android.samsungGalaxyS20,
};
```
Use the `AdaptiveTestConfiguration` singleton to set variants.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  await testMain();
}
```

### (Optional) Allow a differences threshold in golden files comparators
Source : [The Rows blog](https://rows.com/blog/post/writing-a-localfilecomparator-with-threshold-for-flutter-golden-tests)
Different processor architectures can lead to a small differences of pixel between a files generated on an ARM processor and an x86 one.
Eg: a MacBook M1 and an intel one.

We can allow the tests to passe if the difference is small. To do this, add `setupFileComparatorWithThreshold()` to your flutter_test_config.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
```

### (Optional) Enforce a Platform for the test to run on
Different OS render golden files with small differences of pixel.
See the [flutter issue](https://github.com/flutter/flutter/issues/36667).

As an alternative you can use [Alchemist](https://pub.dev/packages/alchemist).

Also, you can configure `AdaptiveTestConfiguration` singleton to skip tests instead of throwing if they are run on an unintended platform.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setFailTestOnWrongPlatform(false) <-- Adding this will skip the `testAdaptiveWidgets` tests if you are not running the tests on a macOS platform.
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadAppFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
```

### Write a test
Use `testAdaptiveWidgets` function. It take a callback with two arguments, `WidgetTester` and `WindowConfigData`.

`WindowConfigData` is a data class that describes a devices. It's used as a test variant.

```dart
void main() {
  testAdaptiveWidgets(
    'Test description',
    (tester, variant) async {},
  );
}
```

Wrap the widget you want to test with `AdaptiveWrapper`.

```dart
await tester.pumpWidget(
  AdaptiveWrapper(
    device: variant,
    orientation: Orientation.portrait,
    isFrameVisible: true,
    showVirtualKeyboard: false,
    child: const App(),
  ),
);
```

Use the `WidgetTester` extension `expectGolden` to generate golden files.

```dart
await tester.expectGolden<App>(variant);
```

A basic test should looks like this:
```dart
void main() {
  testAdaptiveWidgets(
    '$App render without regressions',
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

      await tester.expectGolden<App>(variant);
    },
  );
}
```


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## Special thanks

I want to thank previous developers for their work:
- [BAM](https://github.com/bamlab): 100 people company developing and designing multiplatform applications with [React Native](https://www.bam.tech/expertise/react-native) and [Flutter](https://www.bam.tech/expertise/flutter) using the Lean & Agile methodology.


## Maintainer

👤 **Martin Jablečník**

* Website: [martin-jablecnik.cz](https://www.martin-jablecnik.cz)
* Github: [@mjablecnik](https://github.com/mjablecnik)
* Blog: [dev.to/mjablecnik](https://dev.to/mjablecnik)


## Show your support

Give a ⭐️ if this project helped you!

<a href="https://www.patreon.com/mjablecnik">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>
