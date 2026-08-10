import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../app_screens/alarm_ringing_screen.dart';

class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._init();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isRinging = false;
  final Map<int, Timer> _activeTimers = {};
  GlobalKey<NavigatorState>? navigatorKey;

  NotificationHelper._init();

  Future<void> initialize({GlobalKey<NavigatorState>? navKey}) async {
    if (navKey != null) {
      navigatorKey = navKey;
    }

    if (_isInitialized) return;

    // Initialize TimeZone database for exact background alarms
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        stopAlarmRingtone();
        _handleNotificationAction(response);
      },
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    _isInitialized = true;
  }

  void _handleNotificationAction(NotificationResponse response) {
    if (navigatorKey?.currentContext != null) {
      final context = navigatorKey!.currentContext!;
      final payload = response.payload ?? "";
      final parts = payload.split('|');
      final title = parts.isNotEmpty ? parts[0] : "Scheduled Alarm";
      final body = parts.length > 1 ? parts[1] : "Time for your health measurement!";
      final alarmId = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AlarmRingingScreen(
            alarmId: alarmId,
            title: title,
            body: body,
          ),
        ),
      );
    }
  }

  // Play continuous loud offline alarm ringtone in loop mode
  Future<void> playAlarmRingtone() async {
    try {
      if (_isRinging) return;
      _isRinging = true;
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      // Play 100% offline bundled alarm audio asset
      await _audioPlayer.play(
        AssetSource('sounds/alarm_ringtone.wav'),
      );
    } catch (e) {
      debugPrint("Error playing offline alarm ringtone: $e");
    }
  }

  // Stop continuous alarm sound
  Future<void> stopAlarmRingtone() async {
    try {
      _isRinging = false;
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping alarm sound: $e");
    }
  }

  // Snooze alarm for specified minutes
  Future<void> snoozeAlarm({
    required int id,
    required String title,
    required String body,
    int minutes = 5,
  }) async {
    await stopAlarmRingtone();
    final snoozeTime = DateTime.now().add(Duration(minutes: minutes));
    scheduleAlarm(
      id: id,
      title: title,
      body: body,
      targetDateTime: snoozeTime,
      context: null,
    );
  }

  // Schedule exact native background alarm + in-app timer trigger
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime targetDateTime,
    required BuildContext? context,
  }) async {
    await initialize();
    cancelAlarmTimer(id);

    final now = DateTime.now();
    final duration = targetDateTime.difference(now);

    if (duration.isNegative) return;

    if (context != null && context.mounted) {
      final formattedTime =
          "${targetDateTime.hour.toString().padLeft(2, '0')}:${targetDateTime.minute.toString().padLeft(2, '0')}";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.alarm_on_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text("⏰ Alarm scheduled for $formattedTime")),
            ],
          ),
          backgroundColor: const Color(0xFF1E8D89),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    // 1. Exact system background alarm scheduling via zonedSchedule
    try {
      final tzTarget = tz.TZDateTime.from(targetDateTime, tz.local);

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'vitals_alarm_channel_loud_v2',
        'Vitals Loud Native Alarm Clock',
        channelDescription: 'High priority channel with loud alarm ringtone for health vitals',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('alarm_ringtone'),
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
          sound: 'alarm_ringtone.wav',
          interruptionLevel: InterruptionLevel.critical,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        "⏰ ALARM: $title",
        body,
        tzTarget,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: "$title|$body|$id",
      );
    } catch (e) {
      debugPrint("Error setting exact background alarm: $e");
    }

    // 2. Foreground active timer fallback for full-screen ringing UI
    final timer = Timer(duration, () async {
      await playAlarmRingtone();

      if (context != null && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AlarmRingingScreen(
              alarmId: id,
              title: title,
              body: body,
            ),
          ),
        );
      } else if (navigatorKey?.currentContext != null) {
        Navigator.of(navigatorKey!.currentContext!).push(
          MaterialPageRoute(
            builder: (ctx) => AlarmRingingScreen(
              alarmId: id,
              title: title,
              body: body,
            ),
          ),
        );
      }
    });

    _activeTimers[id] = timer;
  }

  void cancelAlarmTimer(int id) {
    if (_activeTimers.containsKey(id)) {
      _activeTimers[id]?.cancel();
      _activeTimers.remove(id);
    }
    _notificationsPlugin.cancel(id);
    if (_isRinging) {
      stopAlarmRingtone();
    }
  }
}
