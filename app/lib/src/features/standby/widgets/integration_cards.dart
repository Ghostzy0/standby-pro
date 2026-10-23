import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/standby_models.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.snapshot,
    required this.settings,
    required this.isLive,
    this.loading = false,
    this.error,
    this.onRefresh,
  });
  final WeatherSnapshot snapshot;
  final StandbySettings settings;
  final bool isLive, loading;
  final String? error;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    final enabled = settings.weatherEnabled;
    final matching = snapshot.city == settings.weatherCity;
    final hasData = enabled && matching && isLive;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(
          icon: Icons.cloud_outlined,
          text: 'Weather',
          accent: settings.theme.accentColor,
        ),
        const SizedBox(height: 16),
        Text(
          enabled ? settings.weatherCity : 'A little outlook.',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (!enabled)
          const Text(
            'Weather is off. Enable requests and choose a city in Settings. No location permission needed.',
            style: TextStyle(color: Color(0xFFB1BBCB), height: 1.5),
          )
        else if (hasData) ...[
          Text(
            '${snapshot.temperatureCelsius}°',
            style: TextStyle(
              color: settings.theme.foregroundColor,
              fontSize: 80,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          Text(snapshot.condition, style: const TextStyle(fontSize: 18)),
          if (snapshot.highCelsius != null && snapshot.lowCelsius != null)
            Text(
              'High ${snapshot.highCelsius}° · Low ${snapshot.lowCelsius}°',
              style: const TextStyle(color: Color(0xFFB1BBCB)),
            ),
          const SizedBox(height: 12),
          Text(
            'Updated ${DateFormat('d MMM, HH:mm').format(snapshot.updatedAt.toLocal())}',
            style: const TextStyle(color: Color(0xFFB1BBCB), fontSize: 12),
          ),
        ] else if (loading)
          const Text(
            'Fetching current conditions…',
            style: TextStyle(color: Color(0xFFB1BBCB)),
          )
        else
          const Text(
            'Weather unavailable. Connect to the internet, then try again.',
            style: TextStyle(color: Color(0xFFB1BBCB), height: 1.5),
          ),
        if (enabled && error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              error!,
              style: const TextStyle(color: Color(0xFFFFB4AB), height: 1.5),
            ),
          ),
        if (enabled) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: loading ? null : onRefresh,
            icon: const Icon(Icons.refresh),
            label: Text(loading ? 'Refreshing…' : 'Refresh weather'),
          ),
          const Text(
            'Open-Meteo · CC BY 4.0\nCelsius · City selection, not GPS',
            style: TextStyle(
              color: Color(0xFFB1BBCB),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    super.key,
    required this.snapshot,
    required this.settings,
    required this.now,
  });
  final CalendarSnapshot snapshot;
  final StandbySettings settings;
  final DateTime now;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Label(
        icon: Icons.calendar_month_outlined,
        text: 'Sample calendar',
        accent: settings.theme.accentColor,
      ),
      const SizedBox(height: 16),
      Text(
        DateFormat('EEE, d MMM').format(now),
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 16),
      for (final event in snapshot.events.take(2))
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, size: 10, color: Color(0xFF7DD3FC)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${event.title}\n${DateFormat('HH:mm').format(event.startsAt)}–${DateFormat('HH:mm').format(event.endsAt)}',
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
        ),
      const Text(
        'Examples only. Device calendar is not connected and no events are read.',
        style: TextStyle(color: Color(0xFFB1BBCB), fontSize: 12, height: 1.5),
      ),
    ],
  );
}

class MusicCard extends StatelessWidget {
  const MusicCard({
    super.key,
    required this.snapshot,
    required this.settings,
    required this.onCommand,
  });
  final NowPlayingSnapshot snapshot;
  final StandbySettings settings;
  final Future<bool> Function(String command) onCommand;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Label(
        icon: Icons.headphones_outlined,
        text: 'Audio status',
        accent: settings.theme.accentColor,
      ),
      const SizedBox(height: 20),
      const Text(
        'A moment of quiet.',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      const Text(
        'Media metadata is not connected. Use your music app or system media controls for playback.',
        style: TextStyle(color: Color(0xFFB1BBCB), height: 1.6),
      ),
      const SizedBox(height: 16),
      const Text(
        'No playback is started by Standby Pro.',
        style: TextStyle(color: Color(0xFFB1BBCB), fontSize: 12),
      ),
    ],
  );
}

class _Label extends StatelessWidget {
  const _Label({required this.icon, required this.text, required this.accent});
  final IconData icon;
  final String text;
  final Color accent;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: accent),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(color: accent, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
