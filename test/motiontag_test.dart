import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motiontag/motiontag.dart';
import 'package:motiontag/motiontag_events.dart';

import 'channel_mock.dart';

void main() {
  final defaultTimeout = Timeout(Duration(seconds: 5));
  final channelMock = ChannelMock('de.motiontag.tracker');

  setUp(() {
    channelMock.reset();
  });

  testWidgets('calling getUserToken should return value using channel',
      (tester) async {
    channelMock.mockMethod('getUserToken', returnValues: ['some_user_token']);

    final userToken = await MotionTag.instance.getUserToken();

    var calls = channelMock.methodCalls;
    expect(calls.length, 1);
    expect(calls.first.method, 'getUserToken');
    expect(userToken, 'some_user_token');
  }, timeout: defaultTimeout);

  testWidgets('calling setUserToken should set value using channel',
      (tester) async {
    channelMock.mockMethod('setUserToken');

    await MotionTag.instance.setUserToken('new_user_token');

    var calls = channelMock.methodCalls;
    expect(calls.length, 1);
    expect(calls.first.method, 'setUserToken');
    expect(calls.first.arguments['userToken'], 'new_user_token');
  }, timeout: defaultTimeout);

  testWidgets('calling start should use channel', (tester) async {
    channelMock.mockMethod('isTrackingActive', returnValues: [true]);
    channelMock.mockMethod('start');

    await MotionTag.instance.start();

    var calls = channelMock.methodCalls;
    expect(calls.length, 2);
    expect(calls.first.method, 'isTrackingActive');
    expect(calls.last.method, 'start');
  }, timeout: defaultTimeout);

  testWidgets('start should callback event if was not active and is Android',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    channelMock.mockMethod('isTrackingActive', returnValues: [false, true]);
    channelMock.mockMethod('start');

    List<MotionTagEvent> events = [];
    MotionTag.instance.setObserver((event) => events.add(event));
    await MotionTag.instance.start();

    expect(events.length, 1);
    expect(events.first.type, MotionTagEventType.started);

    debugDefaultTargetPlatformOverride = null;
  }, timeout: defaultTimeout);

  testWidgets(
      'start should not callback event if was not active and is not Android',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    channelMock.mockMethod('isTrackingActive', returnValues: [false, true]);
    channelMock.mockMethod('start');

    List<MotionTagEvent> events = [];
    MotionTag.instance.setObserver((event) => events.add(event));
    await MotionTag.instance.start();

    expect(events.length, 0);

    debugDefaultTargetPlatformOverride = null;
  }, timeout: defaultTimeout);
}
