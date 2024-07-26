import 'package:device_frame_plus/device_frame_plus.dart';

import 'package:flutter/material.dart';

class AdaptiveWrapper extends StatelessWidget {
  const AdaptiveWrapper({
    super.key,
    required this.child,
    required this.device,
    this.orientation = Orientation.landscape,
    this.showVirtualKeyboard = false,
    this.isFrameVisible = true,
  });

  final Widget child;
  final DeviceInfo device;
  final Orientation orientation;
  final bool showVirtualKeyboard;
  final bool isFrameVisible;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DeviceFrame(
        device: device,
        isFrameVisible: isFrameVisible,
        orientation: orientation,
        screen: VirtualKeyboard(
          isEnabled: showVirtualKeyboard,
          child: child,
        ),
      ),
    );
  }
}
