import 'package:flutter/foundation.dart';

import 'event_types.dart';

@immutable
class LocationEvent implements MotionTagEvent {
  @override
  final MotionTagEventType type = MotionTagEventType.location;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double horizontalAccuracy;
  final double? speed;
  final double? altitude;
  final double? bearing;

  LocationEvent(
      {required this.timestamp,
      required this.latitude,
      required this.longitude,
      required this.horizontalAccuracy,
      this.speed,
      this.altitude,
      this.bearing});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEvent &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          timestamp == other.timestamp &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          horizontalAccuracy == other.horizontalAccuracy &&
          speed == other.speed &&
          altitude == other.altitude &&
          bearing == other.bearing;

  @override
  int get hashCode =>
      type.hashCode ^
      timestamp.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      horizontalAccuracy.hashCode ^
      speed.hashCode ^
      altitude.hashCode ^
      bearing.hashCode;

  @override
  String toString() {
    return 'LocationEvent{type: $type, '
        'timestamp: $timestamp, '
        'latitude: $latitude, '
        'longitude: $longitude, '
        'horizontalAccuracy: $horizontalAccuracy, '
        'speed: $speed, '
        'altitude: $altitude, '
        'bearing: $bearing}';
  }
}
