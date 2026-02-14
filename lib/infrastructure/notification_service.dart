import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(settings);
  }

  Future<void> scheduleNotification(
      DateTime targetTime) async {
    await _plugin.zonedSchedule(
      0,
      'Pomodoro beendet',
      'Zeit für die nächste Phase 🍅',
      tz.TZDateTime.from(targetTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_channel',
          'Pomodoro',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel() async {
    await _plugin.cancelAll();
  }
}