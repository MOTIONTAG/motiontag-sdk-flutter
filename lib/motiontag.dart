import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:motiontag_sdk/motiontag_events.dart';

// TODO: Update method description comments
class MotionTag {
  static final instance = MotionTag._();

  final MethodChannel _channel = const MethodChannel('de.motiontag.tracker');
  void Function(MotionTagEvent event)? _observer;
  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  MotionTag._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// Registers observer to receive [MotionTagEvent]
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
  /// The callback submitted to [initialize] will be called to inform about SDK state changes or relevant tracking events.
  Future<void> start() async {
    final isTrackingActiveBefore = await isTrackingActive();

    await _channel.invokeMethod('start');

    // Simulate a MotionTagEventType.started event on Android to match the iOS behavior (MotionTagEventType.autoStart
    // would not occur in this case)
    if (_isAndroid && !isTrackingActiveBefore && await isTrackingActive()) {
      _observer?.call(MotionTagEvent(MotionTagEventType.started));
    }
  }

  /// Stops tracking and removes the foreground notification.
  Future<void> stop() async {
    final isTrackingActiveBefore = await isTrackingActive();

    await _channel.invokeMethod('stop');

    // Simulate a MotionTagEventType.stopped event on Android to match the iOS behavior (MotionTagEventType.autoStop
    // would not occur in this case)
    if (_isAndroid && isTrackingActiveBefore && !await isTrackingActive()) {
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

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onEvent":
        final event = MotionTagEvent.parseMap(call.arguments);
        if (event == null) return;
        _observer?.call(event);

        // Simulate a MotionTagEventType.started event on Android to match the iOS behavior
        if (_isAndroid && event.type == MotionTagEventType.autoStart) {
          _observer?.call(MotionTagEvent(MotionTagEventType.started));
        }
        // Simulate a MotionTagEventType.stopped event on Android to match the iOS behavior
        else if (_isAndroid && event.type == MotionTagEventType.autoStop) {
          _observer?.call(MotionTagEvent(MotionTagEventType.stopped));
        }
    }
  }
}
