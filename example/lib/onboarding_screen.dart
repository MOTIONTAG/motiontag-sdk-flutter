import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:motiontag_sdk/motiontag.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Replace with a valid token: https://api.motion-tag.de/developer/
  static const _userToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxODc3NGFiOS00ZTdjLTQyMTctODQxOC03ZWEyZmM4ZGZmMWEiLCJpc3MiOiJtb3Rpb24tdGFnIn0.vP9vff3zQxnbgMj11IJ_zc-rKF1MKztZkJfh3ICc5g0';

  PermissionStatus _locationStatus = PermissionStatus.denied;
  PermissionRequestResult _activityStatus = PermissionRequestResult.DENIED;

  @override
  void initState() {
    super.initState();
    _refreshPermissions();
  }

  Future<void> _refreshPermissions() async {
    final location = await Permission.locationAlways.status;
    final activity = Platform.isIOS
        ? PermissionRequestResult.DENIED
        : await FlutterActivityRecognition.instance.checkPermission();
    if (mounted) {
      setState(() {
        _locationStatus = location;
        _activityStatus = activity;
      });
    }
  }

  Future<void> _requestActivity() async {
    if (Platform.isIOS) {
      final sub = FlutterActivityRecognition.instance.activityStream.listen(null);
      await Future.delayed(const Duration(milliseconds: 500));
      await sub.cancel();
    } else {
      await FlutterActivityRecognition.instance.requestPermission();
    }
    final status = await FlutterActivityRecognition.instance.checkPermission();
    if (mounted) setState(() => _activityStatus = status);
  }

  Future<void> _requestLocation() async {
    // iOS 13+: must grant "When In Use" before "Always" can be requested.
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      await Permission.locationAlways.request();
      // locationAlways.request() returns immediately on iOS without blocking
      // for user input, so re-read the actual status but keep whenInUse's
      // granted result as the fallback so the tile turns green straight away.
      final always = await Permission.locationAlways.status;
      if (always.isGranted) status = always;
    }
    if (mounted) setState(() => _locationStatus = status);
  }

  Future<void> _getStarted() async {
    await MotionTag.instance.setUserToken(_userToken);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  Icon(Icons.directions_walk, size: 80, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to\nmotiontag',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We need a few permissions to track your movement and provide insights.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Spacer(),
              _PermissionTile(
                icon: Icons.location_on,
                label: 'Location Access',
                subtitle: 'Required for tracking your travels',
                status: _locationStatus,
                onTap: _requestLocation,
              ),
              const SizedBox(height: 12),
              _PermissionTile(
                icon: Icons.directions_run,
                label: 'Motion Activity',
                subtitle: 'Required for detecting transport mode',
                status: _activityStatus == PermissionRequestResult.GRANTED
                    ? PermissionStatus.granted
                    : PermissionStatus.denied,
                onTap: _requestActivity,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _locationStatus.isGranted ? _getStarted : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Get Started', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final PermissionStatus status;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final granted = status.isGranted;
    final color = granted ? Colors.green : Colors.blue;

    return Opacity(
      opacity: granted ? 0.7 : 1.0,
      child: InkWell(
        onTap: granted ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(
                granted ? Icons.check_circle : Icons.chevron_right,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
