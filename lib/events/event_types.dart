import 'package:flutter/foundation.dart';

@immutable
abstract class MotionTagEvent {
  abstract final MotionTagEventType type;
}

enum MotionTagEventType {
  /// Informs the application that tracking has been started.
  started,

  /// Informs the application that tracking has been stopped.
  stopped,

  /// Hands the latest captured device location to the application.
  location,

  /// Informs when a package of events has been successfully sent to the server.
  transmissionSuccess,

  /// Informs when a package of events failed to be transmitted to the server.
  transmissionError
}

extension MotionTagEventTypeId on MotionTagEventType {
  String get id {
    switch (this) {
      case MotionTagEventType.started:
        return 'STARTED';
      case MotionTagEventType.stopped:
        return 'STOPPED';
      case MotionTagEventType.location:
        return 'LOCATION';
      case MotionTagEventType.transmissionSuccess:
        return 'TRANSMISSION_SUCCESS';
      case MotionTagEventType.transmissionError:
        return 'TRANSMISSION_ERROR';
    }
  }
}

// TODO: Move to enum static function when min Dart version >= 2.17
MotionTagEventType? getMotionTagEventType(String id) {
  switch (id) {
    case 'STARTED':
      return MotionTagEventType.started;
    case 'STOPPED':
      return MotionTagEventType.stopped;
    case 'LOCATION':
      return MotionTagEventType.location;
    case 'TRANSMISSION_SUCCESS':
      return MotionTagEventType.transmissionSuccess;
    case 'TRANSMISSION_ERROR':
      return MotionTagEventType.transmissionError;
    default:
      return null;
  }
}
