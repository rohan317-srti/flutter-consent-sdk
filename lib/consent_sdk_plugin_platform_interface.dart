import 'package:consent_sdk_plugin/cmp_sdk_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'consent_sdk_plugin_method_channel.dart';

abstract class ConsentSdkPluginPlatform extends PlatformInterface {
  /// Constructs a ConsentSdkPluginPlatform.
  ConsentSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ConsentSdkPluginPlatform _instance = MethodChannelConsentSdkPlugin();

  /// The default instance of [ConsentSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelConsentSdkPlugin].
  static ConsentSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ConsentSdkPluginPlatform] when
  /// they register themselves.
  static set instance(ConsentSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void setupSDK(Map options) {
    throw UnimplementedError('setupSDK() has not been implemented.');
  }

  void presentConsentBanner() {
    throw UnimplementedError('presentConsentBanner() has not been implemented.');
  }

  void presentPreferenceCenter() {
    throw UnimplementedError('presentPreferenceCenter() has not been implemented.');
  }


}
