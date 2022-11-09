import 'package:flutter/foundation.dart';

import 'event_types.dart';

@immutable
class StoppedEvent implements MotionTagEvent {
  @override
  final MotionTagEventType type = MotionTagEventType.stopped;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoppedEvent &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() {
    return 'StoppedEvent{type: $type}';
  }
}
