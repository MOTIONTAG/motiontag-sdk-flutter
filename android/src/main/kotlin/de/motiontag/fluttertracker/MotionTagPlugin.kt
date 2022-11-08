package de.motiontag.fluttertracker

import android.app.Application
import androidx.annotation.NonNull
import de.motiontag.tracker.Event
import de.motiontag.tracker.MotionTag

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MotionTagPlugin */
class MotionTagPlugin : FlutterPlugin, MethodCallHandler {

  private inner class Callback : MotionTag.Callback {
    override fun onEvent(event: Event) {
      channel.invokeMethod("onEvent", mapOf("type" to event.type.name))
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
