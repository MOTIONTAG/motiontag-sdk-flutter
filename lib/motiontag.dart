import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MotionTagEventType {
  /// Informs the application that tracking has been **automatically** started.
  ///
  /// **Do not confuse it with [started], which is supported on both platforms.**
  ///
  /// See https://api.motion-tag.de/developer/android#3-6-automatic-start-stop
  ///
  /// **Android:** `de.motiontag.tracker.EventType.AUTO_START`\
  /// **iOS:** unmapped
  autoStart,

  /// Informs the application that tracking has been **automatically** stopped.
  ///
  /// **Do not confuse it with [stopped], which is supported on both platforms.**
  ///
  /// See https://api.motion-tag.de/developer/android#3-6-automatic-start-stop
  ///
  /// **Android:** `de.motiontag.tracker.EventType.AUTO_STOP`\
  /// **iOS:** unmapped
  autoStop,

  /// Informs the application that tracking has been started.
  ///
  /// **Do not confuse it with [autoStart], which is Android only.**
  ///
  /// **Android:** it is triggered by the wrapper library, on [autoStart] and if [MotionTag.start] actually started the
  /// tracking\
  /// **iOS:** `MotionTagDelegate.trackingStatusChanged()`, if `isTracking` is `true`
  started,

  /// Informs the application that tracking has been stopped.
  ///
  /// **Do not confuse it with [autoStop], which is Android only.**
  ///
  /// **Android:**  it is triggered by the wrapper library, on [autoStop] and if [MotionTag.stop] actually stopped the
  /// tracking\
  /// **iOS:** `MotionTagDelegate.trackingStatusChanged()`, if `isTracking` is `false`
  stopped,

  /// Hands the latest captured `android.location.Location` to the application.
  ///
  /// **Android:** `de.motiontag.tracker.EventType.LOCATION`\
  /// **iOS:** `MotionTagDelegate.didTrackLocation()`
  location,

  /// Informs when a package of events has been successfully sent to the server.
  ///
  /// **Android:** `de.motiontag.tracker.EventType.TRANSMISSION_SUCCESS`\
  /// **iOS:** `MotionTagDelegate.dataUploadWithTracked()`, if `error == nil`
  transmissionSuccess,

  /// Informs when a package of events failed to be transmitted to the server.
  ///
  /// **Android:** `de.motiontag.tracker.EventType.TRANSMISSION_ERROR`\
  /// **iOS:** `MotionTagDelegate.dataUploadWithTracked()`, if `error != nil`
  transmissionError
}

const _motionTagEventTypeFromString = <String, MotionTagEventType>{
  'AUTO_START': MotionTagEventType.autoStart,
  'AUTO_STOP': MotionTagEventType.autoStop,
  'STARTED': MotionTagEventType.started,
  'STOPPED': MotionTagEventType.stopped,
  'LOCATION': MotionTagEventType.location,
  'TRANSMISSION_SUCCESS': MotionTagEventType.transmissionSuccess,
  'TRANSMISSION_ERROR': MotionTagEventType.transmissionError,
};

@immutable
class MotionTagEvent {
  final MotionTagEventType type;

  MotionTagEvent(this.type);
  factory MotionTagEvent._parseMap(dynamic map) {
    final String typeString = map['type'];

    return MotionTagEvent(_motionTagEventTypeFromString[typeString]!);
  }
  @override
  String toString() => 'MotionTagEvent(type: ${type.name})';
}

class MotionTag {
  static final instance = MotionTag._();

  final MethodChannel _channel = const MethodChannel('motiontag');

  void Function(MotionTagEvent event)? _observer;

  MotionTag._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onEvent":
        final event = MotionTagEvent._parseMap(call.arguments);
        _observer?.call(event);

        // Simulate a MotionTagEventType.started event on Android to match the iOS behavior
        if (Platform.isAndroid && event.type == MotionTagEventType.autoStart) {
          _observer?.call(MotionTagEvent(MotionTagEventType.started));
        }
        // Simulate a MotionTagEventType.stopped event on Android to match the iOS behavior
        else if (Platform.isAndroid &&
            event.type == MotionTagEventType.autoStop) {
          _observer?.call(MotionTagEvent(MotionTagEventType.stopped));
        }
    }
  }

  void setObserver(void Function(MotionTagEvent event)? observer) =>
      _observer = observer;

  /// Retrieves the current user token or `null` if not specified yet.
  Future<String?> getUserToken() async {
    return await _channel.invokeMethod('getUserToken');
  }

  /// Updates the user JWT.
  ///
  /// The SDK expects this function to be called at least once before executing the [start] function. The provided token
  /// will be persisted internally.
  Future<void> setUserToken(String userToken) async {
    await _channel.invokeMethod('setUserToken', {'userToken': userToken});
  }

  /// Starts tracking.
  ///
  /// On Android it throws an IllegalStateException exception if no user token is specified. The callback submitted to
  /// [initialize] will be called to inform about SDK state changes or relevant tracking events.
  Future<void> start() async {
    final isTrackingActiveBefore = await isTrackingActive();

    await _channel.invokeMethod('start');

    // Simulate a MotionTagEventType.started event on Android to match the iOS behavior (MotionTagEventType.autoStart
    // would not occur in this case)
    if (Platform.isAndroid &&
        !isTrackingActiveBefore &&
        await isTrackingActive()) {
      _observer?.call(MotionTagEvent(MotionTagEventType.started));
    }
  }

  /// Stops tracking and removes the foreground notification.
  Future<void> stop() async {
    final isTrackingActiveBefore = await isTrackingActive();

    await _channel.invokeMethod('stop');

    // Simulate a MotionTagEventType.stopped event on Android to match the iOS behavior (MotionTagEventType.autoStop
    // would not occur in this case)
    if (Platform.isAndroid &&
        isTrackingActiveBefore &&
        !await isTrackingActive()) {
      _observer?.call(MotionTagEvent(MotionTagEventType.stopped));
    }
  }

  /// Stops tracking and deletes all stored user data from the SDK.
  Future<void> clearData() async {
    await _channel.invokeMethod('clearData');
  }

  /// Returns `true` if the tracking is active and collecting data, `false` otherwise.
  Future<bool> isTrackingActive() async {
    return await _channel.invokeMethod('isTrackingActive');
  }
}
