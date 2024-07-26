import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dart extension to add configuration functions to a [WidgetTester] object,
/// e.g. [configureWindow], [configureOpenedKeyboardWindow],
/// [configureClosedKeyboardWindow].
extension WidgetTesterWithConfigurableWindow on WidgetTester {
  /// Configure the tester window to represent the given device variant.
  void configureWindow(DeviceInfo windowConfig) {
    view.physicalSize = windowConfig.frameSize;
    view.devicePixelRatio = windowConfig.pixelRatio;
    view.padding = FakeViewPadding(
      left: windowConfig.safeAreas.left*2,
      right: windowConfig.safeAreas.right*2,
      top: windowConfig.safeAreas.top*2,
      bottom: windowConfig.safeAreas.bottom*2,
    );
    view.viewPadding = FakeViewPadding(
      left: windowConfig.safeAreas.left,
      right: windowConfig.safeAreas.right,
      top: windowConfig.safeAreas.top,
      bottom: windowConfig.safeAreas.bottom,
    );

    addTearDown(view.resetPadding);
    addTearDown(view.resetViewPadding);
    addTearDown(view.resetDevicePixelRatio);
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetViewInsets);
  }
}

class WindowVariant extends ValueVariant<DeviceInfo> {
  WindowVariant(this.windowConfigs) : super(windowConfigs);

  final Set<DeviceInfo> windowConfigs;

  @override
  String describeValue(DeviceInfo value) => value.name;
}
