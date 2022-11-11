import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motiontag_sdk/events/location_event.dart';
import 'package:motiontag_sdk/events/motiontag_event.dart';
import 'package:motiontag_sdk/events/started_event.dart';
import 'package:motiontag_sdk/events/stopped_event.dart';
import 'package:motiontag_sdk/events/transmission_error_event.dart';
import 'package:motiontag_sdk/events/transmission_success_event.dart';
import 'package:motiontag_sdk/motiontag.dart';

import 'channel_mock.dart';

void main() {
  final defaultTimeout = Timeout(Duration(seconds: 5));
  final channelMock = ChannelMock('de.motiontag.tracker');
  var motionTag = MotionTag.instance;

  setUp(() {
    channelMock.reset();
    channelMock.registerCallHandler();
  });

  tearDown(() {
    channelMock.unregisterCallHandler();
  });

  group('calling getUserToken method', () {
    testWidgets('should return value using channel', (tester) async {
      channelMock.mockMethod('getUserToken', returnValues: ['some_user_token']);

      final userToken = await motionTag.getUserToken();

      var calls = channelMock.methodCalls;
      expect(calls.length, 1);
      expect(calls.first.method, 'getUserToken');
      expect(userToken, 'some_user_token');
    }, timeout: defaultTimeout);
  });

  group('calling setUserToken method', () {
    testWidgets('should set value using channel', (tester) async {
      channelMock.mockMethod('setUserToken');

      await motionTag.setUserToken('new_user_token');

      var calls = channelMock.methodCalls;
      expect(calls.length, 1);
      expect(calls.first.method, 'setUserToken');
      expect(calls.first.arguments['userToken'], 'new_user_token');
    }, timeout: defaultTimeout);
  });

  group('calling start method', () {
    testWidgets('should use channel', (tester) async {
      channelMock.mockMethod('isTrackingActive', returnValues: [true]);
      channelMock.mockMethod('start');

      await motionTag.start();

      var calls = channelMock.methodCalls;
      expect(calls.length, 2);
      expect(calls.first.method, 'isTrackingActive');
      expect(calls.last.method, 'start');
    }, timeout: defaultTimeout);

    testWidgets('should callback event if was not active and is Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      channelMock.mockMethod('isTrackingActive', returnValues: [false, true]);
      channelMock.mockMethod('start');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.start();

      expect(events.length, 1);
      expect(events.first.type, MotionTagEventType.started);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);

    testWidgets(
        'should not callback event if was not active and is not Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      channelMock.mockMethod('isTrackingActive', returnValues: [false, true]);
      channelMock.mockMethod('start');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.start();

      expect(events.length, 0);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);

    testWidgets('should not callback event if was active and is Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      channelMock.mockMethod('isTrackingActive', returnValues: [true, false]);
      channelMock.mockMethod('start');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.start();

      expect(events.length, 0);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);
  });

  group('calling stop method', () {
    testWidgets('should callback event if was active and is Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      channelMock.mockMethod('isTrackingActive', returnValues: [true, false]);
      channelMock.mockMethod('stop');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.stop();

      expect(events.length, 1);
      expect(events.first.type, MotionTagEventType.stopped);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);

    testWidgets('should not callback event if was active and is not Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      channelMock.mockMethod('isTrackingActive', returnValues: [true, false]);
      channelMock.mockMethod('stop');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.stop();

      expect(events.length, 0);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);

    testWidgets('should not callback event if was not active and is Android',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      channelMock.mockMethod('isTrackingActive', returnValues: [false, true]);
      channelMock.mockMethod('stop');

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      await motionTag.stop();

      expect(events.length, 0);
      debugDefaultTargetPlatformOverride = null;
    }, timeout: defaultTimeout);
  });

  group('calling clearData method', () {
    testWidgets('should use channel', (tester) async {
      channelMock.mockMethod('clearData');

      await motionTag.clearData();

      var calls = channelMock.methodCalls;
      expect(calls.length, 1);
      expect(calls.first.method, 'clearData');
    }, timeout: defaultTimeout);
  });

  group('calling isTrackingActive method', () {
    testWidgets('should return value using channel', (tester) async {
      channelMock.mockMethod('isTrackingActive', returnValues: [true]);

      final isTrackingActive = await motionTag.isTrackingActive();

      var calls = channelMock.methodCalls;
      expect(calls.length, 1);
      expect(calls.first.method, 'isTrackingActive');
      expect(isTrackingActive, true);
    }, timeout: defaultTimeout);
  });

  group('onEvent invocation with', () {
    testWidgets('unknown type should not call registered observer',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent", arguments: {'type': 'UNKNOWN'});

      expect(events.length, 0);
    }, timeout: defaultTimeout);

    testWidgets('STARTED type should call registered observert',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent", arguments: {'type': 'STARTED'});

      expect(events.length, 1);
      expect(events.first, StartedEvent());
    }, timeout: defaultTimeout);

    testWidgets('STOPPED type should call registered observer ',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent", arguments: {'type': 'STOPPED'});

      expect(events.length, 1);
      expect(events.last, StoppedEvent());
    }, timeout: defaultTimeout);

    testWidgets('TRANSMISSION_SUCCESS type should call registered observer',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent", arguments: {
        'type': 'TRANSMISSION_SUCCESS',
        'trackedFrom': 1000,
        'trackedTo': 2000
      });

      expect(events.length, 1);
      expect(
          events.first,
          TransmissionSuccessEvent(
              trackedFrom: DateTime.fromMillisecondsSinceEpoch(1000),
              trackedTo: DateTime.fromMillisecondsSinceEpoch(2000)));
    }, timeout: defaultTimeout);

    testWidgets('TRANSMISSION_ERROR type should call registered observer',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent",
          arguments: {'type': 'TRANSMISSION_ERROR', 'error': 'some_error'});

      expect(events.length, 1);
      expect(events.first, TransmissionErrorEvent("some_error"));
    }, timeout: defaultTimeout);

    testWidgets('LOCATION type should call registered observer',
        (tester) async {
      channelMock.unregisterCallHandler();

      List<MotionTagEvent> events = [];
      motionTag.setObserver((event) => events.add(event));
      channelMock.invokeMethod("onEvent", arguments: {
        'type': 'LOCATION',
        'timestamp': 1000,
        'latitude': 12.5,
        'longitude': 25.3,
        'horizontalAccuracy': 10.0,
        'speed': 61.2,
        'altitude': 1236.95,
        'bearing': 50.8
      });

      expect(events.length, 1);
      expect(
          events.first,
          LocationEvent(
              timestamp: DateTime.fromMillisecondsSinceEpoch(1000),
              latitude: 12.5,
              longitude: 25.3,
              horizontalAccuracy: 10.0,
              speed: 61.2,
              altitude: 1236.95,
              bearing: 50.8));
    }, timeout: defaultTimeout);
  });
}
