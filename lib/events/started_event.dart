import 'package:flutter/foundation.dart';

import 'motiontag_event.dart';

@immutable
class StartedEvent implements MotionTagEvent {
  @override
  final MotionTagEventType type = MotionTagEventType.started;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartedEvent &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() {
    return 'StartedEvent{type: $type}';
  }
}
