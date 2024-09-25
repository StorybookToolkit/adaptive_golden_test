import 'dart:async';

import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final defaultDeviceConfigs = {
  Devices.ios.iPhoneSE,
  Devices.ios.iPhone12,
  Devices.ios.iPad,
  Devices.linux.laptop,
  Devices.android.pixel4,
  Devices.android.samsungGalaxyS20,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadAppFonts();
  const m1IntelDifferenceThreshold = 0.2 / 100; // 0.2%
  setupFileComparatorWithThreshold(m1IntelDifferenceThreshold);
  await testMain();
}
