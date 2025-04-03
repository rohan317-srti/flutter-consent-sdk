import Flutter
import UIKit
import ConsentUI

public class ConsentSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "consent_sdk_plugin", binaryMessenger: registrar.messenger())
    let instance = ConsentSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

      let eventchannel = FlutterEventChannel(name: "ai.securiti.consent_sdk_plugin/isSDKReady", binaryMessenger: registrar.messenger())
      eventchannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
      case "setupSDK":
          if let arguments = call.arguments as? [String:Any] {
              if let appUrl = arguments["appURL"] as? String, let cdnUrl = arguments["cdnURL"] as? String, let tenantId = arguments["tenantID"] as? String, let appId = arguments["appID"] as? String, let testingMode = arguments["testingMode"] as? Bool, let consentsCheckInterval = arguments["consentsCheckInterval"] as? Int {
                  let options = ConsentSDKOptions(
                    appUrl: appUrl,
                    cdnUrl: cdnUrl,
                    tenantId: tenantId,
                    appId: appId,
                    testingMode: testingMode,
                    logLevel: .debug,
                    consentsCheckInterval: consentsCheckInterval,
                    subjectId: arguments["subjectId"] as? String,
                    languageCode: arguments["languageCode"] as? String,
                    locationCode: arguments["locationCode"] as? String
                  )
                  ConsentSDK.shared.setupSDK(options: options)
              }
              
          }
          ConsentSDK.shared.isReady() { state in
              if self.eventSink != nil {
                  self.eventSink!(state == .available)
              }
          }
          result("")
      case "presentPreferenceCenter":
          ConsentSDK.shared.presentPreferenceCenter()
          result("")
      case "presentConsentBanner":
          ConsentSDK.shared.presentConsentBanner()
          result("")
      default:
          result(FlutterMethodNotImplemented)
      }
  }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
