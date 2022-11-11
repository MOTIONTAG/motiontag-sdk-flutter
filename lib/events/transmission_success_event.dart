import 'package:flutter/foundation.dart';

import 'motiontag_event.dart';

@immutable
class TransmissionSuccessEvent implements MotionTagEvent {
  @override
  final MotionTagEventType type = MotionTagEventType.transmissionSuccess;
  final DateTime trackedFrom;
  final DateTime trackedTo;

  TransmissionSuccessEvent(
      {required this.trackedFrom, required this.trackedTo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransmissionSuccessEvent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          trackedFrom == other.trackedFrom &&
          trackedTo == other.trackedTo;

  @override
  int get hashCode => type.hashCode ^ trackedFrom.hashCode ^ trackedTo.hashCode;

  @override
  String toString() {
    return 'TransmissionSuccessEvent{type: $type, '
        'trackedFrom: $trackedFrom, '
        'trackedTo: $trackedTo}';
  }
}
