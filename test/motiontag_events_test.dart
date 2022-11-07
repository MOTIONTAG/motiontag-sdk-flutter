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

  test("should throw exception when parsing map without type key", () {
    expect(() => MotionTagEvent.parseMap({'other': 'OTHER'}),
        throwsA(TypeMatcher<ArgumentError>()));
  });

  test("should throw exception when parsing map with unknown type", () {
    expect(() => MotionTagEvent.parseMap({'type': 'UNKNOWN_TYPE'}),
        throwsA(TypeMatcher<ArgumentError>()));
  });

  test('should parse AUTO_START event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'AUTO_START'});
    expect(event, MotionTagEvent(MotionTagEventType.autoStart));
  });

  test('should parse AUTO_STOP event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'AUTO_STOP'});
    expect(event, MotionTagEvent(MotionTagEventType.autoStop));
  });

  test('should parse STARTED event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'STARTED'});
    expect(event, MotionTagEvent(MotionTagEventType.started));
  });

  test('should parse STOPPED event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'STOPPED'});
    expect(event, MotionTagEvent(MotionTagEventType.stopped));
  });

  test('should parse LOCATION event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'LOCATION'});
    expect(event, MotionTagEvent(MotionTagEventType.location));
  });

  test('should parse TRANSMISSION_SUCCESS event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'TRANSMISSION_SUCCESS'});
    expect(event, MotionTagEvent(MotionTagEventType.transmissionSuccess));
  });

  test('should parse TRANSMISSION_ERROR event from map', () {
    var event = MotionTagEvent.parseMap({'type': 'TRANSMISSION_ERROR'});
    expect(event, MotionTagEvent(MotionTagEventType.transmissionError));
  });
}