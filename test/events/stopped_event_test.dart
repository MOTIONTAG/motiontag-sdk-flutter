import 'package:test/test.dart';

import 'package:motiontag_sdk/events/stopped_event.dart';

void main() {
  var event = StoppedEvent();

  test('StoppedEvent should be equal when same attributes', () {
    var newEvent = StoppedEvent();
    expect(event, newEvent);
    expect(event.hashCode, newEvent.hashCode);
  });
}
