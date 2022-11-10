import 'package:test/test.dart';

import 'package:motiontag_sdk/events/transmission_success_event.dart';

void main() {
  var trackedFrom = DateTime.fromMillisecondsSinceEpoch(1000);
  var trackedTo = DateTime.fromMillisecondsSinceEpoch(1000);
  var event =
      TransmissionSuccessEvent(trackedFrom: trackedFrom, trackedTo: trackedTo);

  test('TransmissionSuccessEvent should be equal when same attributes', () {
    var newEvent = TransmissionSuccessEvent(
        trackedFrom: trackedFrom, trackedTo: trackedTo);
    expect(event, newEvent);
    expect(event.hashCode, newEvent.hashCode);
  });
}
