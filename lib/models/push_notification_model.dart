import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationModel {
  PushNotificationModel({this.title, this.body});
  String? body;
  String? title;
}

class LocalNotification {
  static final notifications = FlutterLocalNotificationsPlugin();
  BehaviorSubject<NotificationResponse?> onNotificationClick =
      BehaviorSubject<NotificationResponse?>();
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'description',
          //'channel description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> initialise() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      await notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('onDidReceiveLocalNotification called');
  }

  void onSelectNotification(NotificationResponse? details) {
    if (details != null) {
      onNotificationClick.add(details);
    }
  }
}
