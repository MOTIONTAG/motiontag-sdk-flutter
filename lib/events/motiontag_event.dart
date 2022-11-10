import 'package:flutter/foundation.dart';

@immutable
abstract class MotionTagEvent {
  abstract final MotionTagEventType type;
}

enum MotionTagEventType {
  /// Informs the application that tracking has been started.
  started('STARTED'),

  /// Informs the application that tracking has been stopped.
  stopped('STOPPED'),

  /// Hands the latest captured device location to the application.
  location('LOCATION'),

  /// Informs when a package of events has been successfully sent to the server.
  transmissionSuccess('TRANSMISSION_SUCCESS'),

  /// Informs when a package of events failed to be transmitted to the server.
  transmissionError('TRANSMISSION_ERROR');

  final String id;

  const MotionTagEventType(this.id);

  static MotionTagEventType? getById(String id) {
    for (MotionTagEventType eventType in MotionTagEventType.values) {
      if (eventType.id == id) {
        return eventType;
      }
    }
    return null;
  }
}
