## adaptive_golden_test

A Flutter package to generate adaptive golden files during widget tests.

![Example](https://raw.githubusercontent.com/mjablecnik/adaptive_golden_test/main/doc/example.png)

## Table of Contents
1. [Features](#features)
2. [Getting Started](#getting-started)
3. [Usage](#usage)
   - [Rendering Custom Fonts](#rendering-custom-fonts)
   - [Setting Up Test Devices](#setting-up-test-devices)
   - [Configuring Difference Threshold](#configuring-difference-threshold)
   - [Enforcing Test Platform](#enforcing-test-platform)
   - [Writing a Test](#writing-a-test)
4. [Migration Guide](#migration-guide)
5. [Additional Information](#additional-information)

## Features

Use this package in your tests to:
- Generate golden files for different devices during tests
- Load fonts
- Set window sizes and pixel density
- Await image rendering
- Render physical and system UI layers
- Render a keyboard during tests
- Set a preferred OS for running tests
- Configure a difference tolerance threshold for file comparison

## Getting Started

1. Add `adaptive_test` to your dev dependencies.

2. Create a `flutter_test_config.dart` file at the root of your `test` folder with a `testExecutable` function:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await testMain();
}
```

For more information, see the [official Flutter documentation](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html).

## Usage

### Rendering Custom Fonts

1. Add your fonts to your app assets folders.
2. Add your fonts to your Flutter assets in `pubspec.yaml`:

```yaml
flutter:
  fonts:
  - family: Roboto
    fonts:
      - asset: fonts/Roboto-Black.ttf
```

3. In your `flutter_test_config.dart`, call `loadFonts()`:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadFonts();
  await testMain();
}
```

> ℹ️ `loadFonts()` loads fonts from `pubspec.yaml` and from every separate package dependency as well.

### Setting Up Test Devices

1. Define a set of device variants:

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

2. Use the `AdaptiveTestConfiguration` singleton to set variants:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  await testMain();
}
```

### Configuring Difference Threshold

To allow for small pixel differences between processors, add `setupFileComparatorWithThreshold()` to your `flutter_test_config.dart`:

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

### Enforcing Test Platform

Configure `AdaptiveTestConfiguration` to enforce a specific test platform:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
```

To skip tests instead of throwing an error on unintended platforms:

```dart
AdaptiveTestConfiguration.instance
  ..setEnforcedTestPlatform(TargetPlatform.macOS)
  ..setFailTestOnWrongPlatform(false)
  ..setDeviceVariants(defaultDeviceConfigs);
```

### Writing a Test

Use the `testAdaptiveWidgets` function:

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
