
import 'consent_sdk_plugin_platform_interface.dart';

class ConsentSdkPlugin {
  Future<String?> getPlatformVersion() {
    return ConsentSdkPluginPlatform.instance.getPlatformVersion();
  }

  void setupSDK(Map options) {
    ConsentSdkPluginPlatform.instance.setupSDK(options);
  }

  void presentPreferenceCenter() {
    ConsentSdkPluginPlatform.instance.presentPreferenceCenter();
  }

  void presentConsentBanner() {
    ConsentSdkPluginPlatform.instance.presentConsentBanner();
  }
}
