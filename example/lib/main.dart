import 'package:flutter/material.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:permission_handler/permission_handler.dart';

import 'onboarding_screen.dart';
import 'main_screen.dart';

void main() => runApp(const MotionTagApp());

class MotionTagApp extends StatelessWidget {
  const MotionTagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'motiontag SDK flutter example app',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final token = await MotionTag.instance.getUserToken();
    final locationGranted = await Permission.locationAlways.isGranted;
    if (mounted) {
      setState(() => _onboardingComplete =
          token != null && token.isNotEmpty && locationGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingComplete == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_onboardingComplete!) {
      return const MainScreen();
    }
    return OnboardingScreen(onComplete: () => setState(() => _onboardingComplete = true));
  }
}
