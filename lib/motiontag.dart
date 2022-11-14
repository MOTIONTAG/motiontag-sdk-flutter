import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'events/motiontag_event.dart';
import 'events/location_event.dart';
import 'events/started_event.dart';
import 'events/stopped_event.dart';
import 'events/transmission_error_event.dart';
import 'events/transmission_success_event.dart';

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

  /// Retrieves the current user token (JWT) or `null` if not specified yet.
  Future<String?> getUserToken() async {
    return await _channel.invokeMethod('getUserToken');
  }

  /// Updates the user token (JWT).
  ///
  /// The SDK expects this function to be called before executing the [start] function, otherwise the collected data won't be able to be transmitted.
  Future<void> setUserToken(String userToken) async {
    await _channel.invokeMethod('setUserToken', {'userToken': userToken});
  }

  /// Starts tracking.
  Future<void> start() async {
    final isTrackingActiveBefore = await isTrackingActive();
    await _channel.invokeMethod('start');

    // Simulate a [StartedEvent] event on Android to match the iOS behavior
    if (_isAndroid && !isTrackingActiveBefore) {
      _observer?.call(StartedEvent());
    }
  }

  /// Stops tracking.
  Future<void> stop() async {
    final isTrackingActiveBefore = await isTrackingActive();
    await _channel.invokeMethod('stop');

    // Simulate a [StoppedEvent] event on Android to match the iOS behavior
    if (_isAndroid && isTrackingActiveBefore) {
      _observer?.call(StoppedEvent());
    }
  }

  /// Deletes all stored user data from the SDK.
  Future<void> clearData() async {
    await _channel.invokeMethod('clearData');
  }

  /// Returns `true` if the tracking is active and collecting data, `false` otherwise.
  Future<bool> isTrackingActive() async {
    return await _channel.invokeMethod('isTrackingActive');
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onEvent':
        _processOnEvent(call.arguments);
        break;
    }
  }

  void _processOnEvent(dynamic arguments) {
    var eventType = MotionTagEventType.getById(arguments['type']);
    if (eventType == null) return;
    switch (eventType) {
      case MotionTagEventType.started:
        _processStartedEvent(arguments);
        break;
      case MotionTagEventType.stopped:
        _processStoppedEvent(arguments);
        break;
      case MotionTagEventType.location:
        _processLocationEvent(arguments);
        break;
      case MotionTagEventType.transmissionSuccess:
        _processTransmissionSuccessEvent(arguments);
        break;
      case MotionTagEventType.transmissionError:
        _processTransmissionErrorEvent(arguments);
        break;
    }
  }

  void _processStartedEvent(dynamic arguments) {
    var event = StartedEvent();
    _observer?.call(event);
  }

  void _processStoppedEvent(dynamic arguments) {
    var event = StoppedEvent();
    _observer?.call(event);
  }

  void _processLocationEvent(dynamic arguments) {
    var timestamp = arguments['timestamp'];
    var event = LocationEvent(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        latitude: arguments['latitude'],
        longitude: arguments['longitude'],
        horizontalAccuracy: arguments['horizontalAccuracy'],
        speed: arguments['speed'],
        altitude: arguments['altitude'],
        bearing: arguments['bearing']);
    _observer?.call(event);
  }

  void _processTransmissionSuccessEvent(dynamic arguments) {
    var trackedFrom = arguments['trackedFrom'];
    var trackedTo = arguments['trackedTo'];
    var event = TransmissionSuccessEvent(
        trackedFrom: DateTime.fromMillisecondsSinceEpoch(trackedFrom),
        trackedTo: DateTime.fromMillisecondsSinceEpoch(trackedTo));
    _observer?.call(event);
  }

  void _processTransmissionErrorEvent(dynamic arguments) {
    var event = TransmissionErrorEvent(arguments['error']);
    _observer?.call(event);
  }
}
