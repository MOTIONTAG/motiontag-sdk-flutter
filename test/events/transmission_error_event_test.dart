import 'package:test/test.dart';

import 'package:motiontag_sdk/events/transmission_error_event.dart';

void main() {
  var event = TransmissionErrorEvent("some_error");

  test('TransmissionErrorEvent should be equal when same attributes', () {
    var newEvent = TransmissionErrorEvent("some_error");
    expect(event, newEvent);
    expect(event.hashCode, newEvent.hashCode);
  });
}
