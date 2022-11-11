import 'package:test/test.dart';

import 'package:motiontag_sdk/events/location_event.dart';

void main() {
  var timestamp = DateTime.fromMillisecondsSinceEpoch(1000);
  var event = LocationEvent(
      timestamp: timestamp,
      latitude: 52.5,
      longitude: 36.8,
      horizontalAccuracy: 10,
      speed: 78.5,
      altitude: 1300.19,
      bearing: 50);

  test('LocationEvent should be equal when same attributes', () {
    var newEvent = LocationEvent(
        timestamp: timestamp,
        latitude: 52.5,
        longitude: 36.8,
        horizontalAccuracy: 10,
        speed: 78.5,
        altitude: 1300.19,
        bearing: 50);
    expect(event, newEvent);
    expect(event.hashCode, newEvent.hashCode);
  });
}
