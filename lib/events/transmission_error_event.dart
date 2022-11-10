import 'package:flutter/foundation.dart';

import 'motiontag_event.dart';

@immutable
class TransmissionErrorEvent implements MotionTagEvent {
  @override
  final MotionTagEventType type = MotionTagEventType.transmissionError;
  final String error;

  TransmissionErrorEvent(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransmissionErrorEvent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          error == other.error;

  @override
  int get hashCode => type.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'TransmissionErrorEvent{type: $type, error: $error}';
  }
}
