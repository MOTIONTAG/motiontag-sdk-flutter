import 'dart:developer';

import 'package:flutter/material.dart';

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
      text,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  LogsState createState() => LogsState();
}

class LogsState extends State<Logs> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = [];

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
      _logs.add(text);
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
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          return Text(_logs[index]);
        },
      ),
    );
  }
}
