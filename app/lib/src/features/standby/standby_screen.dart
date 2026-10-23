import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../core/burn_in_protection.dart';
import '../../core/night_mode_policy.dart';
import '../../domain/standby_models.dart';
import '../../state/standby_controller.dart';
import '../timer/focus_timer_screen.dart';
import 'widgets/clock_faces.dart';
import 'widgets/integration_cards.dart';

class StandbyScreen extends StatefulWidget {
  const StandbyScreen({super.key, this.initialSettings, this.controller});
  final StandbySettings? initialSettings;
  final StandbyController? controller;
  @override
  State<StandbyScreen> createState() => _StandbyScreenState();
}

class _StandbyScreenState extends State<StandbyScreen> {
  late final StandbyController _controller;
  int _page = 0;
  bool _quiet = false;
  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        StandbyController(
          initialSettings: widget.initialSettings,
          autostartTicker: widget.initialSettings == null,
        );
    if (widget.controller == null) {
      if (widget.initialSettings == null) {
        _controller.initialize();
      } else {
        _controller.initializeForTest();
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final s = _controller.settings;
      return Scaffold(
        backgroundColor: s.theme.backgroundColor,
        appBar: _quiet
            ? null
            : AppBar(
                backgroundColor: s.theme.backgroundColor,
                title: const Text(
                  'Standby Pro',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                actions: [
                  if (_page == 0)
                    IconButton(
                      tooltip: 'Quiet display',
                      icon: const Icon(Icons.fullscreen),
                      onPressed: () => setState(() => _quiet = true),
                    ),
                  IconButton(
                    tooltip: 'About and data status',
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const _AboutScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
        body: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: _page,
                children: [
                  _Display(controller: _controller),
                  _Layouts(
                    controller: _controller,
                    onSelected: () => setState(() => _page = 0),
                  ),
                  const FocusTimerScreen(),
                  _Settings(controller: _controller),
                ],
              ),
              if (_quiet)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: IconButton.filledTonal(
                    tooltip: 'Show controls',
                    icon: const Icon(Icons.fullscreen_exit),
                    onPressed: () => setState(() => _quiet = false),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: _quiet
            ? null
            : NavigationBar(
                height:
                    80 +
                    (MediaQuery.textScalerOf(context).scale(14) - 14).clamp(
                          0,
                          42,
                        ) *
                        3,
                selectedIndex: _page,
                onDestinationSelected: (value) => setState(() => _page = value),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.nightlight_outlined),
                    selectedIcon: Icon(Icons.nightlight),
                    label: 'Display',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: 'Layouts',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.timer_outlined),
                    selectedIcon: Icon(Icons.timer),
                    label: 'Timer',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.tune),
                    label: 'Settings',
                  ),
                ],
              ),
      );
    },
  );
}

