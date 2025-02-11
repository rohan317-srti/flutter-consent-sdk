import 'package:flutter_test/flutter_test.dart';
import 'package:consent_sdk_plugin/consent_sdk_plugin.dart';
import 'package:consent_sdk_plugin/consent_sdk_plugin_platform_interface.dart';
import 'package:consent_sdk_plugin/consent_sdk_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockConsentSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements ConsentSdkPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void setupSDK(Map<dynamic, dynamic> options) {
    // Mock implementation
  }

  @override
  Future<void> presentConsentBanner() async {
    // Mock implementation
  }

  @override
  Future<void> presentPreferenceCenter() async {
    // Mock implementation
  }
}

void main() {
  final ConsentSdkPluginPlatform initialPlatform = ConsentSdkPluginPlatform.instance;

  test('$MethodChannelConsentSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelConsentSdkPlugin>());
  });

  test('getPlatformVersion', () async {
    ConsentSdkPlugin consentSdkPlugin = ConsentSdkPlugin();
    MockConsentSdkPluginPlatform fakePlatform = MockConsentSdkPluginPlatform();
    ConsentSdkPluginPlatform.instance = fakePlatform;

    expect(await consentSdkPlugin.getPlatformVersion(), '42');
  });
}
