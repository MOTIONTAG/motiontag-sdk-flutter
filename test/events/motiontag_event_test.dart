import 'package:test/test.dart';

import 'package:motiontag_sdk/events/motiontag_event.dart';

void main() {
  group('type id', () {
    test('should be correct for MotionTagEventType.started', () {
      expect(MotionTagEventType.started.id, 'STARTED');
    });

    test('should be correct for  MotionTagEventType.stopped', () {
      expect(MotionTagEventType.stopped.id, 'STOPPED');
    });

    test('should be correct for MotionTagEventType.location', () {
      expect(MotionTagEventType.location.id, 'LOCATION');
    });

    test('should be correct for MotionTagEventType.transmissionSuccess', () {
      expect(MotionTagEventType.transmissionSuccess.id, 'TRANSMISSION_SUCCESS');
    });

    test('should be correct for MotionTagEventType.transmissionError', () {
      expect(MotionTagEventType.transmissionError.id, 'TRANSMISSION_ERROR');
    });
  });

  group('getting type', () {
    test('with INVALID id should return null', () {
      expect(MotionTagEventType.getById('INVALID'), null);
    });

    test('with STARTED id should return instance', () {
      expect(MotionTagEventType.getById('STARTED'), MotionTagEventType.started);
    });

    test('with STOPPED id should return instance', () {
      expect(MotionTagEventType.getById('STOPPED'), MotionTagEventType.stopped);
    });

    test('with LOCATION id should return instance', () {
      expect(
          MotionTagEventType.getById('LOCATION'), MotionTagEventType.location);
    });

    test('with TRANSMISSION_SUCCESS id should return instance', () {
      expect(MotionTagEventType.getById('TRANSMISSION_SUCCESS'),
          MotionTagEventType.transmissionSuccess);
    });

    test('with TRANSMISSION_ERROR should return instance', () {
      expect(MotionTagEventType.getById('TRANSMISSION_ERROR'),
          MotionTagEventType.transmissionError);
    });
  });
}
