import 'package:test/test.dart';

import 'package:motiontag_sdk/events/started_event.dart';

void main() {
  var event = StartedEvent();

  test('StartedEvent should be equal when same attributes', () {
    var newEvent = StartedEvent();
    expect(event, newEvent);
    expect(event.hashCode, newEvent.hashCode);
  });
}
