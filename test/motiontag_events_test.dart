import 'package:test/test.dart';

import 'package:motiontag/motiontag_events.dart';

void main() {
  test('events with same types should be equal', () {
    expect(
        MotionTagEvent(MotionTagEventType.started) ==
            MotionTagEvent(MotionTagEventType.started),
        true);
  });

  test('events with different types should not be equal', () {
    expect(
        MotionTagEvent(MotionTagEventType.started) ==
            MotionTagEvent(MotionTagEventType.stopped),
        false);
  });

  test('should parse event from map with known type', () {
    var event = MotionTagEvent.parseMap({'type': 'AUTO_STOP'});
    expect(event, MotionTagEvent(MotionTagEventType.autoStop));
  });

  test("should throw exception when parsing map without type key", () {
    expect(() => MotionTagEvent.parseMap({'other': 'OTHER'}),
        throwsA(TypeMatcher<ArgumentError>()));
  });

  test("should throw exception when parsing map with unknown type", () {
    expect(() => MotionTagEvent.parseMap({'type': 'UNKNOWN_TYPE'}),
        throwsA(TypeMatcher<ArgumentError>()));
  });
}
