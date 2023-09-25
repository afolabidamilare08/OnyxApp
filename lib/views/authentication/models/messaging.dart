import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/constants/routeargument_key.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../data/local/local_cache/local_cache.dart';
import '../../../models/push_notification_model.dart';
import '../../../utils/locator.dart';

class MessagingSetup extends ChangeNotifier {
  NavigationService _navigationService = NavigationService.I;
  String? token;
  Future<void> handlingBackgroundMessage(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    // listenToNotification();
    // _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
  }

  LocalNotification localNotification = LocalNotification();
  void onNotificationListener(
    NotificationResponse? event,
  ) {
    //_navigationService.navigateTo(NavigatorRoutes.nairaWallet);
    if (event != null && event.payload != null) {
      var data = json.decode(event.payload!);
      print(data);
      //print(message.data);
      if (data['asset'] == 'NAIRA') {
        _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
      } else {
        String usdBal =
            double.tryParse(data['dollarAmount'])!.toStringAsFixed(5);
        NavigationService.I.navigateTo(NavigatorRoutes.usdtWallet, argument: {
          RouteArgumentkeys.asset: data['asset'],
          RouteArgumentkeys.usdtBalance: usdBal,
          RouteArgumentkeys.balance: data['totalBalanceCrypto']
        });
      }
    } else {
      print('event is null');
    }
  }

  void listenToNotification() {
    // if(message.notification != null&& message.notification!.body!.contains('BTC')) {
    //   print('recieved message, onMessage');
    //   _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
    // }

    localNotification.onNotificationClick.stream.listen(onNotificationListener);
  }

  RemoteMessage? messages;
   late FirebaseMessaging _firebaseMessaging;
  PushNotificationModel? _notificationInfo;

  void messagingSetup() async {
    Firebase.initializeApp();

    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(handlingBackgroundMessage);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      LocalCache localCache = locator<LocalCache>();
       token = await _firebaseMessaging.getToken();
      if (token != null) {
        await localCache.saveToLocalCache(
          key: 'firebaseToken',
          value: token,
        );
      }
      print('Token: $token');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        messages = message;
        PushNotificationModel notification = PushNotificationModel(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        if (notification.title != null && notification.body != null) {
          _notificationInfo = notification;
          //totalnotification++;
          notifyListeners();
          await LocalNotification.showNotification(
            // Text(notification.title!),
            title: notification.title,
            body: notification.body,
            payload: json.encode(message.data),
          );

          listenToNotification();

          //leading: NotificationBagde(notificationBadge: totalnotification));
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        var data = message.data;
        //print(data);
        print('recieved message,onMessageOpenedApp');
        messages = message;
        // _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
        // listenToNotification();
        // if (data['asset'] == 'NAIRA') {
        //   _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
        // } else {
        //   NavigationService.I.navigateTo(NavigatorRoutes.usdtWallet, argument: {
        //     RouteArgumentkeys.asset: data['asset'],
        //     RouteArgumentkeys.usdtBalance: data['dollarAmount'],
        //     RouteArgumentkeys.balance: data[' totalBalanceCrypto']
        //   });
        // }
      });
    }
  }

  MessagingSetup() {
    messagingSetup();
    localNotification.initialise();
    listenToNotification();
  }
}
