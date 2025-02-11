package ai.securiti.consent_sdk_plugin

import ai.securiti.cmpsdkcore.main.*
import ai.securiti.cmpsdkcore.network.models.common.*
import ai.securiti.cmpsdkcore.network.models.request.PostConsentsRequest
import ai.securiti.cmpsdkcore.ui.SecuritiMobileCmpExtensions.Companion.presentConsentBanner
import ai.securiti.cmpsdkcore.ui.SecuritiMobileCmpExtensions.Companion.presentPreferenceCenter
import android.app.Activity
import android.app.Application
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.whenStateAtLeast
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ConsentSDKWrapper {

    private val scope = CoroutineScope(Dispatchers.IO)

    private var currentActivity: Activity? = null

    fun initialize(application: Application, options: CmpSDKOptions) {
        SecuritiMobileCmp.initialize(application, options)
    }

    fun getConsent(purposeId: Int, callback: (ConsentStatus) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getConsent(purposeId)
            callback(result)
        }
    }

    fun getConsent(permissionId: String, callback: (ConsentStatus) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getConsent(permissionId)
            callback(result)
        }
    }

    fun getPermissions(callback: (ArrayList<AppPermission>) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getPermissions()
            callback(result)
        }
    }

    fun getPurposes(callback: (ArrayList<Purpose>) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getPurposes()
            callback(result)
        }
    }

    fun getSdksInPurpose(purposeId: Int, callback: (List<Any>) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getSdksInPurpose(purposeId)
            callback(result)
        }
    }

    fun setConsent(purpose: Purpose, consent: ConsentStatus) {
        SecuritiMobileCmp.setConsent(purpose, consent)
    }

    fun setConsent(appPermission: AppPermission, consent: ConsentStatus) {
        SecuritiMobileCmp.setConsent(appPermission, consent)
    }

    fun resetConsents() {
        SecuritiMobileCmp.resetConsents()
    }

    fun addListener(listener: ConsentSdkListener) {
        SecuritiMobileCmp.addListener(listener)
    }

    fun isReady(callback: (Boolean) -> Unit) {
        SecuritiMobileCmp.isReady {
            try {
                Log.d("customTag", "from Wrapper: value: ${it}")
            } catch (e: Exception) {
                Log.d("customTag", "from Module: error: ${e.message}")
            }
            callback.invoke(it)
        }
    }

    fun isReady(): Boolean {
        return SecuritiMobileCmp.isReady()
    }

    fun getBannerConfig(cdn: MainConfiguration? = null, callback: (BannerConfig?) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getBannerConfig(cdn)
            callback(result)
        }
    }

    fun options(): CmpSDKOptions? {
        return SecuritiMobileCmp.options()
    }

    fun getSettingsPrompt(callback: (SettingsPrompt?) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.getSettingsPrompt()
            callback(result)
        }
    }

    fun uploadConsents(request: PostConsentsRequest, callback: (Boolean) -> Unit) {
        scope.launch {
            val result = SecuritiMobileCmp.uploadConsents(request)
            callback(result)
        }
    }
//
//    fun presentPreferenceCenter(activity: Activity?) {
//        if (activity != null) {
//            SecuritiMobileCmp.presentPreferenceCenter(activity)
//        }
//    }
//
//    fun presentConsentBanner(activity: Activity?) {
//        if (activity != null) {
//            SecuritiMobileCmp.presentConsentBanner(activity)
//        }
//    }

    fun presentConsentBanner(activity: Activity) {
        // Ensure we have a ComponentActivity
        if (activity !is ComponentActivity) {
            Log.e("ConsentSDKWrapper", "Activity must be ComponentActivity")
            return
        }

        // Store current activity reference
        currentActivity = activity

        // Use activity's lifecycle scope
        (activity as ComponentActivity).lifecycleScope.launch(Dispatchers.Main) {
            activity.lifecycle.whenStateAtLeast(Lifecycle.State.RESUMED) {
                try {
                    // Call the library function
                    SecuritiMobileCmp.presentConsentBanner(activity)
                } catch (e: Exception) {
                    Log.e("ConsentSDKWrapper", "Error showing consent banner", e)
                }
            }
        }
    }

    fun presentPreferenceCenter(activity: Activity) {
        if (activity !is ComponentActivity) {
            Log.e("ConsentSDKWrapper", "Activity must be ComponentActivity")
            return
        }

        currentActivity = activity

        (activity as ComponentActivity).lifecycleScope.launch(Dispatchers.Main) {
            activity.lifecycle.whenStateAtLeast(Lifecycle.State.RESUMED) {
                try {
                    SecuritiMobileCmp.presentPreferenceCenter(activity)
                } catch (e: Exception) {
                    Log.e("ConsentSDKWrapper", "Error showing preference center", e)
                }
            }
        }
    }
}