class _Display extends StatelessWidget {
  const _Display({required this.controller});
  final StandbyController controller;
  @override
  Widget build(BuildContext context) {
    final s = controller.settings;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        WidgetsBinding
            .instance
            .platformDispatcher
            .accessibilityFeatures
            .reduceMotion;
    final offset = reduceMotion
        ? OffsetSnapshot.zero
        : BurnInProtection.offsetForTick(controller.burnInTick, s);
    final tint = NightModePolicy.shouldTint(controller.now, s);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final height = textScale > 1.4
            ? math.max(constraints.maxHeight, 420 * textScale)
            : constraints.maxHeight;
        return SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('EEEE, d MMMM').format(controller.now),
                              style: TextStyle(
                                color: s.theme.foregroundColor.withValues(
                                  alpha: .8,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.theme.name,
                            style: TextStyle(color: s.theme.accentColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(offset.dx, offset.dy),
                          child: LayoutBuilder(
                            builder: (context, c) {
                              final cards = [
                                Expanded(
                                  child: _Surface(
                                    child: _widget(context, s.leftWidget),
                                  ),
                                ),
                                if (s.layoutMode == StandbyLayoutMode.duo) ...[
                                  const SizedBox(width: 16, height: 16),
                                  Expanded(
                                    child: _Surface(
                                      child: _widget(context, s.rightWidget),
                                    ),
                                  ),
                                ],
                              ];
                              return c.maxWidth > c.maxHeight * 1.35
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: cards,
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: cards,
                                    );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        tint
                            ? 'Night tint · scheduled 20:00–07:00'
                            : 'Your bedside, at a glance',
                        style: TextStyle(
                          color: s.theme.foregroundColor.withValues(alpha: .6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (tint)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Colors.red.withValues(
                          alpha: .18 * s.nightTintIntensity,
                        ),
                      ),
                    ),
                  ),
                if (s.brightness < 1)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Colors.black.withValues(
                          alpha: (1 - s.brightness) * .65,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _widget(BuildContext context, StandbyWidgetType type) {
    final s = controller.settings;
    if (type == StandbyWidgetType.clock) {
      return Semantics(
        label:
            'Current time ${DateFormat(s.use24HourTime ? (s.showSeconds ? 'HH:mm:ss' : 'HH:mm') : (s.showSeconds ? 'h:mm:ss a' : 'h:mm a')).format(controller.now)}',
        excludeSemantics: true,
        child: LayoutBuilder(
          builder: (context, c) => Center(
            child: SizedBox(
              width: c.maxWidth,
              height: c.maxHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 520,
                  height: 260,
                  child: Center(
                    child: ClockFace(time: controller.now, settings: s),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight),
          child: Center(
            child: switch (type) {
              StandbyWidgetType.weather => WeatherCard(
                snapshot: controller.snapshots.weather,
                settings: s,
                isLive: controller.weatherIsLive,
                loading: controller.weatherLoading,
                error: controller.weatherError,
                onRefresh: controller.refreshWeather,
              ),
              StandbyWidgetType.calendar => CalendarCard(
                snapshot: controller.snapshots.calendar,
                settings: s,
                now: controller.now,
              ),
              StandbyWidgetType.music => MusicCard(
                snapshot: controller.snapshots.nowPlaying,
                settings: s,
                onCommand: controller.sendMediaCommand,
              ),
              StandbyWidgetType.clock => const SizedBox(),
            },
          ),
        ),
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1119),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF222936)),
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    ),
  );
}

class _Layouts extends StatelessWidget {
  const _Layouts({required this.controller, required this.onSelected});
  final StandbyController controller;
  final VoidCallback onSelected;
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Make room for rest.',
    subtitle: 'Start with a layout, then make it yours in Settings.',
    children: [
      for (final preset in [
        (
          'Just the time',
          'One generous clock. Nothing to catch up on.',
          Icons.schedule,
          StandbyLayoutMode.single,
          StandbyWidgetType.clock,
          ClockStyle.digital,
        ),
        (
          'Time & weather',
          'A clock beside weather you choose to enable.',
          Icons.cloud_outlined,
          StandbyLayoutMode.duo,
          StandbyWidgetType.weather,
          ClockStyle.digital,
        ),
        (
          'Flip bedside',
          'The original flip face, with space to breathe.',
          Icons.flip,
          StandbyLayoutMode.single,
          StandbyWidgetType.clock,
          ClockStyle.flip,
        ),
        (
          'Analog calm',
          'A familiar dial in your current colour theme.',
          Icons.watch_later_outlined,
          StandbyLayoutMode.single,
          StandbyWidgetType.clock,
          ClockStyle.analog,
        ),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Icon(
                preset.$3,
                color: controller.settings.theme.accentColor,
                size: 32,
              ),
              title: Text(
                preset.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(preset.$2),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                controller.updateSettings(
                  controller.settings.copyWith(
                    layoutMode: preset.$4,
                    leftWidget: StandbyWidgetType.clock,
                    rightWidget: preset.$5,
                    clockStyle: preset.$6,
                  ),
                );
                onSelected();
              },
            ),
          ),
        ),
      const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Four original themes · Four clock faces\nNo accounts, ads or photo access.',
          style: TextStyle(color: Color(0xFFB1BBCB), height: 1.7),
        ),
      ),
    ],
  );
}

class _Settings extends StatelessWidget {
  const _Settings({required this.controller});
  final StandbyController controller;
  @override
  Widget build(BuildContext context) {
    final s = controller.settings;
    void save(StandbySettings v) {
      controller.updateSettings(v);
    }

    return _Page(
      title: 'A display that fits you.',
      subtitle: 'Changes apply immediately and stay on this device.',
      children: [
        if (controller.persistenceError != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.persistenceError!,
                    style: const TextStyle(color: Color(0xFFFFB4AB)),
                  ),
                  TextButton(
                    onPressed: () => save(s),
                    child: const Text('Retry saving settings'),
                  ),
                ],
              ),
            ),
          ),
        const _Section('Display'),
        _Choice<StandbyLayoutMode>(
          label: 'Layout',
          value: s.layoutMode,
          items: {
            StandbyLayoutMode.single: 'Single focus',
            StandbyLayoutMode.duo: 'Duo',
          },
          onChanged: (v) => save(s.copyWith(layoutMode: v)),
        ),
        _Choice<StandbyWidgetType>(
          label: 'First widget',
          value: s.leftWidget,
          items: _widgetNames,
          onChanged: (v) => save(s.copyWith(leftWidget: v)),
        ),
        if (s.layoutMode == StandbyLayoutMode.duo)
          _Choice<StandbyWidgetType>(
            label: 'Second widget',
            value: s.rightWidget,
            items: _widgetNames,
            onChanged: (v) => save(s.copyWith(rightWidget: v)),
          ),
        _Choice<ClockStyle>(
          label: 'Clock face',
          value: s.clockStyle,
          items: {
            ClockStyle.digital: 'Digital',
            ClockStyle.analog: 'Analog',
            ClockStyle.flip: 'Flip',
            ClockStyle.text: 'Text',
          },
          onChanged: (v) => save(s.copyWith(clockStyle: v)),
        ),
        _Choice<String>(
          label: 'Colour theme',
          value: s.theme.id,
          items: {for (final t in standbyThemes) t.id: t.name},
          onChanged: (v) => save(s.copyWith(activeThemeId: v)),
        ),
        SwitchListTile(
          title: const Text('24-hour clock'),
          value: s.use24HourTime,
          onChanged: (v) => save(s.copyWith(use24HourTime: v)),
        ),
        SwitchListTile(
          title: const Text('Show seconds'),
          subtitle: const Text(
            'Updates once per second instead of each minute.',
          ),
          value: s.showSeconds,
          onChanged: (v) => save(s.copyWith(showSeconds: v)),
        ),
        const _Section('Bedside comfort'),
        _Slider(
          label: 'Display brightness',
          value: s.brightness,
          min: .08,
          max: 1,
          onChanged: (v) => save(s.copyWith(brightness: v)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'App-local dimming always applies to the display. Native window brightness is attempted on Android; system support varies.',
            style: TextStyle(color: Color(0xFFB1BBCB)),
          ),
        ),
        _Slider(
          label: 'Clock glow',
          value: s.glowIntensity,
          min: 0,
          max: .9,
          onChanged: (v) => save(s.copyWith(glowIntensity: v)),
        ),
        SwitchListTile(
          title: const Text('Night tint'),
          subtitle: const Text(
            'Warm red overlay from 20:00 to 07:00, local time.',
          ),
          value: s.nightModeEnabled,
          onChanged: (v) => save(s.copyWith(nightModeEnabled: v)),
        ),
        SwitchListTile(
          title: const Text('Gentle pixel shift'),
          subtitle: const Text(
            'Moves the display slightly. Does not guarantee burn-in prevention. Turn off to keep the display still.',
          ),
          value: s.burnInProtection,
          onChanged: (v) => save(s.copyWith(burnInProtection: v)),
        ),
        SwitchListTile(
          title: const Text('Keep screen on while open'),
          subtitle: const Text(
            'Android foreground window only. No charging detection, background or lock-screen support; unavailable on iOS/web.',
          ),
          value: s.keepAwakeWhileCharging,
          onChanged: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? (v) => save(s.copyWith(keepAwakeWhileCharging: v))
              : null,
        ),
        if (controller.systemError != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              controller.systemError!,
              style: const TextStyle(color: Color(0xFFB1BBCB)),
            ),
          ),
        const _Section('Weather & privacy'),
        SwitchListTile(
          title: const Text('Enable weather requests'),
          subtitle: const Text(
            'Optional. Sends your selected city coordinates and IP address to Open-Meteo. Free endpoint for noncommercial use.',
          ),
          value: s.weatherEnabled,
          onChanged: (v) => save(s.copyWith(weatherEnabled: v)),
        ),
        _Choice<String>(
          label: 'Weather city',
          value: s.weatherCity,
          items: {
            for (final city in ['London', 'New York', 'Tokyo', 'Sydney'])
              city: city,
          },
          onChanged: (v) => save(s.copyWith(weatherCity: v)),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Weather data: Open-Meteo · CC BY 4.0\nopen-meteo.com · No GPS or calendar permission is requested. Calendar and audio cards are clearly marked samples.',
            style: TextStyle(color: Color(0xFFB1BBCB), height: 1.6),
          ),
        ),
        TextButton.icon(
          onPressed: () => save(const StandbySettings()),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Restore default display settings'),
        ),
      ],
    );
  }
}

