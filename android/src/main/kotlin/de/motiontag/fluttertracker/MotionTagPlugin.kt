package de.motiontag.fluttertracker

import android.app.Application
import android.location.Location
import androidx.annotation.NonNull
import de.motiontag.tracker.AutoStartEvent
import de.motiontag.tracker.AutoStopEvent
import de.motiontag.tracker.BatteryOptimizationsChangedEvent
import de.motiontag.tracker.Event
import de.motiontag.tracker.LocationEvent
import de.motiontag.tracker.MotionTag
import de.motiontag.tracker.PowerSaveModeChangedEvent
import de.motiontag.tracker.TransmissionEvent
import de.motiontag.tracker.BeaconScanEvent

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

// TODO: Add unit tests
class MotionTagPlugin : FlutterPlugin, MethodCallHandler {

    private inner class Callback : MotionTag.Callback {
        override fun onEvent(event: Event) {
            when (event) {
                is AutoStartEvent -> {
                    val map = mapOf("type" to "STARTED")
                    invokeOnEventWith(map)
                }
                is AutoStopEvent -> {
                    val map = mapOf("type" to "STOPPED")
                    invokeOnEventWith(map)
                }
                is LocationEvent -> {
                    val loc = event.location
                    val map = buildMap<String, Any> {
                        put("type", "LOCATION")
                        put("timestamp", loc.time)
                        put("latitude", loc.latitude)
                        put("longitude", loc.longitude)
                        put("horizontalAccuracy", loc.accuracy)
                        if (loc.hasSpeed()) put("speed", loc.speed)
                        if (loc.hasAltitude()) put("altitude", loc.altitude)
                        if (loc.hasBearing()) put("bearing", loc.bearing)
                    }
                    invokeOnEventWith(map)
                }
                is TransmissionEvent.Success -> {
                    val map = mapOf(
                        "type" to "TRANSMISSION_SUCCESS",
                        "trackedFrom" to event.trackedFrom,
                        "trackedTo" to event.trackedTo,
                    )
                    invokeOnEventWith(map)
                }
                is TransmissionEvent.Error ->  {
                    val map = mapOf(
                        "type" to "TRANSMISSION_ERROR",
                        "error" to "${event.errorCode} - ${event.errorMessage}",
                    )
                    invokeOnEventWith(map)
                }
                is BatteryOptimizationsChangedEvent -> {}
                is PowerSaveModeChangedEvent -> {}
                is BeaconScanEvent -> {}
            }
        }

        private fun invokeOnEventWith(map: Map<String, Any>) {
            channel.invokeMethod("onEvent", map)
        }
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var app: Application

    private val motionTag = MotionTag.getInstance()
    private val motionTagCallback = Callback()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "de.motiontag.tracker")
        channel.setMethodCallHandler(this)
        app = flutterPluginBinding.applicationContext as Application
        MotionTagCallbackDelegate.register(motionTagCallback)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        MotionTagCallbackDelegate.unregister(motionTagCallback)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            when (call.method) {
                "getUserToken" -> {
                    val userToken = motionTag.userToken
                    result.success(userToken)
                }
                "setUserToken" -> {
                    motionTag.userToken = call.argument<String?>("userToken")
                    result.success(null)
                }
                "start" -> {
                    motionTag.start()
                    result.success(null)
                }
                "stop" -> {
                    motionTag.stop()
                    result.success(null)
                }
                "clearData" -> {
                    motionTag.clearData {
                        result.success(null)
                    }
                }
                "isTrackingActive" -> {
                    val isTrackingActive = motionTag.isTrackingActive
                    result.success(isTrackingActive)
                }
                else -> result.notImplemented()
            }
        } catch (error: Error) {
            result.error("UNKNOWN", error.message, error)
        }
    }
}
