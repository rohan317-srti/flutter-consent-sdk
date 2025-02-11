import 'package:consent_sdk_plugin/cmp_sdk_options.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:consent_sdk_plugin/consent_sdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  static const EventChannel _eventChannel = EventChannel('ai.securiti.consent_sdk_plugin/isSDKReady');
  final _consentSdkPlugin = ConsentSdkPlugin();
  bool _isSDKReady = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    CmpSDKOptions options = CmpSDKOptions()
        ..appURL = "https://dev-intg-2.securiti.xyz"
        ..cdnURL =  "https://cdn-dev-intg-2.securiti.xyz/consent"
        ..tenantID = "d525a59e-896e-4a85-ad1a-84921e9acce0"
        ..appID = "175f4dbd-ba1c-4821-9792-d5cc29237db2"
        ..testingMode = true
        ..loggerLevel = "DEBUG"
        ..consentsCheckInterval = 1800
        ..subjectId = "subject123"
        ..languageCode = "en"
        ..locationCode = "PK";  

    _consentSdkPlugin.setupSDK(options.toMap());
    _eventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _isSDKReady = event as bool;
        if (_isSDKReady) {
            _consentSdkPlugin.presentConsentBanner();
        }
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _consentSdkPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Securiti\'s SDK is ${_isSDKReady ? "ready" : "not ready"}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _consentSdkPlugin.presentPreferenceCenter();
                },
                child: Text('Open Preference Center'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
