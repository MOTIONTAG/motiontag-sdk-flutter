import 'dart:developer';

import 'package:flutter/widgets.dart';

class Logs extends StatefulWidget {
  static const logName = 'Example App';
  static final _globalKey = GlobalKey<LogsState>(debugLabel: 'Logs');

  Logs() : super(key: _globalKey);

  static print(
    String text, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _globalKey.currentState!.print(
      '$text\n',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  LogsState createState() => LogsState();
}

class LogsState extends State<Logs> {
  final ScrollController _scrollController = ScrollController();
  String _logs = "";

  void print(
    String text, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      text,
      name: Logs.logName,
      error: error,
      stackTrace: stackTrace,
    );
    setState(() {
      _logs += text;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Text(_logs),
    );
  }
}
