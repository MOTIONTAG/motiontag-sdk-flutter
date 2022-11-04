import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class ChannelMock {
  late final MethodChannel _channel;
  final String _channelName;
  Map<String, List<dynamic>> mockedMethods = {};
  List<MethodCall> methodCalls = [];

  ChannelMock(this._channelName) {
    _channel = MethodChannel(_channelName);

    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(
            _channel, (MethodCall methodCall) => handler(methodCall));
  }

  dynamic handler(MethodCall methodCall) {
    if (mockedMethods.containsKey(methodCall.method)) {
      methodCalls.add(methodCall);
      var returnValues = mockedMethods[methodCall.method];
      dynamic returnValue;
      if (returnValues?.isNotEmpty == true) {
        returnValue = returnValues?.first;
        returnValues?.removeAt(0);
      }
      return Future.value(returnValue);
    }
    return Future.value(null);
  }

  void mockMethod(String methodName, {List<dynamic>? returnValues}) {
    mockedMethods[methodName] = returnValues ?? [];
  }

  void reset() {
    mockedMethods = {};
    methodCalls = [];
  }
}
