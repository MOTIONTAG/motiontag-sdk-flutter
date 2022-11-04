import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class ChannelMock {
  late final MethodChannel _channel;
  final String _channelName;
  dynamic passedArguments;

  ChannelMock(this._channelName) {
    _channel = MethodChannel(_channelName);
  }

  void mockMethod(String methodName, {dynamic returnValue}) {
    handler(MethodCall methodCall) async {
      if (methodCall.method == methodName) {
        passedArguments = methodCall.arguments;
        return returnValue;
      }
      return null;
    }

    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, handler);
  }

  void reset() {
    passedArguments = null;
  }
}
