import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> requestPermissions() async {
    // Request permissions for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showPrayerTimeNotification({
    required String prayerName,
    required String time,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'prayer_time_channel',
      'Prayer Time Notifications',
      'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adhan'),
      enableVibration: true,
      playSound: true,
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
      sound: 'adhan.wav',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      prayerName.hashCode,
      'Waktu Sholat $prayerName',
      'Saatnya melaksanakan sholat $prayerName ($time). Mari kita sholat bersama.',
      platformChannelSpecifics,
    );
  }

  static Future<void> schedulePrayerNotifications(
      Map<String, String> prayerTimes) async {
    // Cancel all existing notifications
    await _notifications.cancelAll();

    final now = DateTime.now();

    for (final entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final timeString = entry.value;

      // Skip sunrise as it's not a prayer time
      if (prayerName == 'Sunrise') continue;

      try {
        final timeParts = timeString.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        var scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // If the prayer time has already passed today, schedule for tomorrow
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        final tz.TZDateTime scheduledTZDate =
            tz.TZDateTime.from(scheduledDate, tz.local);

        await _notifications.zonedSchedule(
          prayerName.hashCode,
          'Waktu Sholat $prayerName',
          'Saatnya melaksanakan sholat $prayerName ($timeString). Mari kita sholat bersama.',
          scheduledTZDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_time_channel',
              'Prayer Time Notifications',
              'Notifications for prayer times',
              importance: Importance.high,
              priority: Priority.high,
              enableVibration: true,
              playSound: true,
            ),
            iOS: IOSNotificationDetails(),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        print('Error scheduling notification for $prayerName: $e');
      }
    }
  }

  static Future<void> showCurrentPrayerNotification({
    required String currentPrayer,
    required String nextPrayer,
    required String nextTime,
  }) async {
    await _notifications.show(
      'current_prayer'.hashCode,
      'Waktu Sholat Saat Ini',
      'Sekarang: $currentPrayer | Berikutnya: $nextPrayer ($nextTime)',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'current_prayer_channel',
          'Current Prayer Notifications',
          'Current prayer time information',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
        ),
      ),
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
