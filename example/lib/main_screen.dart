import 'package:flutter/material.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:motiontag_sdk/events/started_event.dart';
import 'package:motiontag_sdk/events/stopped_event.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isTracking = false;
  bool _wifiOnly = false;
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadState();
    MotionTag.instance.setObserver(_onEvent);
  }

  @override
  void dispose() {
    MotionTag.instance.setObserver(null);
    _scrollController.dispose();
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
    setState(() {
      if (event is StartedEvent) {
        _isTracking = true;
        _logs.add('▶ Tracking started');
      } else if (event is StoppedEvent) {
        _isTracking = false;
        _logs.add('■ Tracking stopped');
      } else {
        _logs.add(event.toString());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('motiontag SDK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('flutter example app', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Tracking status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isTracking ? Icons.location_on : Icons.location_off,
                        key: ValueKey(_isTracking),
                        size: 24,
                        color: _isTracking ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _isTracking ? 'Tracking Active' : 'Tracking Inactive',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _isTracking ? null : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // SDK event log
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _logs.isEmpty
                      ? Text(
                          'SDK events will appear here...',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _logs.length,
                          itemBuilder: (context, index) => Text(
                            _logs[index],
                            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

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
