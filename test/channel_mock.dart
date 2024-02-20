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

  void registerCallHandler() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            _channel, (MethodCall methodCall) => handler(methodCall));
  }

  void unregisterCallHandler() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }

  void mockMethod(String methodName, {List<dynamic>? returnValues}) {
    mockedMethods[methodName] = returnValues ?? [];
  }

  void invokeMethod(String methodName, {dynamic arguments}) {
    var codec = StandardMethodCodec();
    var call = codec.encodeMethodCall(MethodCall(methodName, arguments));
    ServicesBinding.instance.channelBuffers.push(_channelName, call, (ByteData? data){});
  }

  void reset() {
    mockedMethods = {};
    methodCalls = [];
  }
}
