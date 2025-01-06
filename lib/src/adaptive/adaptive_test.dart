import 'dart:io';

import 'package:adaptive_golden_test/adaptive_golden_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

import '../helpers/target_platform_extension.dart';

/// Type of [callback] that will be executed inside the Flutter test environment.
///
/// Take a [WidgetTester] and a [WindowConfigData] for arguments.
typedef WidgetTesterAdaptiveCallback = Future<void> Function(
  WidgetTester widgetTester,
  DeviceInfo windowConfig,
);

/// Function wrapper around [testWidgets] that will be executed for every
/// [WindowConfigData] variant.
@isTest
void testAdaptiveWidgets(
  String description,
  WidgetTesterAdaptiveCallback callback, {
  /// If true, the test will be skipped. Defaults to false.
  /// If [enforcedTestPlatform] is defined in the [AdaptiveTestConfiguration]
  /// and [failTestOnWrongPlatform] is false, the test will be skipped if the
  /// runtime platform does not match the [enforcedTestPlatform].
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  ValueVariant<DeviceInfo>? variantOverride,
  dynamic tags,
}) {
  final configuration = AdaptiveTestConfiguration.instance;
  final defaultVariant = configuration.deviceVariant;
  final variant = variantOverride ?? defaultVariant;

  final _skip = skip ?? configuration.shouldSkipTest;

  testWidgets(
    description,
    (tester) async {
      debugDefaultTargetPlatformOverride = variant.currentValue!.identifier.platform;
      debugDisableShadows = false;
      // ignore: avoid-non-null-assertion, will throw in test
      tester.configureWindow(variant.currentValue!);
      // ignore: avoid-non-null-assertion, will throw in test
      await callback(tester, variant.currentValue!);
      debugDisableShadows = true;
      debugDefaultTargetPlatformOverride = null;
    },
    skip: _skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

/// Extend [WidgetTester] with the [expectGolden] method, providing the ability
/// to assert golden matching for a given [WindowConfigData].
///
/// Golden file previews are stored within the "preview" folder.
///
/// Because adaptive rendering depends on the targeted platform, we need to make
/// sure the platform running the current test matches the
/// [enforcedTestPlatform] defined in the [AdaptiveTestConfiguration].
extension Adaptive on WidgetTester {
  /// Visual regression test for a given [WindowConfigData].
  ///
  /// The [prefix] is appended to the golden file name. It defaults to
  /// the empty string if not provided.
  ///
  /// The [suffix] is appended to the golden file name. It defaults to
  /// the empty string if not provided.
  ///
  /// The [title] parameter is appended to the golden file name to distinguish
  /// between different test cases. It defaults to the widget name if not provided.
  /// 
  /// By default, the path of the generated golden file is constructed as
  /// follows:
  /// `preview/${windowConfig.name}-${name.snakeCase}$localSuffix.png`.
  /// If a [path] is provided, it will override this default behavior.
  ///
  /// The [byKey] argument allows the test to find the widget by its unique key,
  /// which is useful when multiple widgets of the same type are present.
  ///
  /// The [version] argument is an optional integer that can be used to
  /// differentiate historical golden files.
  ///
  /// Set [waitForImages] to `false` if you want to skip waiting for all images
  /// to load before taking the snapshot. By default, it waits for all images to
  /// load.
  @isTest
  Future<void> expectGolden<T>(
    DeviceInfo deviceInfo, {
    String? prefix,
    String? suffix,
    String? title,
    String? path,
    Key? byKey,
    int? version,
    bool waitForImages = true,
    String rootPath = 'preview', // Path where we will generate our golden tests
    String Function(String)? pathBuilder,
  }) async {
    final enforcedTestPlatform = AdaptiveTestConfiguration.instance.enforcedTestPlatform;
    if (enforcedTestPlatform != null && !enforcedTestPlatform.isRuntimePlatform) {
      throw Exception('Runtime platform ${Platform.operatingSystem} is not ${enforcedTestPlatform.name}');
    }

    pathBuilder ??= (String rootPath) {
      final name =  ReCase('$T');
      final goldenTitle = (title?.isNotEmpty??false) ? title: name.snakeCase;
      final localPrefix = prefix != null ? "${ReCase(prefix).snakeCase}_" : '';
      final localSuffix = suffix != null ? "_${ReCase(suffix).snakeCase}" : '';
      return '$rootPath/${deviceInfo.name.replaceAll(' ', '_')}-$localPrefix$goldenTitle$localSuffix.png';
    };

    if (waitForImages) {
      await awaitImages();
    }

    await expectLater(
      // Find by its type except if the widget's unique key was given.
      byKey != null ? find.byKey(byKey) : find.byType(AdaptiveWrapper),
      matchesGoldenFile(path ?? pathBuilder.call(rootPath), version: version),
    );
  }
}