const _widgetNames = {
  StandbyWidgetType.clock: 'Clock',
  StandbyWidgetType.weather: 'Weather',
  StandbyWidgetType.calendar: 'Sample calendar',
  StandbyWidgetType.music: 'Audio status',
};

class _Page extends StatelessWidget {
  const _Page({
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final String title, subtitle;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFB1BBCB),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          ...children,
        ],
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
    child: Text(
      label,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    ),
  );
}

class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: DropdownButtonFormField<T>(
      initialValue: value,
      key: ValueKey('$label-$value'),
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final item in items.entries)
          DropdownMenuItem(value: item.key, child: Text(item.value)),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    ),
  );
}

class _Slider extends StatelessWidget {
  const _Slider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final double value, min, max;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Text('$label · ${(value * 100).round()}%'),
      ),
      Slider(
        label: '$label ${(value * 100).round()}%',
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    ],
  );
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('About Standby Pro')),
    body: _Page(
      title: 'A quieter place for time.',
      subtitle:
          'Standby Pro 1.1.0 preview · open-source Flutter bedside display.',
      children: [
        const _Section('What works here'),
        const Text(
          'Four original clock faces and themes, Single/Duo layouts, local preferences, optional city weather and a foreground visual focus timer. Keep the app open to use the display. This app does not replace Apple’s system StandBy, run a background alarm or read your calendar/media library.',
          style: TextStyle(fontSize: 16, height: 1.7),
        ),
        const _Section('Data status'),
        const Text(
          'Clock: device local time.\nWeather: optional Open-Meteo requests for a selected city; timestamps and failures are shown.\nCalendar: labelled sample events only.\nAudio: unavailable metadata; no playback is started.\nPreferences: stored on this device, no account or analytics.',
          style: TextStyle(fontSize: 16, height: 1.8),
        ),
        const _Section('Platform & comfort'),
        const Text(
          'Android can request screen-on and window brightness while this app is visible. iOS and web use app-local dimming; keep-awake is unavailable. Physical phone, charging, signing, battery and long-run OLED checks remain open. Pixel shift is only a mitigation. Reduce glow and brightness for comfort; settings stay accessible outside Quiet display.',
          style: TextStyle(fontSize: 16, height: 1.7),
        ),
        const _Section('Source & licences'),
        const SelectableText(
          'github.com/Ghostzy0/standby-pro\nMIT original source · Flutter and package licences in the licence screen. Weather data: Open-Meteo, CC BY 4.0; free API for noncommercial use. No competitor artwork is bundled.',
          style: TextStyle(fontSize: 16, height: 1.7),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => showLicensePage(
            context: context,
            applicationName: 'Standby Pro',
            applicationVersion: '1.1.0 preview',
          ),
          child: const Text('Open-source licences'),
        ),
      ],
    ),
  );
}
