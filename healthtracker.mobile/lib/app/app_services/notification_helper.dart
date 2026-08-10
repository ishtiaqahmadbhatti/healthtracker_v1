import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._init();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isRinging = false;
  final Map<int, Timer> _activeTimers = {};

  NotificationHelper._init();

  Future<void> initialize() async {
    if (_isInitialized) return;

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
      },
    );

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  // Play continuous loud alarm ringtone in loop mode
  Future<void> playAlarmRingtone() async {
    try {
      _isRinging = true;
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // High quality digital watch / alarm clock sound source
      await _audioPlayer.play(
        UrlSource("https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg"),
      );
    } catch (e) {
      debugPrint("Error playing alarm ringtone: $e");
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

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'vitals_alarm_channel_loud',
      'Vitals Alarm Sound Reminders',
      channelDescription: 'High priority channel with loud alarm ringtone for health vitals',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule an alarm with active Timer fallback for in-app ringing + system notification
  void scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime targetDateTime,
    required BuildContext? context,
  }) {
    cancelAlarmTimer(id);

    final now = DateTime.now();
    final duration = targetDateTime.difference(now);

    if (duration.isNegative) return;

    if (context != null && context.mounted) {
      final formattedTime = "${targetDateTime.hour.toString().padLeft(2, '0')}:${targetDateTime.minute.toString().padLeft(2, '0')}";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.alarm_on_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text("Alarm scheduled for $formattedTime")),
            ],
          ),
          backgroundColor: const Color(0xFF1E8D89),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    final timer = Timer(duration, () async {
      // 1. Play continuous alarm sound ringtone
      await playAlarmRingtone();

      // 2. Trigger system notification
      await showNotification(
        id: id,
        title: "⏰ ALARM: $title",
        body: body,
      );

      // 3. If app is open in foreground, show ringing dialog popup
      if (context != null && context.mounted) {
        _showAlarmRingingDialog(context, title, body);
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

  void _showAlarmRingingDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.alarm_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '⏰ ALARM RINGING!',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              onPressed: () {
                stopAlarmRingtone();
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'STOP / DISMISS ALARM',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
