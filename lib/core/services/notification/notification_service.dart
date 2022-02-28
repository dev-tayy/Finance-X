import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.max,
    importance: Importance.max,
    visibility: NotificationVisibility.public,
    enableLights: true,
    fullScreenIntent: true,
    showWhen: true,
  );

  Future<void> scheduleNotifications({
    required String notificationTitle,
    required String notificationBody,
    required DateTime dueDate,
  }) async {
    final city = tz.getLocation('Africa/Lagos');
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.from(dueDate, city),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String? payload) async {}
