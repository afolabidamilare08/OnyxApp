import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/router/router.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/utils/app_colors.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onyxswap/views/support/support_view.dart';
import 'package:overlay_support/overlay_support.dart';
import 'core/constants/routeargument_key.dart';
import 'firebase_options.dart';

import 'package:onyxswap/views/onboarding/splash_screen.dart';

import 'models/push_notification_model.dart';

NavigationService _navigationService = NavigationService.I;
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
      String usdBal = double.tryParse(data['dollarAmount'])!.toStringAsFixed(5);
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
  if (message != null) {
    localNotification.onNotificationClick.stream.listen(onNotificationListener);
  } else {
    print('message in listen is null');
  }
}

RemoteMessage? messages;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  //NativeNotify.initialize(1856, 'GcRBL5gde4huDqG1rq5o7C', null, null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _firebaseMessaging;
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
      String? token = await _firebaseMessaging.getToken();
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
          setState(() {
            _notificationInfo = notification;
            //totalnotification++;
          });
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

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    precacheImage(const AssetImage('assets/splash.png'), context);
    messagingSetup();
    localNotification.initialise();
    listenToNotification();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: AppColors.backgroundColor,
                modalBackgroundColor: kPrimaryColor)),
        onGenerateRoute: AppRouter.onGenerateRoutes,
        navigatorKey: NavigationService.I.navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}


// void onNotificationListener2(NotificationResponse? event) {
//    NavigationService.I.navigateTo(NavigatorRoutes.usdtWallet, argument: {
//             RouteArgumentkeys.asset: data['asset'],
//             RouteArgumentkeys.usdtBalance: data['dollarAmount'],
//             RouteArgumentkeys.balance: data[' totalBalanceCrypto']
//           });
//}

