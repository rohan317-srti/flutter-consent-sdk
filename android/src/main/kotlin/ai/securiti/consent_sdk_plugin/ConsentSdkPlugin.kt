package ai.securiti.consent_sdk_plugin

import ai.securiti.cmpsdkcore.main.CmpSDKLoggerLevel
import ai.securiti.cmpsdkcore.main.CmpSDKOptions
import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ConsentSdkPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var wrapper: ConsentSDKWrapper? = null
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private val mainHandler = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "consent_sdk_plugin")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "ai.securiti.consent_sdk_plugin/isSDKReady")
    eventChannel.setStreamHandler(this)

    context = flutterPluginBinding.applicationContext

    if (wrapper == null) {
      wrapper = ConsentSDKWrapper()
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "setupSDK" -> {
        val arguments = call.arguments as Map<String, Any>

        val options = CmpSDKOptions(
          appURL = arguments["appURL"] as String,
          cdnURL = arguments["cdnURL"] as String,
          tenantID = arguments["tenantID"] as String,
          appID = arguments["appID"] as String,
          testingMode = arguments["testingMode"] as Boolean,
          loggerLevel = CmpSDKLoggerLevel.DEBUG,
          consentsCheckInterval = arguments["consentsCheckInterval"] as Int,
          subjectId = arguments["subjectId"] as String?,
          languageCode = arguments["languageCode"] as String?,
          locationCode = arguments["locationCode"] as String?
        )
        setupSDK(options)

        // Wrap the SDK ready callback in a main thread dispatch
        wrapper?.isReady { isReady ->
          mainHandler.post {
            eventSink?.success(isReady)
          }
        }
        result.success(null)
      }
      "presentPreferenceCenter" -> {
        mainHandler.post {
          presentPreferenceCenter()
        }
        result.success(null)
      }
      "presentConsentBanner" -> {
        mainHandler.post {
          presentConsentBanner()
        }
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun setupSDK(options: CmpSDKOptions) {
    activity.let {
      wrapper?.initialize(it.application, options)
    }
  }

  private fun presentConsentBanner() {
    activity.let { activity ->
      if (activity !is FlutterFragmentActivity) {
        Log.e("ConsentSdkPlugin", "Cannot show banner: Activity must be FlutterFragmentActivity")
        return
      }
      wrapper?.presentConsentBanner(activity)
    }
  }

  private fun presentPreferenceCenter() {
    activity.let { activity ->
      if (activity !is FlutterFragmentActivity) {
        Log.e("ConsentSdkPlugin", "Cannot show preferences: Activity must be FlutterFragmentActivity")
        return
      }
      wrapper?.presentPreferenceCenter(activity)
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onDetachedFromActivity() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }
  override fun onDetachedFromActivityForConfigChanges() {}
}