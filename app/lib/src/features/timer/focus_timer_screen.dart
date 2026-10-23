import 'dart:async';
import 'package:flutter/material.dart';

/// Foreground visual timer, deliberately no notifications or alarm promise.
class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key, this.timeSource});
  final DateTime Function()? timeSource;
  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen>
    with WidgetsBindingObserver {
  Duration _remaining = const Duration(minutes: 25);
  Duration _selected = const Duration(minutes: 25);
  DateTime? _deadline;
  Timer? _ticker;
  bool _finished = false;
  bool _visible = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  DateTime _now() => widget.timeSource?.call() ?? DateTime.now();
  void _update() {
    final deadline = _deadline;
    if (deadline == null) return;
    final left = deadline.difference(_now());
    setState(() {
      _remaining = left.isNegative ? Duration.zero : left;
      if (_remaining == Duration.zero) {
        _deadline = null;
        _finished = true;
        _ticker?.cancel();
      }
    });
  }

  void _schedule() {
    _ticker?.cancel();
    if (_deadline != null && _visible) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _update());
    }
  }

  void _startPause() {
    if (_deadline != null) {
      _update();
      setState(() => _deadline = null);
      _ticker?.cancel();
    } else {
      setState(() {
        if (_remaining == Duration.zero) _remaining = _selected;
        _finished = false;
        _deadline = _now().add(_remaining);
      });
      _schedule();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _visible = state == AppLifecycleState.resumed;
    if (_visible) _update();
    _schedule();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = (_remaining.inMilliseconds / 1000).ceil();
    final label =
        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: ListView(
          padding: const EdgeInsets.all(28),
          children: [
            const Text(
              'One thing at a time.',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'A quiet focus timer, without an account.',
              style: TextStyle(color: Color(0xFFB1BBCB), fontSize: 16),
            ),
            const SizedBox(height: 28),
            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final minutes in [5, 15, 25, 45])
                    ChoiceChip(
                      label: Text('$minutes min'),
                      selected: _selected.inMinutes == minutes,
                      onSelected: _deadline != null
                          ? null
                          : (_) => setState(() {
                              _selected = Duration(minutes: minutes);
                              _remaining = _selected;
                              _finished = false;
                            }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              label: 'Time remaining $label',
              excludeSemantics: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 112,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                _finished
                    ? 'Session complete. Take a breath.'
                    : _deadline != null
                    ? 'Focus in progress'
                    : 'Ready when you are',
                style: const TextStyle(color: Color(0xFFB1BBCB)),
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: _startPause,
                  icon: Icon(
                    _deadline == null ? Icons.play_arrow : Icons.pause,
                  ),
                  label: Text(
                    _deadline == null ? 'Start focus' : 'Pause timer',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _ticker?.cancel();
                    setState(() {
                      _deadline = null;
                      _remaining = _selected;
                      _finished = false;
                    });
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset timer'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Visual timer only. No sound, notification or background alarm. Keep the app open for completion feedback. Closing the app resets the session.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFB1BBCB), height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
