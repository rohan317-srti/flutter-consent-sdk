import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'consent_sdk_plugin_platform_interface.dart';
import 'cmp_sdk_options.dart';

/// An implementation of [ConsentSdkPluginPlatform] that uses method channels.
class MethodChannelConsentSdkPlugin extends ConsentSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('consent_sdk_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void setupSDK(Map options) {
    methodChannel.invokeMethod<void>('setupSDK', options);
  }

  @override
  void presentConsentBanner() {
    methodChannel.invokeMethod<void>('presentConsentBanner');
  }

  @override
  void presentPreferenceCenter() {
    methodChannel.invokeMethod<void>('presentPreferenceCenter');
  }
}
