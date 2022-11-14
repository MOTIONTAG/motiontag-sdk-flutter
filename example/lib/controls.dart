import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:motiontag_sdk_example/logs.dart';
import 'package:motiontag_sdk_example/status.dart';
import 'package:permission_handler/permission_handler.dart';

class Controls extends StatefulWidget {
  Controls({Key? key}) : super(key: key);

  @override
  ControlsState createState() => ControlsState();
}

class ControlsState extends State<Controls> {
  static final _motionTag = MotionTag.instance;

  Future<void> _executeInteraction(
      {required String logMessage, required AsyncCallback function}) async {
    Logs.print('$logMessage...');
    try {
      await function();
      Logs.print('$logMessage DONE.');
    } catch (error, stackTrace) {
      Logs.print('$logMessage ERROR. See the console logs for details',
          error: error, stackTrace: stackTrace);
    }

    Status.of(context).refresh();
  }

  void _onSetUserToken(String userToken) => _executeInteraction(
        logMessage: 'Updating the user token to $userToken',
        function: () => _motionTag.setUserToken(userToken),
      );

  void _onStart() async => _executeInteraction(
        logMessage: 'Starting the SDK',
        function: () => _motionTag.start(),
      );

  void _onStop() => _executeInteraction(
        logMessage: 'Stopping the SDK',
        function: () => _motionTag.stop(),
      );

  void _onClearData() => _executeInteraction(
        logMessage: 'Clearing data',
        function: () => _motionTag.clearData(),
      );

  void _requestPermission(
          {required String name, required Permission permission}) =>
      _executeInteraction(
        logMessage: 'Requesting $name permission',
        function: () async {
          final permissionStatus = await permission.request();
          Logs.print('Permission status: ${permissionStatus.toString()}');
        },
      );

  void _onRequestActivityRecognitionPermission() => _requestPermission(
        name: 'activity recognition',
        permission: Permission.activityRecognition,
      );
  void _onRequestLocationInUsePermission() => _requestPermission(
        name: 'location (in use)',
        permission: Permission.locationWhenInUse,
      );
  void _onRequestLocationAlwaysPermission() => _requestPermission(
        name: 'location (always)',
        permission: Permission.locationAlways,
      );
  void _onRequestMotionSensorPermission() => _requestPermission(
        name: 'motion',
        permission: Permission.sensors,
      );

  @override
  Widget build(BuildContext context) {
    return ControlsLayout(
      interactionEnabled: true,
      onSetUserToken: _onSetUserToken,
      onStart: _onStart,
      onStop: _onStop,
      onClearData: _onClearData,
      onRequestActivityRecognitionPermission:
          _onRequestActivityRecognitionPermission,
      onRequestLocationInUsePermission: _onRequestLocationInUsePermission,
      onRequestLocationAlwasPermission: _onRequestLocationAlwaysPermission,
      onRequestMotionSensorPermission: _onRequestMotionSensorPermission,
    );
  }
}

class ControlsLayout extends StatelessWidget {
  final bool interactionEnabled;
  final void Function(String userToken) onSetUserToken;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onClearData;
  final VoidCallback onRequestActivityRecognitionPermission;
  final VoidCallback onRequestLocationInUsePermission;
  final VoidCallback onRequestLocationAlwasPermission;
  final VoidCallback onRequestMotionSensorPermission;

  const ControlsLayout({
    required this.interactionEnabled,
    required this.onSetUserToken,
    required this.onStart,
    required this.onStop,
    required this.onClearData,
    required this.onRequestActivityRecognitionPermission,
    required this.onRequestLocationInUsePermission,
    required this.onRequestLocationAlwasPermission,
    required this.onRequestMotionSensorPermission,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserTokenRow(
          enabled: interactionEnabled,
          onSetUserToken: onSetUserToken,
        ),
        Wrap(
          spacing: 20,
          alignment: WrapAlignment.center,
          children: [
            if (defaultTargetPlatform == TargetPlatform.android)
              ActionButton(
                enabled: interactionEnabled,
                text: 'Activity recognition',
                onPressed: onRequestActivityRecognitionPermission,
              ),
            if (defaultTargetPlatform == TargetPlatform.iOS)
              ActionButton(
                enabled: interactionEnabled,
                text: 'Motion sensor',
                onPressed: onRequestMotionSensorPermission,
              ),
            ActionButton(
              enabled: interactionEnabled,
              text: 'Location (in use)',
              onPressed: onRequestLocationInUsePermission,
            ),
            ActionButton(
              enabled: interactionEnabled,
              text: 'Location (always)',
              onPressed: onRequestLocationAlwasPermission,
            ),
            ActionButton(
              enabled: interactionEnabled,
              text: 'Start',
              onPressed: onStart,
            ),
            ActionButton(
              enabled: interactionEnabled,
              text: 'Stop',
              onPressed: onStop,
            ),
            ActionButton(
              enabled: interactionEnabled,
              text: 'Clear',
              onPressed: onClearData,
            ),
          ],
        )
      ],
    );
  }
}

class UserTokenRow extends StatelessWidget {
  final bool enabled;
  final void Function(String userToken) onSetUserToken;

  final _textEditingController = TextEditingController();

  UserTokenRow({
    required this.enabled,
    required this.onSetUserToken,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: enabled,
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'User token'),
          ),
        ),
        ActionButton(
          enabled: enabled,
          text: 'Save',
          onPressed: () {
            var userTokenText = _textEditingController.text;
            if (userTokenText.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('userToken missing')),
              );
            } else {
              onSetUserToken(userTokenText);
            }
          },
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final bool? enabled;
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    required this.text,
    required this.onPressed,
    this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled != false ? onPressed : null,
      child: Text(text),
    );
  }
}
