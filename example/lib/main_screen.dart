import 'package:flutter/material.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:motiontag_sdk/events/started_event.dart';
import 'package:motiontag_sdk/events/stopped_event.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isTracking = false;
  bool _wifiOnly = false;

  @override
  void initState() {
    super.initState();
    _loadState();
    MotionTag.instance.setObserver(_onEvent);
  }

  @override
  void dispose() {
    MotionTag.instance.setObserver(null);
    super.dispose();
  }

  Future<void> _loadState() async {
    final isTracking = await MotionTag.instance.isTrackingActive();
    final wifiOnly = await MotionTag.instance.getWifiOnlyDataTransfer();
    if (mounted) {
      setState(() {
        _isTracking = isTracking;
        _wifiOnly = wifiOnly;
      });
    }
  }

  void _onEvent(event) {
    if (event is StartedEvent) {
      setState(() => _isTracking = true);
    } else if (event is StoppedEvent) {
      setState(() => _isTracking = false);
    }
  }

  Future<void> _setTracking(bool value) async {
    if (value) {
      await MotionTag.instance.start();
    } else {
      await MotionTag.instance.stop();
    }
  }

  Future<void> _setWifiOnly(bool value) async {
    await MotionTag.instance.setWifiOnlyDataTransfer(value);
    if (mounted) setState(() => _wifiOnly = value);
  }

  Future<void> _logout() async {
    await MotionTag.instance.stop();
    await MotionTag.instance.clearData();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('motiontag')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Tracking status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isTracking ? Icons.location_on : Icons.location_off,
                        key: ValueKey(_isTracking),
                        size: 60,
                        color: _isTracking ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isTracking ? 'Tracking Active' : 'Tracking Inactive',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _isTracking ? null : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tracking toggle
              _ToggleCard(
                icon: Icons.cell_tower,
                label: 'Enable Tracking',
                value: _isTracking,
                onChanged: _setTracking,
                activeColor: Colors.green,
              ),

              const SizedBox(height: 12),

              // WiFi only toggle
              _ToggleCard(
                icon: Icons.wifi,
                label: 'WiFi Only Data Transfer',
                value: _wifiOnly,
                onChanged: _setWifiOnly,
                activeColor: Colors.blue,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Logout', style: TextStyle(fontSize: 16)),
                  ),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
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

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const _ToggleCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
