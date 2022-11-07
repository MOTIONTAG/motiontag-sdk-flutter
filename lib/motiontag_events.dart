import 'package:flutter/material.dart';

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

  factory MotionTagEvent.parseMap(dynamic map) {
    final String typeString = map['type'];
    var event = _motionTagEventTypeFromString[typeString];
    if (event == null) {
      throw Exception('Could not parse unknown $typeString event');
    }
    return MotionTagEvent(event);
  }

  @override
  String toString() => 'MotionTagEvent(type: ${type.name})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotionTagEvent &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}
