import 'package:flutter/widgets.dart';
import 'package:motiontag/motiontag.dart';
import 'package:motiontag_example/logs.dart';

class Status extends StatefulWidget {
  static final _globalKey = GlobalKey<StatusState>();

  Status() : super(key: _globalKey);

  static StatusState of(BuildContext context) => _globalKey.currentState!;

  @override
  State<StatefulWidget> createState() => StatusState();
}

class StatusState extends State<Status> {
  static final _motionTag = MotionTag.instance;

  bool _isRefetching = false;
  String? _userToken;
  bool? _isTrackingActive;

  @override
  void initState() {
    super.initState();
    MotionTag.instance.setObserver((event) => Logs.print(event.toString()));
  }

  @override
  void didChangeDependencies() {
    refresh();
    super.didChangeDependencies();
  }

  void refresh() async {
    // If there is a reload in progress, ignore the current request
    if (_isRefetching) return;

    setState(() {
      _isRefetching = true;
    });

    final userToken = await _motionTag.getUserToken();
    final isTrackingActive = await _motionTag.isTrackingActive();

    setState(() {
      _isRefetching = false;
      _userToken = userToken;
      _isTrackingActive = isTrackingActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isRefetching;

    return Column(
      children: [
        StatusProperty('userToken', _userToken, isLoading: isLoading),
        StatusProperty('isTrackingActive',
            _isTrackingActive != null ? _isTrackingActive.toString() : null,
            isLoading: isLoading),
      ],
    );
  }
}

class StatusProperty extends StatelessWidget {
  static const nameStyle = TextStyle(fontWeight: FontWeight.bold);
  static const valueNotAvailableStyle = TextStyle(fontStyle: FontStyle.italic);

  final bool isLoading;
  final String name;
  final String? value;

  const StatusProperty(
    this.name,
    this.value, {
    Key? key,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$name: ',
          style: nameStyle,
        ),
        Expanded(
          child: isLoading
              ? Text('<loading>', style: valueNotAvailableStyle)
              : value == null
                  ? Text('<null>', style: valueNotAvailableStyle)
                  : Text(value!),
        ),
      ],
    );
  }
}
