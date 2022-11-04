import 'package:flutter_test/flutter_test.dart';
import 'package:motiontag/motiontag.dart';

import 'channel_mock.dart';

void main() {
  final timeout = Timeout(Duration(seconds: 5));
  final channelMock = ChannelMock('de.motiontag.tracker');

  setUp(() {
    channelMock.reset();
  });

  testWidgets('getUserToken should return value using channel', (tester) async {
    channelMock.mockMethod('getUserToken', returnValue: 'some_user_token');

    final userToken = await MotionTag.instance.getUserToken();

    expect(userToken, 'some_user_token');
  }, timeout: timeout);

  testWidgets('setUserToken should set value using channel', (tester) async {
    channelMock.mockMethod('setUserToken');

    await MotionTag.instance.setUserToken('new_user_token');

    expect(channelMock.passedArguments, {'userToken': 'new_user_token'});
  }, timeout: timeout);
}
