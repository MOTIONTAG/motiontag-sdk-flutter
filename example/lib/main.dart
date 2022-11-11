import 'package:flutter/material.dart';
import 'package:motiontag_sdk_example/controls.dart';
import 'package:motiontag_sdk_example/logs.dart';
import 'package:motiontag_sdk_example/status.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MOTIONTAG SDK example'),
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Status(),
                Divider(
                  color: Colors.black,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Logs(),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Controls(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
